import Foundation
import AVFoundation

class WhisperService: NSObject {
    private let apiKey: String
    private let baseURL: String
    private var audioEngine: AVAudioEngine?
    private var audioFile: AVAudioFile?
    private var currentAudioPath: URL?
    private var audioSession: AVAudioSession
    private var isRecording = false
    private var recordingDelegate: ((Result<String, Error>) -> Void)?
    
    override init() throws {
        self.apiKey = try Config.whisperAPIKey
        self.baseURL = Config.whisperBaseURL
        self.audioSession = AVAudioSession.sharedInstance()
        super.init()
    }
    
    private func setupAudioSession() throws {
        do {
            try audioSession.setCategory(.record, mode: .measurement)
            try audioSession.setActive(true)
            
            guard audioSession.isInputAvailable else {
                throw NSError(domain: "WhisperService", code: -10,
                            userInfo: [NSLocalizedDescriptionKey: "No audio input device available"])
            }
            
            print("Audio session setup complete:")
            print("Sample rate: \(audioSession.sampleRate)")
            print("Input channels: \(audioSession.inputNumberOfChannels)")
        } catch {
            print("Failed to setup audio session: \(error.localizedDescription)")
            throw error
        }
    }
    
    func startRecording(completion: @escaping (Result<String, Error>) -> Void) throws {
        guard !isRecording else {
            throw NSError(domain: "WhisperService", code: -15,
                         userInfo: [NSLocalizedDescriptionKey: "Recording is already in progress"])
        }
        
        self.recordingDelegate = completion
        
        // Setup audio session
        try setupAudioSession()
        
        // Create audio engine and input node
        audioEngine = AVAudioEngine()
        guard let engine = audioEngine else {
            throw NSError(domain: "WhisperService", code: -16,
                         userInfo: [NSLocalizedDescriptionKey: "Failed to create audio engine"])
        }
        
        let input = engine.inputNode
        
        // Create output file
        let audioFilename = getDocumentsDirectory().appendingPathComponent("\(Date().timeIntervalSince1970).wav")
        currentAudioPath = audioFilename
        
        // Setup audio format
        let recordingFormat = input.outputFormat(forBus: 0)
        print("Recording format: \(recordingFormat)")
        
        // Create audio file
        do {
            audioFile = try AVAudioFile(forWriting: audioFilename,
                                      settings: recordingFormat.settings,
                                      commonFormat: .pcmFormatFloat32,
                                      interleaved: false)
        } catch {
            throw NSError(domain: "WhisperService", code: -17,
                         userInfo: [NSLocalizedDescriptionKey: "Failed to create audio file: \(error.localizedDescription)"])
        }
        
        // Install tap on input node
        input.installTap(onBus: 0, bufferSize: 4096, format: recordingFormat) { [weak self] (buffer, time) in
            guard let self = self, let file = self.audioFile else { return }
            do {
                try file.write(from: buffer)
            } catch {
                print("Error writing buffer: \(error.localizedDescription)")
            }
        }
        
        // Start engine
        do {
            engine.prepare()
            try engine.start()
            isRecording = true
            print("Started recording to: \(audioFilename)")
        } catch {
            throw NSError(domain: "WhisperService", code: -18,
                         userInfo: [NSLocalizedDescriptionKey: "Failed to start audio engine: \(error.localizedDescription)"])
        }
    }
    
    func stopRecording() throws {
        guard isRecording else {
            throw NSError(domain: "WhisperService", code: -5,
                         userInfo: [NSLocalizedDescriptionKey: "No active recording found"])
        }
        
        guard let engine = audioEngine else {
            throw NSError(domain: "WhisperService", code: -19,
                         userInfo: [NSLocalizedDescriptionKey: "Audio engine not found"])
        }
        
        // Stop recording
        engine.inputNode.removeTap(onBus: 0)
        engine.stop()
        isRecording = false
        
        // Clean up audio session
        do {
            try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Warning: Failed to deactivate audio session: \(error.localizedDescription)")
        }
        
        // Start transcription
        transcribeRecording { [weak self] result in
            self?.recordingDelegate?(result)
            self?.audioEngine = nil
            self?.audioFile = nil
        }
    }
    
    private func transcribeRecording(completion: @escaping (Result<String, Error>) -> Void) {
        guard let audioPath = currentAudioPath else {
            completion(.failure(NSError(domain: "WhisperService", code: -1,
                                     userInfo: [NSLocalizedDescriptionKey: "No audio file found"])))
            return
        }
        
        // Verify the audio file exists and has content
        guard FileManager.default.fileExists(atPath: audioPath.path),
              let attributes = try? FileManager.default.attributesOfItem(atPath: audioPath.path),
              let fileSize = attributes[.size] as? UInt64,
              fileSize > 0 else {
            completion(.failure(NSError(domain: "WhisperService", code: -7,
                                     userInfo: [NSLocalizedDescriptionKey: "Invalid or empty audio file"])))
            return
        }
        
        // Create multipart form data
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        // Add model parameter
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n".data(using: .utf8)!)
        data.append("whisper-1\r\n".data(using: .utf8)!)
        
        // Add audio file
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"audio.wav\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: audio/wav\r\n\r\n".data(using: .utf8)!)
        
        do {
            let audioData = try Data(contentsOf: audioPath)
            data.append(audioData)
            data.append("\r\n".data(using: .utf8)!)
        } catch {
            completion(.failure(error))
            return
        }
        
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = data
        
        print("Making API request...")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Network Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Response Status Code: \(httpResponse.statusCode)")
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    let errorMessage = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                    completion(.failure(NSError(domain: "WhisperService",
                                             code: httpResponse.statusCode,
                                             userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                    return
                }
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "WhisperService",
                                         code: -2,
                                         userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let json = try JSONDecoder().decode(WhisperResponse.self, from: data)
                completion(.success(json.text))
            } catch {
                print("Decoding Error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

struct WhisperResponse: Codable {
    let text: String
}
