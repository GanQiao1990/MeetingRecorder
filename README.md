# Meeting Recorder | 会议录音机

[English](#english) | [中文](#chinese)

---

<a name="english"></a>
# English Version

> 🎖️ Dedicated to David Baker, 2024 Nobel Prize Laureate, whose groundbreaking work in protein design continues to inspire innovation in science and technology.

A powerful iOS application that records meetings and provides real-time transcription using the DeepResearch2AGI API. This project is the result of collaboration between human intelligence and AI assistance through Windsurf.

## 🌟 Special Announcement

**Free for Everyone!**
This application is completely FREE for both personal and enterprise use. The transcription service is powered by our high-performance API:
```
https://api.deepresearch2agi.cn/v1/audio/transcriptions
```

For API access and custom solutions, please contact:
- Email: m19950870215@163.com
- WeChat: 19950870215

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
- Email: m19950870215@163.com
- WeChat: 19950870215

---

<a name="chinese"></a>
# 中文版本

> 🎖️ 谨以此项目向2024年诺贝尔奖获得者David Baker致敬，他在蛋白质设计领域的开创性工作持续激励着科技创新。

这是一款强大的iOS会议录音应用，使用DeepResearch2AGI API提供实时转录功能。本项目是人类智慧与Windsurf AI助手协作的成果。

## 🌟 特别公告

**对所有用户免费！**
本应用对个人和企业用户完全免费。转录服务由我们的高性能API提供支持：
```
https://api.deepresearch2agi.cn/v1/audio/transcriptions
```

如需API访问权限和定制解决方案，请联系：
- 电子邮件：m19950870215@163.com
- 微信：19950870215

## ✨ 功能特点

- 🎙️ 高质量音频录制
- 📝 使用DeepResearch2AGI API实时语音转文字
- 💫 清晰直观的用户界面
- 📤 转录文本导出功能
- ⚡ 试用版10分钟限制
- 💎 专业版无限制使用
- 🔒 安全的API密钥管理
- 🌐 企业级部署选项

## 🚀 关于项目

本项目代表了人工智能与人类创造力的完美融合：
- 在Windsurf AI的协助下开发
- 由DeepResearch2AGI的先进转录API提供支持
- 由专业AI开发者倾心打造

## 🛠️ 系统要求

- iOS 14.0+
- Xcode 13.0+
- Swift 5.0+
- DeepResearch2AGI API密钥（对所有用户免费！）

## 📦 安装说明

1. 克隆仓库：
```bash
git clone https://github.com/GanQiao1990/MeetingRecorder.git
```

2. 配置API密钥（选择以下方式之一）：

   ### 方式一：使用Config.plist
   - 复制`Config-Sample.plist`并重命名为`Config.plist`
   - 将`YOUR_API_KEY_HERE`替换为您的DeepResearch2AGI API密钥
   - 如需要可更新`WhisperBaseURL`

   ### 方式二：使用环境变量
   - 设置环境变量`WHISPER_API_KEY`为您的API密钥
   - 默认API端点已配置为DeepResearch2AGI
   
   在Xcode中设置环境变量：
   1. 编辑方案 > 运行 > 参数 > 环境变量
   2. 添加`WHISPER_API_KEY`及您的密钥

3. 在Xcode中打开`MeetingRecorder.xcodeproj`

4. 构建并运行项目

## 🔐 安全最佳实践

- 永远不要将`Config.plist`提交到版本控制（已在.gitignore中配置）
- 在CI/CD管道中使用环境变量
- 定期轮换API密钥
- 监控API使用情况防止未授权访问
- 保持依赖项更新

## 🎯 使用方法

1. 启动应用
2. 点击"开始录制"
3. 对着设备麦克风清晰说话
4. 在文本区域查看实时转录
5. 完成时点击"停止录制"
6. 使用"导出转录"按钮保存或分享

## 📄 许可证

本项目采用MIT许可证 - 详见[LICENSE](LICENSE)文件。

## 🤝 贡献指南

1. Fork本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m '添加某个特性'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建Pull Request

## 💡 企业解决方案

需要定制解决方案或企业支持？我们提供：
- 自定义API集成
- 增强功能
- 专属支持
- 企业部署

## 📞 联系与支持

如需支持或咨询免费API服务：
- 在GitHub仓库创建issue
- 电子邮件：m19950870215@163.com
- 微信：19950870215

---
由AI开发者倾情打造，由Windsurf和DeepResearch2AGI提供技术支持 ❤️
