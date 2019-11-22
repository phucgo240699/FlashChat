//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    var messages:[Message]=[
//    Message(sender: "phuc", body: "hi"),
//    Message(sender: "dung", body: "hello"),
//    Message(sender: "phuc", body: "how are you?")
    ]

    let db=Firestore.firestore()
    
    func loadMessage(){
        db.collection("messages")
            .order(by: "date")
            .addSnapshotListener { (querySnapShot, error) in
            guard error == nil else{
                print("Failed load message")
                return
            }
            guard let Docs = querySnapShot?.documents else{
                
                print("Failed load message second error")
                return
            }
            self.messages=[]
            for doc in Docs{
                guard let messageSender=doc.data()["sender"] as? String, let messageBody=doc.data()["body"] as? String else{
                    print("Failed third")
                    return
                }
                self.messages.append(Message(sender: messageSender, body: messageBody))
            }
            self.tableView.reloadData()
            print("Success load message")
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MessageCellTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        loadMessage()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationItem.hidesBackButton=true
    }
    
    
    @IBAction func sendPressed(_ sender: UIButton) {
        guard let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email else {
            print("Failed prepare before send message")
            return
        }
        
        db.collection("messages")
            .addDocument(data: ["sender": messageSender, "body": messageBody, "date": Date().timeIntervalSince1970]) { (error) in                                                      guard error == nil else{
            print("Failed send message to firecloud store")
                return
            }
            print("Success")
            
                                                        
        }
        
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
            let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
          
    }
    
}

extension ChatViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCellTableViewCell
        cell.textLabel?.text=messages[indexPath.row].body
        return cell
    }
    
    
}

