# Meeting Recorder

A powerful iOS application that records meetings and provides real-time transcription using the Whisper API.

## Features

- 🎙️ High-quality audio recording
- 📝 Real-time speech-to-text transcription
- 💫 Clean and intuitive user interface
- 📤 Export transcriptions
- ⚡ Trial mode with 10-minute limit
- 💎 Pro version available for unlimited use

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

2. Configure the API key:
   - Duplicate `Config-Sample.plist` and rename it to `Config.plist`
   - Replace `YOUR_API_KEY_HERE` with your actual Whisper API key
   - Alternatively, set the `WHISPER_API_KEY` environment variable

3. Open `MeetingRecorder.xcodeproj` in Xcode

4. Build and run the project

## Configuration

The app requires a Whisper API key to function. You can set it up in two ways:

1. Using Config.plist:
   - Create `Config.plist` based on `Config-Sample.plist`
   - Add your Whisper API key

2. Using environment variable:
   - Set `WHISPER_API_KEY` in your environment
   - The app will automatically use this value if present

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
