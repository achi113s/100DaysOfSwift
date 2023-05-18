//
//  ViewController.swift
//  Project21LocalNotifications
//
//  Created by Giorgio Latour on 5/14/23.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Yay!")
            } else {
                print("D'oh!")
            }
        }
    }
    
    @objc func scheduleLocal() {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let snooze = UNNotificationAction(identifier: "snooze", title: "Remind me later...", options: .destructive)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, snooze], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom Data Received \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                print("Default Identifier")
                let ac = UIAlertController(title: "Default Identifier", message: "", preferredStyle: .alert)
                let acAction = UIAlertAction(title: "OK", style: .cancel)
                ac.addAction(acAction)
                present(ac, animated: true)
            case "show":
                print("Show more information.")
                let ac = UIAlertController(title: "Show", message: "Showing you more information!", preferredStyle: .alert)
                let acAction = UIAlertAction(title: "OK", style: .cancel)
                ac.addAction(acAction)
                present(ac, animated: true)
            case "snooze":
                scheduleLocal()
                print("Snoozed")
            default:
                break
            }
        }
        
        completionHandler()
    }
    
}

