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
        if let url = URL(string: Environment.privacyURL) {
            UIApplication.shared.open(url)
        }
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
    private func getSubscriptionService() -> SubscriptionServiceProtocol {
        return MockSubscriptionService()
    }
    
    @objc func startButtonTapped() {
        print("🎉 Let's start the process of registering a premium subscription (Mock)")
        
        let loadingIndicator = createLoadingIndicator()
        self.view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        loadingIndicator.startAnimating()
        
        Task {
            do {
                let subscriptionService = getSubscriptionService()
                
                let products = try await subscriptionService.fetchProducts()
                
                guard let weeklySubscription = products.first(where: { $0.id == "com.yourapp.premium.weekly" }) else {
                    throw SubscriptionError.productNotFound
                }
                
                let result = try await subscriptionService.purchase(product: weeklySubscription)
                
                DispatchQueue.main.async {
                    loadingIndicator.removeFromSuperview()
                    
                    switch result {
                    case .success:
                        self.showSubscriptionSuccessView()
                        
                    case .userCancelled:
                        self.showSubscriptionCancelledMessage()
                        
                    case .pending:
                        self.showSubscriptionPendingMessage()
                        
                    case .error(let message):
                        self.showSubscriptionErrorMessage(message)
                    }
                }
                
            } catch SubscriptionError.purchaseCancelled {
                DispatchQueue.main.async {
                    loadingIndicator.removeFromSuperview()
                    self.showSubscriptionCancelledMessage()
                }
            } catch SubscriptionError.productNotFound {
                DispatchQueue.main.async {
                    loadingIndicator.removeFromSuperview()
                    self.showSubscriptionErrorMessage("Product not found in the App Store.")
                }
            } catch {
                DispatchQueue.main.async {
                    loadingIndicator.removeFromSuperview()
                    self.showSubscriptionErrorMessage("Error while subscribing: \(error.localizedDescription)")
                    print("Error when purchasing: \(error)")
                }
            }
        }
    }
    
    private func showSubscriptionPendingMessage() {
        let alert = UIAlertController(
            title: "Confirmation required",
            message: "Additional confirmation is required to complete the purchase. Please check your notifications or settings.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    private func createLoadingIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        return indicator
    }
    
    private func showSubscriptionSuccessView() {
        let successVC = UIViewController()
        successVC.view.backgroundColor = .white
        
        let emojiLabel = UILabel()
        emojiLabel.text = "🎉"
        emojiLabel.font = UIFont.systemFont(ofSize: 80)
        emojiLabel.textAlignment = .center
        
        let titleLabel = UILabel()
        titleLabel.text = "Premium activated!"
        titleLabel.font = UIFont(name: "SFProDisplay-Bold", size: 24) ?? UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "You have successfully activated your 7-day trial period. Enjoy all the premium features!"
        descriptionLabel.font = UIFont(name: "SFProDisplay-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        
        let continueButton = UIButton(type: .system)
        continueButton.setTitle("Start using", for: .normal)
        continueButton.backgroundColor = .black
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .medium)
        continueButton.layer.cornerRadius = 24
        continueButton.addTarget(self, action: #selector(showOnboardingCompletedScreen), for: .touchUpInside)
        
        successVC.view.addSubview(emojiLabel)
        successVC.view.addSubview(titleLabel)
        successVC.view.addSubview(descriptionLabel)
        successVC.view.addSubview(continueButton)
        
        emojiLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emojiLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
        }
        
        continueButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-85)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(56)
        }
        
        self.present(successVC, animated: true)
    }
    
    private func showSubscriptionCancelledMessage() {
        let alert = UIAlertController(title: "Purchase canceled",
                                     message: "You have cancelled the subscription process. You can activate premium at any time later.",
                                     preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    private func showSubscriptionErrorMessage(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    // MARK: - Additional functions for working with subscriptions
    func checkSubscriptionStatus() {
        Task {
            let subscriptionService = getSubscriptionService()
            let isActive = await subscriptionService.checkSubscriptionStatus()
            
            DispatchQueue.main.async {
                print("Premium subscription status: \(isActive ? "active" : "inactive")")
                
                NotificationCenter.default.post(name: NSNotification.Name("PremiumStatusChanged"),
                                               object: nil,
                                               userInfo: ["isActive": isActive])
            }
        }
    }
    
    func restorePurchases() {
        let loadingIndicator = createLoadingIndicator()
        self.view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        loadingIndicator.startAnimating()
        
        Task {
            do {
                let subscriptionService = getSubscriptionService()
                let restored = try await subscriptionService.restorePurchases()
                
                DispatchQueue.main.async {
                    loadingIndicator.removeFromSuperview()
                    
                    if restored {
                        self.showAlert(title: "Successfully", message: "Your subscription has been successfully restored!")
                        
                        NotificationCenter.default.post(name: NSNotification.Name("PremiumStatusChanged"),
                                                       object: nil,
                                                       userInfo: ["isActive": true])
                    } else {
                        self.showAlert(title: "Attention", message: "No active subscriptions found.")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    loadingIndicator.removeFromSuperview()
                    self.showAlert(title: "Error", message: "Unable to restore purchases: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
