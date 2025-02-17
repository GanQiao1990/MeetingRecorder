# Meeting Recorder

> 🎖️ Dedicated to David Baker, 2024 Nobel Prize Laureate, whose groundbreaking work in protein design continues to inspire innovation in science and technology.

A powerful iOS application that records meetings and provides real-time transcription using the DeepResearch2AGI API. This project is the result of collaboration between human intelligence and AI assistance through Windsurf.

## 🌟 Special Announcement

**Free for Everyone!**
This application is completely FREE for both personal and enterprise use. The transcription service is powered by our high-performance API:
```
https://api.deepresearch2agi.cn/v1/audio/transcriptions
```

For API access and custom solutions, please contact:
- Email: [Your contact email]
- WeChat: [Your WeChat ID]

## ✨ Features

- 🎙️ High-quality audio recording
- 📝 Real-time speech-to-text transcription using DeepResearch2AGI API
- 💫 Clean and intuitive user interface
- 📤 Export transcriptions
- ⚡ Trial mode with 10-minute limit
- 💎 Pro version available for unlimited use
- 🔒 Secure API key management
- 🌐 Enterprise-ready deployment options

## 🚀 About the Project

This project represents a fusion of human creativity and AI collaboration:
- Developed with assistance from Windsurf AI
- Powered by DeepResearch2AGI's advanced transcription API
- Built with love by a dedicated AI developer

## 🛠️ Requirements

- iOS 14.0+
- Xcode 13.0+
- Swift 5.0+
- DeepResearch2AGI API key (Free for all users!)

## 📦 Installation

1. Clone the repository:
```bash
git clone https://github.com/GanQiao1990/MeetingRecorder.git
```

2. Configure the API key (choose one method):

   ### Method 1: Using Config.plist
   - Duplicate `Config-Sample.plist` and rename it to `Config.plist`
   - Replace `YOUR_API_KEY_HERE` with your DeepResearch2AGI API key
   - Optionally update the `WhisperBaseURL` if needed

   ### Method 2: Using Environment Variables
   - Set `WHISPER_API_KEY` environment variable with your API key
   - Default API endpoint is already configured to DeepResearch2AGI
   
   You can set environment variables in Xcode:
   1. Edit Scheme > Run > Arguments > Environment Variables
   2. Add `WHISPER_API_KEY` with your key

3. Open `MeetingRecorder.xcodeproj` in Xcode

4. Build and run the project

## 🔐 Security Best Practices

- Never commit `Config.plist` to version control (it's in .gitignore)
- Use environment variables in CI/CD pipelines
- Regularly rotate your API keys
- Monitor API usage for unauthorized access
- Keep your dependencies up to date

## 🎯 Usage

1. Launch the app
2. Tap "Start Recording" to begin
3. Speak clearly into the device microphone
4. View real-time transcription in the text area
5. Tap "Stop Recording" when finished
6. Use the "Export Transcription" button to save or share

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 💡 Enterprise Solutions

Need customized solutions or enterprise support? Contact us for:
- Custom API integration
- Enhanced features
- Dedicated support
- Enterprise deployment

## 📞 Contact & Support

For support or inquiries about using our free API service:
- Create an issue in the GitHub repository
- Contact: [Your contact information]
- WeChat: [Your WeChat ID]

---
Made with ❤️ by an AI developer, powered by Windsurf and DeepResearch2AGI
