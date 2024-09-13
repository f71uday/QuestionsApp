import 'package:firebase_analytics/firebase_analytics.dart';


class EventLogger {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // Log when the user signs up
  static Future<void> logSignUpEvent() async {
    await analytics.logSignUp(signUpMethod: 'password');
  }

  // Log when the user signs in
  static Future<void> logSignInEvent() async {
    await analytics.logLogin(loginMethod: 'password');
  }

  // Log when the user logs out
  static Future<void> logSignOutEvent() async {
    await analytics.logEvent(
      name: 'sign_out',
      parameters: {
        'method': 'password',
      },
    );
  }

  // Log when the user views a specific screen
  static Future<void> logScreenView({required String screenName, String? screenClassOverride}) async {
    await analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClassOverride ?? 'App',
    );
  }

  // Log a custom event with parameters
  static Future<void> logCustomEvent({required String eventName, Map<String, Object>? parameters}) async {
    await analytics.logEvent(
      name: eventName,
      parameters: parameters,
    );
  }

  // Log when the user makes an in-app purchase
  // Log a purchase event
  static Future<void> logPurchaseEvent({
    required String itemId,
    required String itemName,
    required double value,
    String currency = 'USD',
  }) async {
    await analytics.logPurchase(
      transactionId: itemId,
      value: value,
      currency: currency,
      items: [
        AnalyticsEventItem(
          itemId: itemId,
          itemName: itemName,
        ),
      ],
    );
  }

  // Log when the user completes a level in a game/app
  static Future<void> logLevelComplete({required int levelNumber}) async {
    await analytics.logEvent(
      name: 'level_complete',
      parameters: {
        'level_number': levelNumber,
      },
    );
  }

  // Log when the user interacts with a specific feature
  static Future<void> logFeatureUse({required String featureName}) async {
    await analytics.logEvent(
      name: 'feature_use',
      parameters: {
        'feature_name': featureName,
      },
    );
  }

  // Log an error or exception
  static Future<void> logErrorEvent({required String errorMessage}) async {
    await analytics.logEvent(
      name: 'error',
      parameters: {
        'error_message': errorMessage,
      },
    );
  }

  // Log app open event
  static Future<void> logAppOpen() async {
    await analytics.logAppOpen();
  }

  // Log when a tutorial is completed
  static Future<void> logTutorialComplete() async {
    await analytics.logTutorialComplete();
  }

  // Log when a share action is performed
  static Future<void> logShareEvent({required String contentType, required String itemId, required String method}) async {
    await analytics.logShare(
      contentType: contentType,
      itemId: itemId,
      method: method,
    );
  }

  // Log when the user completes a quiz or task
  static Future<void> logTaskCompletion({required String taskName, required int score}) async {
    await analytics.logEvent(
      name: 'task_complete',
      parameters: {
        'task_name': taskName,
        'score': score,
      },
    );
  }
}
