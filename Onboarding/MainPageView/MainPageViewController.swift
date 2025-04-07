//
//  MainPageViewController.swift
//  Onboarding
//
//  Created by Andrii Stetsenko on 07.04.2025.
//

import UIKit
import SnapKit

protocol MainPageViewControllerDisplayLogic: AnyObject {
    func showOnboarding(questions: [Question])
}

// MARK: - MainPageViewController
class MainPageViewController: UIPageViewController {
    private var pages = [UIViewController]()
    private var currentPageIndex = 0
    private var finalViewController: UIViewController?
    
    private var presenter: MainPagePresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupView()
        delegate = self
        presenter?.onAppear()
    }
    
    private func setupView() {
        self.presenter = MainPagePresenter(view: self)
    }
}

// MARK: - UIPageViewControllerDelegate
extension MainPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleViewController = pageViewController.viewControllers?.first {
            if let questionVC = visibleViewController as? QuestionViewController {
                currentPageIndex = questionVC.pageIndex
            } else if visibleViewController == finalViewController {
                currentPageIndex = pages.count - 1
            }
        }
    }
}

// MARK: - PageNavigationDelegate
extension MainPageViewController: PageNavigationDelegate {
    func goToNextPage() {
        if currentPageIndex < pages.count - 1 {
            setViewControllers([pages[currentPageIndex + 1]], direction: .forward, animated: true) { [weak self] completed in
                if completed, let self = self {
                    self.currentPageIndex += 1
                }
            }
        } else {
            print("🎉 Onboarding is complete!")
        }
    }
}

// MARK: - Extension MainPageViewController for working with mock service
extension MainPageViewController {
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}

extension MainPageViewController: MainPageViewControllerDisplayLogic {
    func showOnboarding(questions: [Question]) {
        self.pages = []
        
        for (index, question) in questions.enumerated() {
            let questionVC = QuestionViewController(question: question)
            questionVC.pageIndex = index
            questionVC.pageDelegate = self
            self.pages.append(questionVC)
        }
        
        let premiumVC = PremiumViewController()
        self.finalViewController = premiumVC
        self.pages.append(premiumVC)
        
        if let firstVC = self.pages.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
}
