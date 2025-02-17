# Meeting Recorder

A powerful iOS application that records meetings and provides real-time transcription using the Whisper API.

## Features

- 🎙️ High-quality audio recording
- 📝 Real-time speech-to-text transcription
- 💫 Clean and intuitive user interface
- 📤 Export transcriptions
- ⚡ Trial mode with 10-minute limit
- 💎 Pro version available for unlimited use
- 🔒 Secure API key management

## Requirements

- iOS 14.0+
- Xcode 13.0+
- Swift 5.0+
- Active Whisper API key

## Installation

1. Clone the repository:
```bash
git clone https://github.com/GanQiao1990/MeetingRecorder.git
```

2. Configure the API key (choose one method):

   ### Method 1: Using Config.plist
   - Duplicate `Config-Sample.plist` and rename it to `Config.plist`
   - Replace `YOUR_API_KEY_HERE` with your actual Whisper API key
   - Optionally update the `WhisperBaseURL` if you're using a different endpoint

   ### Method 2: Using Environment Variables
   - Set `WHISPER_API_KEY` environment variable with your API key
   - Optionally set `WHISPER_BASE_URL` for a custom endpoint
   
   You can set environment variables in Xcode:
   1. Edit Scheme > Run > Arguments > Environment Variables
   2. Add `WHISPER_API_KEY` with your key
   3. Optionally add `WHISPER_BASE_URL` with your custom endpoint

3. Open `MeetingRecorder.xcodeproj` in Xcode

4. Build and run the project

## Security Best Practices

- Never commit `Config.plist` to version control (it's in .gitignore)
- Use environment variables in CI/CD pipelines
- Regularly rotate your API keys
- Monitor API usage for unauthorized access
- Keep your dependencies up to date

## Configuration

The app supports two configuration methods for API credentials:

1. Environment Variables:
   - `WHISPER_API_KEY`: Your Whisper API key
   - `WHISPER_BASE_URL`: Custom API endpoint (optional)

2. Config.plist:
   - `WhisperAPIKey`: Your Whisper API key
   - `WhisperBaseURL`: Custom API endpoint (optional)

## Usage

1. Launch the app
2. Tap "Start Recording" to begin
3. Speak clearly into the device microphone
4. View real-time transcription in the text area
5. Tap "Stop Recording" when finished
6. Use the "Export Transcription" button to save or share

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Support

For support, please open an issue in the GitHub repository or contact the maintainers.
