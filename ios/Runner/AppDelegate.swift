import Flutter
import UIKit
import GoogleMaps
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate, MessagingDelegate {
  private var notificationTapChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // ✅ GOOGLE MAPS API KEY (REQUIRED)
    GMSServices.provideAPIKey("AIzaSyDWMVK2lE2TNVK7v3gNH3OiLTV4f3PSLFA")

    // ✅ FCM Setup
    // Set FCM messaging delegate
    Messaging.messaging().delegate = self

    // Set UNUserNotificationCenter delegate for foreground notifications
    UNUserNotificationCenter.current().delegate = self

    // Register for remote notifications
    application.registerForRemoteNotifications()

    let ok = super.application(application, didFinishLaunchingWithOptions: launchOptions)

    // Bridge notification taps to Flutter so simulator `simctl push` payloads
    // can deep-link even when firebase_messaging doesn't emit open callbacks.
    if let controller = window?.rootViewController as? FlutterViewController {
      // Prevent white flash between LaunchScreen -> Flutter first frame.
      // Use named color with light/dark variants (Assets.xcassets).
      let bg = UIColor(named: "LaunchBackground") ?? UIColor(red: 0.03921568627, green: 0.03921568627, blue: 0.07843137255, alpha: 1.0)
      window?.backgroundColor = bg
      controller.view.backgroundColor = bg

      notificationTapChannel = FlutterMethodChannel(
        name: "com.sachit.myitihas/notification_tap",
        binaryMessenger: controller.binaryMessenger
      )
    }

    return ok
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  // ✅ Handle APNs token registration
  override func application(_ application: UIApplication,
      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // Pass the APNs token to Firebase Messaging
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  // ✅ Handle FCM token refresh
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    // FCM token is received - Flutter handles token storage via firebase_messaging
    let dataDict: [String: String] = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: dataDict
    )
  }

  // ✅ Handle foreground notification presentation
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
      willPresent notification: UNNotification,
      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    // Show notification banner even when app is in foreground
    completionHandler([.banner, .sound, .badge])
  }

  // ✅ Handle notification tap
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
      didReceive response: UNNotificationResponse,
      withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    #if DEBUG
    print("[iOS] Notification tap userInfo: \(userInfo)")
    #endif

    notificationTapChannel?.invokeMethod("notification_tap", arguments: userInfo)
    // Forward to Flutter/Firebase plugins (critical for deep-link navigation).
    super.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
  }
}
