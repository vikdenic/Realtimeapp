//
//  ViewController.swift
//  realtimeapp
//
//  Created by Vik Denic on 1/28/16.
//  Copyright © 2016 nektar labs. All rights reserved.
//

import UIKit
import Firebase //needed to add use_frameworks to podfile to avoid error

class OldViewController: UIViewController {

    @IBOutlet var topLabel: UILabel!
    @IBOutlet var textField: UITextField!

    let firebase = Firebase(url: "https://nektar-realtimeapp.firebaseio.com/") //the starting point for all firebase operations

    override func viewDidLoad() {
        super.viewDidLoad()

        //listens to data changes, based on event type
        firebase.observeEventType(FEventType.Value) { (snapshot: FDataSnapshot!) -> Void in
            if let someUser = snapshot.value["user"] {
                if let someName = someUser?.objectForKey("name") as? String {
                    self.topLabel.text = someName
                }

                if let isOnline = someUser?.objectForKey("isOnline") as? Bool {
                    if isOnline {
                        self.view.backgroundColor = UIColor.greenColor()
                    } else {
                        self.view.backgroundColor = UIColor.redColor()
                    }
                }
            }
        }
    }
    
    @IBAction func onSendTapped(sender: UIButton) {
        firebase.childByAppendingPath("user").childByAppendingPath("name").setValue(textField.text)
    }
}

