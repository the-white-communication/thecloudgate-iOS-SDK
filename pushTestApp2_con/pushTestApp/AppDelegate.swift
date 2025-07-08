//
//  AppDelegate.swift
//  pushTestApp
//
//  Created by 220804 on 4/21/25.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import twcLibrary

public let TWC_BASE_KEY = "twcUrl"

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        application.delegate = self
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if error != nil {
                print("Failed requesting notification permission: ", error ?? "")
            }
            
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
        
        return true
    }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                  -> Void) {
        
        // 앱이 실행 중이고, 채팅이 열려 있으면 TWC 푸쉬 배너를 표시 하지 않게 함.
        if TwcManager.shared.isTwcChatOpenning() {
            TwcManager.shared.reciveNotification(notification: notification)
            completionHandler([])
            return
        }
        
        completionHandler([.badge, .sound, .banner])
    }

    // 백그라운드 or 앱 런치 시 작성
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        TwcManager.shared.reciveNotification(notification: response.notification)
        
        // 채팅이 열려 있으면 다시 채팅창을 열지 않음.
        if !TwcManager.shared.isTwcChatOpenning() {
            
            // twc push 일 경우 채팅창을 열 수 있음.
            if TwcManager.shared.hasTwcPushNotification() == true {
                let vc: TwcWebViewController = TwcManager.shared.getWebViewController()
                
                if let topVC = topViewController() {
                    topVC.present(vc, animated: true)
                }
            }
        }
        
        
      completionHandler()
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                       -> Void) {
      completionHandler(.newData)
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().token { token, error in
            TwcManager.shared.initPushToken(token: token)
        }
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("✅ FCM Token updated: \(fcmToken ?? "nil")")
        TwcManager.shared.initPushToken(token: fcmToken)
    }

}

 extension AppDelegate {
     func topViewController(base: UIViewController? = UIApplication.shared.connectedScenes
        .compactMap { ($0 as? UIWindowScene)?.keyWindow }
        .first?.rootViewController) -> UIViewController? {
            
            if let nav = base as? UINavigationController {
                return topViewController(base: nav.visibleViewController)
            }
            
            if let tab = base as? UITabBarController {
                if let selected = tab.selectedViewController {
                    return topViewController(base: selected)
                }
            }
            
            if let presented = base?.presentedViewController {
                return topViewController(base: presented)
            }
            
            return base
        }
    
}
