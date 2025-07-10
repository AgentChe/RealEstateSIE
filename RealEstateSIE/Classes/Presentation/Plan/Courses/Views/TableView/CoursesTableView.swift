//
//  CoursesTableView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 26.04.2022.
//

import UIKit

final class CoursesTableView: UITableView {
    private(set) lazy var elements = [CoursesTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CoursesTableView {
    func setup(elements: [CoursesTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension CoursesTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .offset:
            let cell = dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))!
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        case .exam(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CoursesTableExamCell.self)) as! CoursesTableExamCell
            cell.setup(title: element.exam.title, isOpened: element.isOpened)
            return cell
        case .course(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CoursesTableCourseCell.self)) as! CoursesTableCourseCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension CoursesTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case .exam(let element):
            tapped(exam: element)
        case .course(let element):
            tapped(course: element)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard case let .offset(offset) = elements[indexPath.row] else {
            return UITableView.automaticDimension
        }
        
        return offset
    }
}

// MARK: Private
private extension CoursesTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(CoursesTableExamCell.self, forCellReuseIdentifier: String(describing: CoursesTableExamCell.self))
        register(CoursesTableCourseCell.self, forCellReuseIdentifier: String(describing: CoursesTableCourseCell.self))
        
        dataSource = self
        delegate = self
    }
    
    func tapped(exam: CoursesTableExamElement) {
        exam.isOpened.toggle()
        
        if exam.isOpened {
            open(exam: exam)
        } else {
            close(exam: exam)
        }
    }
    
    func open(exam: CoursesTableExamElement) {
        guard let examIndex = indexInElements(at: exam) else {
            return
        }
        
        let insertIndex = examIndex + 1
        
        var adding = [CoursesTableElement]()
        
        exam.courses.enumerated().forEach { index, courseElement in
            adding.append(.offset(16.scale))
            adding.append(.course(courseElement))
        }
        
        elements.insert(contentsOf: adding, at: insertIndex)
        
        reloadData()
    }
    
    func close(exam: CoursesTableExamElement) {
        guard let currentExamIndex = indexInElements(at: exam) else {
            return
        }
        
        let startIndexForTruncate = currentExamIndex + 1
        
        let afterCurrentExamElements = Array(elements[startIndexForTruncate...])
        
        let nextExamIndex = afterCurrentExamElements.firstIndex(where: { element -> Bool in
            switch element {
            case .exam:
                return true
            default:
                return false
            }
        })
        
        let endIndexForTruncate = (nextExamIndex ?? afterCurrentExamElements.count) - 1
        
        let truncated = Array(afterCurrentExamElements[0...endIndexForTruncate])
        
        let originalIndexes = truncated.enumerated().map { index, _ -> Int in
            startIndexForTruncate + index
        }
        
        guard
            !originalIndexes.isEmpty,
            let min = originalIndexes.min(),
            let max = originalIndexes.max()
        else {
            return
        }
        
        let range = ClosedRange(uncheckedBounds: (min, max))
        elements.removeSubrange(range)
        
        elements.insert(.offset(32.scale), at: startIndexForTruncate)
        
        reloadData()
    }
    
    func indexInElements(at exam: CoursesTableExamElement) -> Int? {
        return elements.firstIndex(where: { element -> Bool in
            guard case let .exam(examElement) = element else {
                return false
            }
            
            return examElement.exam.code == exam.exam.code
        })
    }
    
    func tapped(course: CoursesTableCourseElement) {
        elements.forEach { element in
            switch element {
            case .exam(let exam):
                exam.courses.forEach { $0.isSelected = false }
            default:
                break
            }
        }
        
        course.isSelected = true
        
        reloadData()
    }
}
