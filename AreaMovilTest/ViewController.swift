//
//  ViewController.swift
//  AreaMovilTest
//
//  Created by Andres Botero on 3/22/19.
//  Copyright © 2019 Andres Botero. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        // Do any additional setup after loading the view, typically from a nib.
    }


}

