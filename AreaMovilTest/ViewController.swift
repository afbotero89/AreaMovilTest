//
//  ViewController.swift
//  AreaMovilTest
//
//  Created by Andres Botero on 3/22/19.
//  Copyright © 2019 Andres Botero. All rights reserved.
//

import UIKit
import RealmSwift

let usersSearch = UsersCheck()

class ViewController: UIViewController {
    
    @IBOutlet weak var userIdInputText: UITextField!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        
        notifications()
        
        loadDefaultUser(realm: realm)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    /**
     Creates the notifications (updateUserImage)
     - Parameters: none
     - Returns: none
     */
    func notifications(){
        NotificationCenter.default.addObserver(self,
                                               
                                               selector: #selector(ViewController.updateUserImage),
                                               
                                               name: NSNotification.Name(rawValue: "updateUserImage"),
                                               
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               
                                               selector: #selector(ViewController.UserNotFoundAlert),
                                               
                                               name: NSNotification.Name(rawValue: "displayUserNotFoundAlert"),
                                               
                                               object: nil)
        
    }
    
    /**
     Loads the default user stored in realm database
     - Parameters: intance realm database
     - Returns: none
     */
    func loadDefaultUser(realm:Realm){
        
        let git_users = GitUsers()
        
        try! realm.write {
            
            let gitUsers = realm.objects(GitUsers.self).filter("id == 1").first
            
            if(gitUsers != nil){
                
                if(gitUsers!["lastGitUserId"] != nil){
                
                    let lastUserID = gitUsers!["lastGitUserId"]! as! NSString
                
                    let userNameDB = gitUsers!["userNameDB"]! as! NSString
                    
                    var userImageDB = gitUsers!["userImageDB"]!
                    
                    userImageDB = UIImage(data:userImageDB as! Data,scale:1.0) as Any
                    
                    userName.text = userNameDB as String
                    
                    userImage.image = (userImageDB as! UIImage)
                    
                    print(lastUserID)
                
                    //usersSearch.getUserByID(id: Int(lastUserID as String)!)
                
                }
                //realm.deleteAll()
                
            }else{
                realm.add(git_users)
            }
        }
    }
    
    /**
     Updates de user image and user name when has been finished the query to git API
     - Parameters: notifications instance
     - Returns: none
     */
    @objc func updateUserImage(notification:NSNotification){
        print(notification.userInfo!)
        DispatchQueue.main.async {
            let userData = notification.userInfo
            
            UIView.transition(with: self.userImage,
                              duration:1.0,
                              options: .transitionFlipFromLeft,
                              animations: { self.userImage.image = userData!["userImage"]! as? UIImage },
                              completion: nil)
            //self.userImage.image = userData!["userImage"]! as? UIImage
            self.userName.text = userData!["userName"]! as? String
        }
    }
    
    @IBAction func searchButton(_ sender: Any) {
        
        usersSearch.getUserByID(id: userIdInputText.text!)
    }
    
    /**
     Display alert message when doesn't find any user.
     - Parameters: notifications instance
     - Returns: None
     */
    @objc func UserNotFoundAlert(notification:NSNotification){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: NSLocalizedString("User not found", comment: ""), message: NSLocalizedString("Check the login or user id", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Done", comment: ""), style: .default) { _ in })
            self.present(alert, animated: true){}
        }
    }
}

