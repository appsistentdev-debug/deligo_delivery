import UIKit
import Flutter
import GoogleMaps // update by Prateek
import OneSignalFramework  // OneSignal update by Prateek

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyApxeMGwIua3nnKf4i-iMXzKwyVLgtPuAA") // add this line with your iOS key update by Prateek
    // OneSignal Debug Logs (optional) update by prateek
    OneSignal.Debug.setLogLevel(.LL_VERBOSE)

    // OneSignal Initialization update by Prateek
    OneSignal.initialize("ONESIGNAL_APP_ID_DELIVERY")

    // Ask for push notification permission (IMPORTANT for iOS) update by Prateek
    OneSignal.Notifications.requestPermission({ accepted in
      print("User accepted notifications: \(accepted)")
    }, fallbackToSettings: true)

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}


