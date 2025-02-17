import Foundation

enum ConfigError: Error {
    case missingAPIKey
    case missingConfiguration
}

struct Config {
    static var whisperAPIKey: String {
        get throws {
            // First try to get from environment variable
            if let envKey = ProcessInfo.processInfo.environment["WHISPER_API_KEY"] {
                return envKey
            }
            
            // Then try to get from configuration file
            if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
               let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
               let apiKey = dict["WhisperAPIKey"] as? String,
               !apiKey.isEmpty,
               apiKey != "YOUR_API_KEY_HERE" {
                return apiKey
            }
            
            throw ConfigError.missingAPIKey
        }
    }
    
    static var whisperBaseURL: String {
        get {
            // First try to get from environment variable
            if let envURL = ProcessInfo.processInfo.environment["WHISPER_BASE_URL"] {
                return envURL
            }
            
            // Then try to get from configuration file
            if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
               let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
               let baseURL = dict["WhisperBaseURL"] as? String {
                return baseURL
            }
            
            // Return default URL if none specified
            return "https://api.deepresearch2agi.cn/v1/audio/transcriptions"
        }
    }
}
