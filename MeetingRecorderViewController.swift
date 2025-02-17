import UIKit
import AVFAudio
import StoreKit

class MeetingRecorderViewController: UIViewController {
    
    private let whisperService = WhisperService()
    private var isRecording = false
    private let storeManager = StoreManager.shared
    
    // Trial functionality
    private var trialStartTime: Date?
    private let trialDuration: TimeInterval = 600 // 10 minutes in seconds
    private var trialTimer: Timer?
    private var remainingTrialTime: TimeInterval = 600 // 10 minutes in seconds
    
    // UI Elements
    private lazy var transcriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 16)
        textView.isEditable = false
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        textView.text = "Transcription will appear here..."
        textView.textColor = .gray
        return textView
    }()
    
    private lazy var recordButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start Recording", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var upgradeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Upgrade to Pro", for: .normal)
        button.addTarget(self, action: #selector(showStore), for: .touchUpInside)
        button.isHidden = true  // Hide the upgrade button
        return button
    }()
    
    private lazy var exportButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Export Transcription", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(exportButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var trialLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkMicrophonePermission()
        updateProStatus()
        setupTrialIfNeeded()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Meeting Recorder"
        
        // Add UI elements to view
        view.addSubview(transcriptionTextView)
        view.addSubview(recordButton)
        view.addSubview(activityIndicator)
        view.addSubview(upgradeButton)
        view.addSubview(exportButton)
        view.addSubview(trialLabel)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            transcriptionTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            transcriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            transcriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            transcriptionTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            recordButton.topAnchor.constraint(equalTo: transcriptionTextView.bottomAnchor, constant: 20),
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordButton.widthAnchor.constraint(equalToConstant: 200),
            recordButton.heightAnchor.constraint(equalToConstant: 44),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: recordButton.bottomAnchor, constant: 20),
            
            upgradeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            upgradeButton.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 20),
            upgradeButton.widthAnchor.constraint(equalToConstant: 200),
            upgradeButton.heightAnchor.constraint(equalToConstant: 44),
            
            exportButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exportButton.topAnchor.constraint(equalTo: upgradeButton.bottomAnchor, constant: 20),
            exportButton.widthAnchor.constraint(equalToConstant: 200),
            exportButton.heightAnchor.constraint(equalToConstant: 44),
            
            trialLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trialLabel.topAnchor.constraint(equalTo: exportButton.bottomAnchor, constant: 8),
            trialLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            trialLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        updateRecordButtonState()
    }
    
    private func setupTrialIfNeeded() {
        if !storeManager.isProUser {
            if let startTime = UserDefaults.standard.object(forKey: "trialStartTime") as? Date {
                trialStartTime = startTime
                let elapsed = Date().timeIntervalSince(startTime)
                if elapsed < trialDuration {
                    remainingTrialTime = trialDuration - elapsed
                    startTrialTimer()
                } else {
                    endTrial()
                }
            } else {
                // Start new trial
                trialStartTime = Date()
                UserDefaults.standard.set(trialStartTime, forKey: "trialStartTime")
                startTrialTimer()
            }
        }
    }
    
    private func startTrialTimer() {
        trialLabel.isHidden = false
        trialTimer?.invalidate()
        trialTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTrialTime()
        }
        updateTrialTime()
    }
    
    private func updateTrialTime() {
        remainingTrialTime -= 1
        if remainingTrialTime <= 0 {
            endTrial()
        } else {
            let minutes = Int(remainingTrialTime) / 60
            let seconds = Int(remainingTrialTime) % 60
            trialLabel.text = String(format: "Trial time remaining: %d:%02d", minutes, seconds)
        }
    }
    
    private func endTrial() {
        trialTimer?.invalidate()
        trialTimer = nil
        trialLabel.text = "Trial period ended"
        showUpgradePrompt()
    }
    
    private func showUpgradePrompt() {
        let alert = UIAlertController(
            title: "Trial Period Ended",
            message: "Your 10-minute trial has ended. Would you like to upgrade to continue using all features?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Upgrade", style: .default) { [weak self] _ in
            self?.showStore()
        })
        alert.addAction(UIAlertAction(title: "Maybe Later", style: .cancel))
        present(alert, animated: true)
    }
    
    private func updateRecordButtonState() {
        let title = isRecording ? "Stop Recording" : "Start Recording"
        let backgroundColor = isRecording ? UIColor.red : UIColor.systemBlue
        
        recordButton.setTitle(title, for: .normal)
        recordButton.backgroundColor = backgroundColor
    }
    
    private func updateProStatus() {
        // Hide upgrade button always
        upgradeButton.isHidden = true
    }
    
    private func checkMicrophonePermission() {
        if #available(iOS 17.0, *) {
            switch AVAudioApplication.shared.recordPermission {
            case .granted:
                print("Microphone access granted")
            case .denied:
                showMicrophoneAccessAlert()
            case .undetermined:
                requestMicrophoneAccess()
            @unknown default:
                print("Unknown microphone permission status")
            }
        } else {
            // Fallback for iOS 16 and earlier
            switch AVAudioSession.sharedInstance().recordPermission {
            case .granted:
                print("Microphone access granted")
            case .denied:
                showMicrophoneAccessAlert()
            case .undetermined:
                requestMicrophoneAccess()
            @unknown default:
                print("Unknown microphone permission status")
            }
        }
    }
    
    private func requestMicrophoneAccess() {
        if #available(iOS 17.0, *) {
            AVAudioApplication.requestRecordPermission { [weak self] granted in
                DispatchQueue.main.async {
                    if !granted {
                        self?.showMicrophoneAccessAlert()
                    }
                }
            }
        } else {
            // Fallback for iOS 16 and earlier
            AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
                DispatchQueue.main.async {
                    if !granted {
                        self?.showMicrophoneAccessAlert()
                    }
                }
            }
        }
    }
    
    private func showMicrophoneAccessAlert() {
        let alert = UIAlertController(
            title: "Microphone Access Required",
            message: "Please enable microphone access in Settings to use the recording feature.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    @objc private func recordButtonTapped() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    private func startRecording() {
        guard checkProStatus() else { return }
        
        do {
            recordButton.isEnabled = false
            activityIndicator.startAnimating()
            
            try whisperService.startRecording { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let transcription):
                        self?.transcriptionTextView.text = transcription
                        self?.transcriptionTextView.textColor = .black
                    case .failure(let error):
                        self?.showError(error)
                    }
                    self?.resetUI()
                }
            }
            
            isRecording = true
            recordButton.isEnabled = true
            updateRecordButtonState()
            transcriptionTextView.text = "Recording in progress..."
            
        } catch {
            showError(error)
            resetUI()
        }
    }
    
    private func stopRecording() {
        do {
            try whisperService.stopRecording()
            transcriptionTextView.text = "Processing transcription..."
            recordButton.isEnabled = false
            activityIndicator.startAnimating()
        } catch {
            showError(error)
            resetUI()
        }
    }
    
    private func resetUI() {
        isRecording = false
        recordButton.isEnabled = true
        updateRecordButtonState()
        activityIndicator.stopAnimating()
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func checkProStatus() -> Bool {
        if storeManager.isProUser {
            return true
        }
        
        guard let startTime = trialStartTime else {
            return false
        }
        
        let elapsed = Date().timeIntervalSince(startTime)
        if elapsed < trialDuration {
            return true
        } else {
            showUpgradePrompt()
            return false
        }
    }
    
    @objc private func showStore() {
        // Temporarily disable store presentation
    }
    
    @objc private func exportButtonTapped() {
        guard checkProStatus() else { return }
        
        let transcriptionText = transcriptionTextView.text ?? ""
        guard !transcriptionText.isEmpty && transcriptionText != "Transcription will appear here..." else {
            showAlert(title: "No Transcription", message: "There is no transcription to export.")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let timestamp = dateFormatter.string(from: Date())
        let fileName = "transcription_\(timestamp).txt"
        
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            showAlert(title: "Error", message: "Could not access documents directory.")
            return
        }
        
        let fileURL = documentsPath.appendingPathComponent(fileName)
        
        do {
            // Format the transcription with timestamp
            let formattedText = """
            Meeting Transcription
            Date: \(timestamp)
            
            \(transcriptionText)
            
            --- End of Transcription ---
            """
            
            try formattedText.write(to: fileURL, atomically: true, encoding: .utf8)
            
            let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
            if let popoverController = activityVC.popoverPresentationController {
                popoverController.sourceView = exportButton
                popoverController.sourceRect = exportButton.bounds
            }
            present(activityVC, animated: true)
            
        } catch {
            showAlert(title: "Export Failed", message: "Failed to save transcription: \(error.localizedDescription)")
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
