//
//  ViewController.swift
//  MMS_LEC_Project
//
//  Created by Septatrivanto Wandy on 16/12/21.
//  Copyright © 2021 Septatrivanto Wandy. All rights reserved.
//
//

/*
 Anggota Kelompok:
 1. 2301869512 - Septatrivanto Wandy
 2. 2301870810 - Howard Tanner
 2. 2301864543 - Louis Siau Sentra
 3. 2301864120 - Sie Yesaya Selvix S
 4.
 5.
 
*/

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfUserPassword: UITextField!
    
    @IBAction func btnDidntHaveAccount(_ sender: Any) {
    }
    
    var userList = [User]()
    var newUserId = 0
    var context:NSManagedObjectContext!
    var userIdPass = 0
    var loginPass = 0;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let appDelegate = UIApplication.shared.delegate.self as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        tfUserPassword.textContentType = .oneTimeCode
        loadData()
    }
    
    
    func alert(msg:String, handler:((UIAlertAction)->Void)?) {
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func btnLogin(_ sender: Any) {
        if (tfUserName.text!.isEmpty){
            alert(msg: "username must not empty", handler: nil)
        }
        else if (tfUserPassword.text!.isEmpty){
            alert(msg: "password must not empty", handler: nil)
        }
        else if (userList.isEmpty) {
            alert(msg: "invalid username or password", handler: nil)
        }
        else {
            if (checkLogin() == -1) {
                alert(msg: "invalid username or password", handler: nil)
            }
            else {
                performSegue(withIdentifier: "goToExerciseSegue", sender: self)
                
            }
        }
    }
    
    func checkLogin() -> Int {
        for data in userList{
            if (data.userName == tfUserName.text! && data.userPassword == tfUserPassword.text!) {
                userIdPass = data.userId
                return 1
            }
        }
        return -1
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToRegisterSegue" {
//            let navigation = segue.destination as! UINavigationController
//            let destination = navigation.viewControllers.first as! RegisterViewController
//        }
//
//    }
    
    @IBAction func unwindToViewControllerBack(_ unwindSegue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindToViewControllerInsertDBUser(_ unwindSegue: UIStoryboardSegue) {
        if let source = unwindSegue.source as? RegisterViewController {
            
            if (userList.isEmpty) {
                newUserId = 0
            }
            else {
                newUserId = newUserId + 1
            }
            
            let newUserName = source.tfUserName.text!
            let newUserEmail = source.tfUserEmail.text!
            let newUserGender = source.userGender
            let newUserHeight = source.tfUserHeight.text!
            let newUserWeight = source.tfUserWeight.text!
            let newUserPassword = source.tfUserPassword.text!
            
            let entity = NSEntityDescription.entity(forEntityName: "UserEntity", in: context)
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            
            newUser.setValue(newUserId, forKey: "userId")
            newUser.setValue(newUserName, forKey: "userName")
            newUser.setValue(newUserEmail, forKey: "userEmail")
            newUser.setValue(newUserGender, forKey: "userGender")
            newUser.setValue(Int(newUserHeight), forKey: "userHeight")
            newUser.setValue(Int(newUserWeight), forKey: "userWeight")
            newUser.setValue(newUserPassword, forKey: "userPassword")
            
            do {
                try context.save()
            } catch  {
                
            }
            loadData()
        }
    }
    
    func loadData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
        
        do {
            let results = try context.fetch(request) as! [NSManagedObject]
            userList.removeAll()
            
            for data in results {
                let userId = data.value(forKey: "userId") as! Int
                let userName = data.value(forKey: "userName") as! String
                let userEmail = data.value(forKey: "userEmail") as! String
                let userGender = data.value(forKey: "userGender") as! String
                let userHeight = data.value(forKey: "userHeight") as! Int
                let userWeight = data.value(forKey: "userWeight") as! Int
                let userPassword = data.value(forKey: "userPassword") as! String
                
                userList.append(User(
                    userId: userId,
                    userName: userName,
                    userEmail: userEmail,
                    userGender: userGender,
                    userHeight: userHeight,
                    userWeight: userWeight,
                    userPassword: userPassword
                ))
            }
        } catch  {
            
        }
    }

}

