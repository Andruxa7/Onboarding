//
//  MainPageViewController.swift
//  Onboarding
//
//  Created by Andrii Stetsenko on 07.04.2025.
//

import UIKit
import SnapKit

// MARK: - MainPageViewController
class MainPageViewController: UIPageViewController {
    
    private var pages = [UIViewController]()
    private var currentPageIndex = 0
    private var finalViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = nil
        delegate = self
        
        OnboardingService.loadOnboardingData { [weak self] onboardingData in
            guard let self = self, let onboardingData = onboardingData else { return }
            
            let questions = onboardingData.toDomain()
            
            self.pages = []
            
            for (index, question) in questions.enumerated() {
                let questionVC = QuestionViewController(question: question)
                questionVC.pageIndex = index
                questionVC.pageDelegate = self
                self.pages.append(questionVC)
            }
            
            let premiumVC = self.createPremiumViewController()
            self.finalViewController = premiumVC
            self.pages.append(premiumVC)
            
            if let firstVC = self.pages.first {
                self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
            }
        }
    }
    
    private func createPremiumViewController() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("×", for: .normal)
        closeButton.titleLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 28) ?? UIFont.systemFont(ofSize: 28, weight: .regular)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.addTarget(self, action: #selector(showOnboardingCompletedScreen), for: .touchUpInside)
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "OnboardingImage")
        
        let titleLabel = UILabel()
        titleLabel.text = "Discover all\nPremium features"
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "SFProDisplay-Bold", size: 34) ?? UIFont.boldSystemFont(ofSize: 34)
        titleLabel.textAlignment = .left
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Try 7 days for free"
        subtitleLabel.font = UIFont(name: "SFProDisplay-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20)
        subtitleLabel.textAlignment = .left
        subtitleLabel.textColor = .darkGray
        
        let pricingLabel = UILabel()
        let pricingText = NSMutableAttributedString(string: "then ")
        let priceAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "SFProDisplay-Bold", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)
        ]
        pricingText.append(NSAttributedString(string: "$6.99", attributes: priceAttributes))
        pricingText.append(NSAttributedString(string: " per week, auto-renewable"))
        pricingLabel.attributedText = pricingText
        pricingLabel.textAlignment = .left
        pricingLabel.textColor = .darkGray
        
        let startButton = UIButton(type: .system)
        startButton.setTitle("Start Now", for: .normal)
        startButton.backgroundColor = .black
        startButton.setTitleColor(.white, for: .normal)
        startButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .medium)
        startButton.layer.cornerRadius = 24
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        let termsTextLabel = UILabel()
        termsTextLabel.text = "By continuing you accept our:"
        termsTextLabel.font = UIFont(name: "SFProDisplay-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
        termsTextLabel.textAlignment = .center
        termsTextLabel.textColor = .gray
        
        let termsLinksLabel = UILabel()
        let termsLinkText = NSMutableAttributedString()
        
        let linkAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemBlue,
            .font: UIFont(name: "SFProDisplay-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
        ]
        
        let termsOfUseLink = NSAttributedString(string: "Terms of Use", attributes: linkAttributes)
        termsLinkText.append(termsOfUseLink)
        termsLinkText.append(NSAttributedString(string: ", "))
        
        let privacyPolicyLink = NSAttributedString(string: "Privacy Policy", attributes: linkAttributes)
        termsLinkText.append(privacyPolicyLink)
        termsLinkText.append(NSAttributedString(string: ", "))
        
        let subscriptionTermsLink = NSAttributedString(string: "Subscription Terms", attributes: linkAttributes)
        termsLinkText.append(subscriptionTermsLink)
        
        termsLinksLabel.attributedText = termsLinkText
        termsLinksLabel.textAlignment = .center
        termsLinksLabel.isUserInteractionEnabled = true
        
        vc.view.addSubview(imageView)
        vc.view.addSubview(closeButton)
        vc.view.addSubview(titleLabel)
        vc.view.addSubview(subtitleLabel)
        vc.view.addSubview(pricingLabel)
        vc.view.addSubview(startButton)
        vc.view.addSubview(termsTextLabel)
        vc.view.addSubview(termsLinksLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(vc.view.snp.height).multipliedBy(0.45)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(vc.view.safeAreaLayoutGuide).offset(16)
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-50)
        }
        
        pricingLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-50)
        }
        
        startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-85)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(56)
        }
        
        termsTextLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(startButton.snp.bottom).offset(12)
        }
        
        termsLinksLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(termsTextLabel.snp.bottom).offset(2)
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(termsLinksTapped))
        termsLinksLabel.addGestureRecognizer(tapGesture)
        
        return vc
    }
}

// MARK: - Add Actions
extension MainPageViewController {
    @objc func showOnboardingCompletedScreen() {
        let welcomeVC = UIViewController()
        welcomeVC.view.backgroundColor = .white
        
        let welcomeLabel = UILabel()
        welcomeLabel.text = "🎉 Onboarding is complete!"
        welcomeLabel.font = UIFont(name: "SFProDisplay-Bold", size: 24) ?? UIFont.boldSystemFont(ofSize: 24)
        welcomeLabel.textAlignment = .center
        
        welcomeVC.view.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        if let nc = self.parent as? UINavigationController {
            nc.pushViewController(welcomeVC, animated: true)
        } else if let nc = self.navigationController {
            nc.pushViewController(welcomeVC, animated: true)
        } else {
            self.present(welcomeVC, animated: true)
        }
    }
    
    @objc func termsLinksTapped(gesture: UITapGestureRecognizer) {
        if let url = URL(string: "https://uni.tech") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func startButtonTapped() {
        print("🎉 Let's start the process of registering a premium subscription (Mock)")
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
