import UIKit
import StoreKit

class StoreViewController: UIViewController {
    private let storeManager = StoreManager.shared
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Upgrade to Pro"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var featuresLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = """
        ✓ Unlimited Recording Time
        ✓ High-Quality Transcription
        ✓ Export to Multiple Formats
        ✓ Priority Support
        ✓ No Ads
        """
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$15.00/month"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var subscribeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Subscribe Now", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(subscribeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var trialLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Includes 3-day free trial"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadProducts()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        [titleLabel, featuresLabel, priceLabel, subscribeButton, trialLabel, activityIndicator].forEach {
            containerView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            featuresLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            featuresLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            featuresLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            priceLabel.topAnchor.constraint(equalTo: featuresLabel.bottomAnchor, constant: 30),
            priceLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            subscribeButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 30),
            subscribeButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            subscribeButton.widthAnchor.constraint(equalToConstant: 200),
            subscribeButton.heightAnchor.constraint(equalToConstant: 50),
            
            trialLabel.topAnchor.constraint(equalTo: subscribeButton.bottomAnchor, constant: 10),
            trialLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            trialLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func loadProducts() {
        activityIndicator.startAnimating()
        Task {
            await storeManager.loadProducts()
            activityIndicator.stopAnimating()
            updateUI()
        }
    }
    
    private func updateUI() {
        guard let product = storeManager.products.first else { return }
        priceLabel.text = product.displayPrice + "/month"
    }
    
    @objc private func subscribeTapped() {
        guard let product = storeManager.products.first else { return }
        
        activityIndicator.startAnimating()
        subscribeButton.isEnabled = false
        
        Task {
            do {
                if let transaction = try await storeManager.purchase(product) {
                    showPurchaseSuccess()
                }
            } catch {
                showError(error)
            }
            activityIndicator.stopAnimating()
            subscribeButton.isEnabled = true
        }
    }
    
    private func showPurchaseSuccess() {
        let alert = UIAlertController(
            title: "Welcome to Pro!",
            message: "Thank you for subscribing. Enjoy unlimited recording and all pro features!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Start Using Pro", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Subscription Failed",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
