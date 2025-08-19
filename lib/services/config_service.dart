import 'package:flutter_dotenv/flutter_dotenv.dart';

class ConfigService {
  static const String _openaiApiKeyKey = 'OPENAI_API_KEY';
  static const String _openaiBaseUrlKey = 'OPENAI_BASE_URL';
  static const String _appEnvironmentKey = 'APP_ENVIRONMENT';

  static bool _isInitialized = false;

  /// Initialize environment variables
  static Future<void> initialize() async {
    try {
      await dotenv.load(fileName: '.env');
      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
    }
  }

  /// Get environment variable safely
  static String? _getEnv(String key) {
    if (!_isInitialized) return null;
    try {
      return dotenv.env[key];
    } catch (e) {
      return null;
    }
  }

  /// Get OpenAI API Key
  static String? get openaiApiKey {
    final key = _getEnv(_openaiApiKeyKey);
    // Return null if key is the placeholder value
    if (key == 'your_openai_api_key_here' || key == null || key.isEmpty) {
      return null;
    }
    return key;
  }

  /// Get OpenAI Base URL
  static String get openaiBaseUrl {
    return _getEnv(_openaiBaseUrlKey) ?? 'https://api.openai.com/v1';
  }

  /// Check if speech recognition is enabled
  static bool get isSpeechRecognitionEnabled {
    return true;
  }

  /// Get app environment
  static String get appEnvironment {
    return _getEnv(_appEnvironmentKey) ?? 'development';
  }

  /// Check if running in production
  static bool get isProduction {
    return appEnvironment.toLowerCase() == 'production';
  }

  /// Check if running in development
  static bool get isDevelopment {
    return appEnvironment.toLowerCase() == 'development';
  }
}
