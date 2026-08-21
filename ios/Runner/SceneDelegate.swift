import Flutter
import UIKit
import UserNotifications

class SceneDelegate: FlutterSceneDelegate, UNUserNotificationCenterDelegate {

  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)
    // 让 App 处于前台时也能展示本地通知横幅/声音/角标
    UNUserNotificationCenter.current().delegate = self
  }

  // 前台收到通知时的展示策略：允许 alert / badge / sound
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([.alert, .badge, .sound])
  }
}
