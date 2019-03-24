//
//  UsersCheck.swift
//  AreaMovilTest
//
//  Created by Andres Botero on 3/23/19.
//  Copyright © 2019 Andres Botero. All rights reserved.
//

import Foundation
import RealmSwift

class UsersCheck : Object{
    
    var userID:String?
    
    func getUserByID(id:Int){
        
        userID = String(id)
        
        var apiGitUrl = URLRequest(url: URL(string:"https://api.github.com/users/\(id)")!)
        
        apiGitUrl.httpMethod = "GET"
        
        apiGitUrl.setValue("Googlebot/2.1 (+http://www.google.com/bot.html)", forHTTPHeaderField: "User-Agent")
        
        let task = URLSession.shared.dataTask(with: apiGitUrl, completionHandler: {
            data, response, error in
            
            let str = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
            
            self.downloadImageFromURL(userGitInfo: str)

        })
        task.resume()
    }
    
    func downloadImageFromURL(userGitInfo : [String : AnyObject]){
        
        let url = userGitInfo["avatar_url"]! as! String
        
        var userName = ""
        
        let nameValue = userGitInfo["name"] as? String
        
        if (nameValue != nil) {
            userName = (userGitInfo["name"]! as? String)!
        }else{
            userName = "Empty"
        }
        
        
        let userPictureURL = URL(string: url)!
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        
        let downloadPicTask = URLSession.shared.dataTask(with: userPictureURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let image = UIImage(data: imageData)
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateUserImage"), object: nil, userInfo: ["userImage":image as Any,"userName":userName])
                        
                        self.updateUserIdIntoDB(id: self.userID!)
                        
                        // Do something with your image.
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        
        downloadPicTask.resume()
    }
    
    func updateUserIdIntoDB(id:String){
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let realm = try! Realm()
                let gitUsers = realm.objects(GitUsers.self).filter("id == 1").first
                try! realm.write {
                    gitUsers!.last_git_user_id = id
                }
            }
        }
    }
}
