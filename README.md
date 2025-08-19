# Conversational AI Flutter App

A Flutter application built with Stacked architecture that provides a conversational AI interface with mock responses and conversation logging.

## Features

- **Single Screen Chat Interface**: Clean, modern chat UI with text input and send button
- **Mock AI Responses**: Simulated AI responses with streaming text effect and 1-2 second thinking delay
- **Conversation History**: Maintains the last 5 conversation turns (10 messages) on screen
- **Local Logging**: Logs all conversations with timestamps and stores them locally
- **Logs Viewer**: Access conversation history through a drawer interface
- **Stacked Architecture**: Clean, maintainable code structure using Stacked state management

## Architecture

The app follows the Stacked architecture pattern with the following structure:

```
lib/
├── app/
│   ├── app.dart              # Stacked app configuration
│   ├── app.locator.dart      # Generated dependency injection setup
│   └── app.router.dart       # Generated route configuration
├── models/
│   ├── chat_message.dart     # Chat message data model
│   └── conversation_log.dart # Conversation log data model
├── services/
│   ├── llm_service.dart      # Abstract LLM service interface
│   ├── mock_llm_service.dart # Mock implementation for testing
│   ├── openai_service.dart   # OpenAI service stub (for future use)
│   └── logging_service.dart  # Conversation logging service
├── ui/
│   ├── common/
│   │   └── app_colors.dart   # App color scheme
│   ├── views/
│   │   └── chat/
│   │       ├── chat_view.dart      # StackedView for chat screen
│   │       └── chat_viewmodel.dart # BaseViewModel with chat logic
│   └── widgets/
│       ├── chat_bubble.dart  # Individual message bubble
│       ├── chat_input.dart   # Message input widget
│       └── logs_drawer.dart  # Conversation logs drawer
└── main.dart                 # App entry point with locator setup
```

## Getting Started

### Prerequisites

- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / VS Code
- Android device or emulator

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd conversational_ai
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Building APK

To build a debug APK:
```bash
flutter build apk --debug
```

The APK will be located at: `build/app/outputs/flutter-apk/app-debug.apk`

## Configuration

### Switching to OpenAI Service

To use real OpenAI API instead of mock responses:

1. **Update app.dart**: Uncomment the OpenAiService line and comment out MockLlmService:
```dart
// In lib/app/app.dart
LazySingleton<LlmService>(classType: OpenAiService),
// LazySingleton<LlmService>(classType: MockLlmService),
```

2. **Add API Key**: Set your OpenAI API key as an environment variable:
```bash
export OPENAI_API_KEY="your-api-key-here"
```

3. **Implement OpenAI Service**: Complete the implementation in `lib/services/openai_service.dart`

### Environment Variables

The app is configured to use environment variables for sensitive data like API keys. Never hardcode API keys in the source code.

## Dependencies

### Core Dependencies
- **stacked**: ^3.4.0 - State management and architecture
- **stacked_services**: ^1.6.0 - Service locator and navigation
- **intl**: ^0.19.0 - Internationalization and date formatting

### Development Dependencies
- **build_runner**: ^2.4.7 - Code generation
- **stacked_generator**: ^2.0.0 - Stacked code generation

## Usage

1. **Start a Conversation**: Type your message in the input field and tap the send button
2. **View AI Response**: The AI will respond with a simulated thinking delay and streaming text effect
3. **View Logs**: Tap the history icon in the app bar to view conversation logs
4. **Clear Logs**: Use the clear button in the logs drawer to remove all conversation history

## Mock AI Responses

The MockLlmService provides various types of responses:
- **Short Messages**: Special handling for messages 3 characters or less
- **Greetings**: Responds to hello, hi, hey, etc.
- **Farewells**: Responds to goodbye, bye, see you, etc.
- **Questions**: Provides thoughtful responses to questions
- **General**: Default responses for longer messages

## Future Enhancements

- [ ] Real OpenAI API integration
- [ ] Voice input support
- [ ] Message reactions and editing
- [ ] Export conversation logs
- [ ] Multiple AI models support
- [ ] Conversation themes and customization
- [ ] Offline mode with local AI models

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please open an issue in the repository.
