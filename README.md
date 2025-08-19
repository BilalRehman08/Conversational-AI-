# Conversational AI Flutter App

A conversational AI Flutter application with voice input, mock AI responses, and conversation logging.

## Features

- **Chat Interface**: Type or speak questions
- **Mock AI Responses**: Simulated responses with streaming effect
- **Voice Input**: Tap to speak (mock implementation)
- **Conversation History**: Last 5 turns maintained

- **Recent Conversations**: Bottom sheet for history
- **WhatsApp-style Input**: Dynamic voice/send button
- **Thinking Indicators**: Animated "thinking..." during generation

## Architecture

**Stacked Architecture** (MVVM):
- **Views**: UI components (`ChatView`)
- **ViewModels**: Business logic (`ChatViewModel`)
- **Services**: Data and APIs (`LlmService`, `SpeechService`, `LoggingService`)
- **Models**: Data structures (`ChatMessage`, `ConversationLog`)

## Codebase Structure

```
lib/
├── app/                    # App configuration
├── models/                 # Data models
├── services/               # Business logic services
│   ├── llm_service.dart    # AI service interface
│   ├── mock_llm_service.dart # Mock AI responses
│   ├── openai_service.dart # OpenAI API integration
│   ├── speech_service.dart # Voice input (mock)
│   └── logging_service.dart # Conversation logging
└── ui/                     # User interface
    ├── views/chat/         # Chat screen
    └── widgets/            # Reusable components
```

## Environment Variables

### Setup
```bash
cp env.example .env
```

### Configuration
```env
# API Keys
OPENAI_API_KEY=your_openai_api_key_here
OPENAI_BASE_URL=https://api.openai.com/v1

# App Configuration
APP_ENVIRONMENT=development
```

## Mock Responses

- **MockLlmService**: Simulated AI responses with delays
- **SpeechService**: Mock voice input with random responses
- **No API Keys Required**: Works out of the box for testing

## Real API Integration

### OpenAI API
1. Get API key from [OpenAI Platform](https://platform.openai.com/api-keys)
2. Update `.env` file with your key
3. Switch service in `lib/app/app.dart`:
   ```dart
   LazySingleton<LlmService>(classType: OpenAiService),
   ```

### Speech Recognition
1. Uncomment packages in `pubspec.yaml`
2. Add platform permissions
3. Replace mock implementation in `speech_service.dart`

## Dependencies

- **stacked**: State management
- **stacked_services**: Service locator
- **flutter_dotenv**: Environment variables
- **intl**: Date formatting

## Build

```bash
flutter pub get
flutter build apk --debug
```
