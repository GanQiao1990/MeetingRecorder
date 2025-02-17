import Foundation

struct Config {
    static var whisperAPIKey: String {
        // First try to get from environment variable
        if let envKey = ProcessInfo.processInfo.environment["WHISPER_API_KEY"] {
            return envKey
        }
        
        // Then try to get from configuration file
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
           let apiKey = dict["WhisperAPIKey"] as? String {
            return apiKey
        }
        
        // Return a placeholder for development
        return "YOUR_API_KEY_HERE"
    }
}
