//
//  ViewController.swift
//  project21
//
//  Created by Tamim Khan on 19/3/23.
//
import NotificationCenter
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "schedule", style: .plain, target: self, action: #selector(scheduleLocal))
        
    }

    @objc func registerLocal(){
        
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]){
            (granted, error) in
            if granted {
                print("noice!")
            }else{
                    print("oh, no!")
                }
            }
        
    }
    @objc func scheduleLocal(){
        
        registerCategories()
        
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "the time has come"
        content.body = "let's go outside.do some shopping.so we have to go to the mall."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
       
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        
        
    }
    
    func registerCategories(){
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        
        let show = UNNotificationAction(identifier: "show", title: "show me more", options: .foreground)
        let remindMeLater = UNNotificationAction(identifier: "remindLater", title: "Remind me later", options: .foreground)
            
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, remindMeLater], intentIdentifiers: [])
        
        
        center.setNotificationCategories([category])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        
        if let customData = userInfo["customData"] as? String{
            print("custom data recived \(customData)")
            
            switch response.actionIdentifier{
            case UNNotificationDefaultActionIdentifier:
                
                print("default identifier")
                
            case "show":
                print("show more information")
                let alertController = UIAlertController(title: "More Information", message: "Here is some more information about the notification.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                print("OK tapped")
                }
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
            case "remindLater":
                        print("remind me later")
                let content = response.notification.request.content
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false))
                                
                               
                center.add(request, withCompletionHandler: nil)
                                
                        
            
            default:
                break
                
                
            }
            
        }
        completionHandler()
        
    }
    
}

