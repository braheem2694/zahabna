// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import '../main.dart';
import '../routes/app_routes.dart';
import '../screens/tabs_screen/controller/tabs_controller.dart';
import '../utils/ShColors.dart';

// Top-level callback handlers for awesome_notifications
// These MUST be top-level functions (outside any class) for background isolates to work

@pragma('vm:entry-point')
Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
  // Use WidgetsBinding to ensure navigation happens after app initialization
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (Get.currentRoute != AppRoutes.NotificationsScreen) {
      Get.toNamed(AppRoutes.NotificationsScreen, arguments: {'reload': true});
    }
  });
}

@pragma('vm:entry-point')
Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification) async {
  // Handle notification creation if needed
}

@pragma('vm:entry-point')
Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification) async {
  // Handle notification display if needed
}

@pragma('vm:entry-point')
Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
  // Handle notification dismissal if needed
}

class FirebaseInitialize {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  Future<void> initializeFirebase() async {
    try {
      // Initialize Awesome Notifications
      await AwesomeNotifications().initialize(
        'resource://drawable/ic_launcher.png',
        [
          NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: ColorConstant.logoFirstColor,
            ledColor: Colors.white,
            importance: NotificationImportance.High,
          )
        ],
      );

      // Set up notification action handlers
      AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationCreatedMethod: onNotificationCreatedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: onDismissActionReceivedMethod,
      );

      // Request notification permissions
      await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
        if (!isAllowed) {
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      });

      // Initialize Firebase Messaging
      await FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) {
        if (message != null) {
          // Store the initial message to handle navigation after app initialization
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Get.currentRoute != AppRoutes.NotificationsScreen) {
              Get.toNamed(AppRoutes.NotificationsScreen,
                  arguments: {'reload': true});
            }
          });
        }
      });
      await FirebaseMessaging.instance.subscribeToTopic('global');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null && !kIsWeb) {
          createNotification(message);
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (Get.currentRoute != AppRoutes.NotificationsScreen) {
          Get.toNamed(AppRoutes.NotificationsScreen, arguments: {'reload': true});
        }
      });
    } catch (e) {
      debugPrint('Firebase initialization error: $e');
      // Continue app execution even if Firebase fails
    }
  }

  Future createNotification(RemoteMessage message) async {
    TabsController _controller = Get.find();
    _controller.unreadednotification();
    try {
      if (message.data["isStore"] == true) {
        FetchStores();
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        notificationLayout: NotificationLayout.BigPicture,
        largeIcon: "resource://drawable/ic_launcher",
        color: Colors.blueAccent,
        backgroundColor: Color(0xff281a55),
        displayOnBackground: true,
        displayOnForeground: true,
        progress: 5,
        ticker: "hello brainkets",
        showWhen: true,
        icon: "resource://drawable/ic_stat_logo_in_app",
        title: message.notification?.title,
        body: message.notification?.body,
        payload: {'reload': 'true'}, // Add payload for navigation
      ),
    );
  }

  Future onSelectNotification(String? payload) async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (Get.currentRoute != AppRoutes.NotificationsScreen) {
        Get.toNamed(AppRoutes.NotificationsScreen, arguments: {'reload': true});
      }
    });
  }

  Future<void> onActionSelected(String? value) async {
    switch (value) {
      case 'subscribe':
        {
          await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
        }
        break;
      case 'unsubscribe':
        {
          await FirebaseMessaging.instance.unsubscribeFromTopic('fcm_test');
        }
        break;
      case 'get_apns_token':
        {
          if (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS) {
            String? token = await FirebaseMessaging.instance.getAPNSToken();
          } else {}
        }
        break;
      default:
        break;
    }
  }

  setActionCodeSettings() {
    ActionCodeSettings actionCodeSettings = ActionCodeSettings(
      url: 'http://myurl.io/join',
      androidInstallApp: false,
      androidMinimumVersion: "23",
      androidPackageName: "com.smartersvision.doctors_appointments",
      handleCodeInApp: true,
    );
  }

  deleteFireBaseInstance() async {
    FirebaseMessaging.instance.deleteToken();
  }

  Future<void> sendPasswordResetEmail(String? email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email!);
    } catch (error) {}
  }
}
