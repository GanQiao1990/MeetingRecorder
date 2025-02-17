import Foundation
import Speech
import AVFoundation

class SpeechRecognitionService {
    // Speech recognizer instances for different languages
    private var englishRecognizer: SFSpeechRecognizer?
    private var chineseRecognizer: SFSpeechRecognizer?
    private var audioEngine: AVAudioEngine
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var currentLanguage: String = "en-US"  // Default to English
    
    // Callback for transcribed text
    var onTranscriptionUpdate: ((String) -> Void)?
    var onError: ((Error) -> Void)?
    
    init() {
        audioEngine = AVAudioEngine()
        setupRecognizers()
    }
    
    private func setupRecognizers() {
        // Initialize recognizers for both languages
        englishRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        chineseRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-CN"))
        
        // Set delegates if needed
        englishRecognizer?.delegate = self
        chineseRecognizer?.delegate = self
    }
    
    func requestPermissions(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    completion(true)
                default:
                    completion(false)
                }
            }
        }
    }
    
    func startRecording() throws {
        // Cancel any ongoing tasks
        recognitionTask?.cancel()
        recognitionTask = nil
        
        // Configure audio session
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = recognitionRequest else {
            throw NSError(domain: "SpeechRecognitionService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to create recognition request"])
        }
        
        // Configure request properties
        recognitionRequest.shouldReportPartialResults = true
        recognitionRequest.taskHint = .dictation
        
        // Get appropriate recognizer based on current language
        let currentRecognizer = currentLanguage == "en-US" ? englishRecognizer : chineseRecognizer
        
        guard let recognizer = currentRecognizer, recognizer.isAvailable else {
            throw NSError(domain: "SpeechRecognitionService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Speech recognizer is not available"])
        }
        
        // Setup audio input
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        // Start recognition task
        recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            if let error = error {
                self?.onError?(error)
                return
            }
            
            if let result = result {
                let transcribedText = result.bestTranscription.formattedString
                self?.onTranscriptionUpdate?(transcribedText)
            }
        }
    }
    
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask?.cancel()
        recognitionTask = nil
    }
    
    func switchLanguage() {
        // Toggle between English and Chinese
        currentLanguage = (currentLanguage == "en-US") ? "zh-CN" : "en-US"
        
        // Restart recording with new language if currently recording
        if audioEngine.isRunning {
            stopRecording()
            try? startRecording()
        }
    }
    
    func getCurrentLanguage() -> String {
        return currentLanguage
    }
}

// MARK: - SFSpeechRecognizerDelegate
extension SpeechRecognitionService: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if !available {
            let error = NSError(domain: "SpeechRecognitionService", 
                              code: -3, 
                              userInfo: [NSLocalizedDescriptionKey: "Speech recognition became unavailable"])
            onError?(error)
        }
    }
}
