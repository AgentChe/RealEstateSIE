//
//  CoursesViewController.swift
//  ITExams
//
//  Created by Андрей Чернышев on 25.04.2022.
//

import UIKit
import RxSwift

final class CoursesViewController: UIViewController {
    lazy var mainView = CoursesView()
    
    private lazy var viewModel = CoursesViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.openError()
        }
        
        viewModel.elements
            .drive(onNext: { [weak self] elements in
                self?.mainView.tableView.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        mainView.cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.saveButton.rx.tap
            .compactMap { [weak self] _ -> (Exam, Course)? in
                self?.getSelected()
            }
            .bind(to: viewModel.save)
            .disposed(by: disposeBag)
        
        viewModel.saved
            .drive(Binder(self) { base, void in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.activity
            .drive(Binder(self) { base, activity in
                activity ? base.mainView.preloader.startAnimating() : base.mainView.preloader.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension CoursesViewController {
    static func make() -> CoursesViewController {
        CoursesViewController()
    }
}

// MARK: Private
private extension CoursesViewController {
    func getSelected() -> (Exam, Course)? {
        for i in 0...(mainView.tableView.elements.count - 1) {
            let element = mainView.tableView.elements[i]
            
            switch element {
            case .exam(let examElement):
                if let courseElement = examElement.courses.first(where: { $0.isSelected }) {
                    return (examElement.exam, courseElement.course)
                }
            default:
                continue
            }
        }
        
        return nil
    }
    
    func openError() -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
}
