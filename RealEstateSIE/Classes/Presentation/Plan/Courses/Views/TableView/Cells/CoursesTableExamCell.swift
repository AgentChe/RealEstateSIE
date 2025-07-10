//
//  CoursesTableExamCell.swift
//  ITExams
//
//  Created by Андрей Чернышев on 26.04.2022.
//

import UIKit

final class CoursesTableExamCell: UITableViewCell {
    lazy var label = makeLabel()
    lazy var arrowView = makeArrowView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CoursesTableExamCell {
    func setup(title: String, isOpened: Bool) {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.semiBold(size: 17.scale))
            .lineHeight(20.4.scale)
            .letterSpacing(-0.44.scale)
        label.attributedText = title.attributed(with: attrs)
        
        let arrowIconName = isOpened ? "Courses.Arrow.Down" : "Courses.Arrow.Up"
        arrowView.image = UIImage(named: arrowIconName)
    }
}

// MARK: Private
private extension CoursesTableExamCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension CoursesTableExamCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.scale),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50.scale),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2.scale),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2.scale)
        ])
        
        NSLayoutConstraint.activate([
            arrowView.widthAnchor.constraint(equalToConstant: 24.scale),
            arrowView.heightAnchor.constraint(equalToConstant: 24.scale),
            arrowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.scale),
            arrowView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CoursesTableExamCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeArrowView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
