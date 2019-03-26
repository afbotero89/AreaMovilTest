//
//  DbInteractor.swift
//  AreaMovilTest
//
//  Created by Andres Botero on 3/23/19.
//  Copyright © 2019 Andres Botero. All rights reserved.
//

import Foundation
import RealmSwift

class GitUsers: Object{
    @objc dynamic var id = 1
    @objc dynamic var lastGitUserId : String?
    @objc dynamic var userImageDB : NSData?
    @objc dynamic var userNameDB : String?
}
