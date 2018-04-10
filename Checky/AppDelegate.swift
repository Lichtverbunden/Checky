//
//  AppDelegate.swift
//  Checky
//
//  Created by Ken Krippeler on 12.03.18.
//  Copyright © 2018 Lichtverbunden. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
       do
        {
            _ = try Realm()
        }
        catch
        {
            print("Error initializing new realm: \(error.localizedDescription)")
        }
        
        return true
    }
}



