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
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        let git_users = GitUsers()
        git_users.last_git_user_id = "test"
        
        try! realm.write {
            //realm.deleteAll()
            let gitUsers = realm.objects(GitUsers.self).filter("id == 1").first
            
            let lastUserID = gitUsers!["last_git_user_id"]! as! NSString
            
            print(lastUserID)
            
            usersSearch.getUserByID(id: Int(lastUserID as String)!)
            
            if(git_users != nil){
                realm.deleteAll()
                realm.add(git_users)
            }
            
        }
        
        notifications()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func notifications(){
        NotificationCenter.default.addObserver(self,
                                               
                                               selector: #selector(ViewController.updateUserImage),
                                               
                                               name: NSNotification.Name(rawValue: "updateUserImage"),
                                               
                                               object: nil)
    }
    
    @objc func updateUserImage(notification:NSNotification){
        print(notification.userInfo!)
        DispatchQueue.main.async {
            let userData = notification.userInfo
            self.userImage.image = userData!["userImage"]! as? UIImage
            self.userName.text = userData!["userName"]! as? String
        }
    }
    
    @IBAction func searchButton(_ sender: Any) {
        
        usersSearch.getUserByID(id: Int(userIdInputText.text!)!)
    }
    
}

