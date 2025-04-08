import UIKit
import SnapKit

class PremiumViewController: UIViewController {
    
    // MARK: - UI Components
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("×", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 28) ?? UIFont.systemFont(ofSize: 28, weight: .regular)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "OnboardingImage")
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Discover all\nPremium features"
        label.numberOfLines = 0
        label.font = UIFont(name: "SFProDisplay-Bold", size: 34) ?? UIFont.boldSystemFont(ofSize: 34)
        label.textAlignment = .left
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Try 7 days for free"
        label.font = UIFont(name: "SFProDisplay-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    lazy var pricingLabel: UILabel = {
        let label = UILabel()
        let pricingText = NSMutableAttributedString(string: "then ")
        let priceAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "SFProDisplay-Bold", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
        ]
        pricingText.append(NSAttributedString(string: "$6.99", attributes: priceAttributes))
        pricingText.append(NSAttributedString(string: " per week, auto-renewable"))
        label.attributedText = pricingText
        label.textAlignment = .left
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Now", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .medium)
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var termsTextLabel: UILabel = {
        let label = UILabel()
        label.text = "By continuing you accept our:"
        label.font = UIFont(name: "SFProDisplay-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    lazy var termsLinksLabel: UILabel = {
        let label = UILabel()
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
        
        label.attributedText = termsLinkText
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(termsLinksTapped))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    let store = Store()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        view.addSubview(closeButton)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(pricingLabel)
        view.addSubview(startButton)
        view.addSubview(termsTextLabel)
        view.addSubview(termsLinksLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
        }
        
        pricingLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
        }
        
        startButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(pricingLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(56)
        }
        
        termsTextLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
            make.top.equalTo(startButton.snp.bottom).offset(12)
        }
        
        termsLinksLabel.snp.makeConstraints { make in
            make.top.equalTo(termsTextLabel.snp.bottom).offset(2)
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
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
    
    @objc private func startButtonTapped() {
        print("🎉 Let's start the process of registering a premium subscription (Mock)")
        
        Task {
            do {
                if try await store.purchase(store.subscriptions.first!) != nil {
                    showSubscriptionSuccessView()
                }
            } catch StoreError.failedVerification {
                showSubscriptionErrorMessage("Your purchase could not be verified by the App Store.")
            } catch {
                print("Failed purchase  \(error)")
                showSubscriptionErrorMessage(error.localizedDescription)
            }
        }
    }
    
    @objc private func termsLinksTapped() {
        if let url = URL(string: Environment.privacyURL) {
            UIApplication.shared.open(url)
        }
    }
    
    private func showSubscriptionSuccessView() {
        let successVC = SuccessViewController()
        successVC.modalPresentationStyle = .fullScreen
        self.present(successVC, animated: true)
    }
    
    private func showSubscriptionErrorMessage(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
}
