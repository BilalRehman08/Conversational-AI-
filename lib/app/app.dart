import 'package:conversational_ai/services/llm_service.dart';
import 'package:conversational_ai/services/logging_service.dart';
import 'package:conversational_ai/services/mock_llm_service.dart';
import 'package:conversational_ai/ui/views/chat/chat_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [MaterialRoute(page: ChatView, initial: true)],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: LoggingService),
    LazySingleton<LlmService>(classType: MockLlmService),
    // LazySingleton<LlmService>(classType: OpenAiService),
  ],
  locatorName: 'locator',
  locatorSetupName: 'setupLocator',
)
class App {}
