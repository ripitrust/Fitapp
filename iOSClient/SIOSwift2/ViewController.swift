//
//  ViewController.swift
//  SIOSwift2
//
//  Created by Chris Yang on 27/3/15.
//  Copyright (c) 2015 Chris Yang. All rights reserved.
//
import UIKit
class ViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var calField: UITextField!
    @IBOutlet weak var wellBeingField: UITextField!
    
   
    @IBOutlet weak var reqName: UITextField!
    @IBOutlet weak var reqAge: UITextField!
    @IBOutlet weak var reqGender: UITextField!
    @IBOutlet weak var reqCalories: UITextField!
    @IBOutlet weak var connButt: UIButton!
    @IBAction func findButton(sender: AnyObject) {
        if reqName.text == "" {
            let alert = UIAlertController(title: "Name is empty",
                message: "Please enter your name to search",preferredStyle: .Alert)
        func handler(act:UIAlertAction!)
        {
        }
            alert.addAction(UIAlertAction(
                title: "OK", style: .Cancel, handler: handler))
        self.presentViewController(alert, animated: true, completion: nil)
        }
        self.socket.emit("query", ["name":"\(reqName.text)"])
        self.socket.on("no match") {data, ack in
            let alert = UIAlertController(title: "No record found",
                message: "Please  upload info first",preferredStyle: .Alert)
            func handler(act:UIAlertAction!)
            {
            }
            alert.addAction(UIAlertAction(
            title: "OK", style: .Cancel, handler: handler))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        self.socket.on("found") {data, ack in
            let alert = UIAlertController(title: "Result Found",
                message: "Your info has been loaded",preferredStyle: .Alert)
            func handler(act:UIAlertAction!)
            {
            }
            alert.addAction(UIAlertAction(
                title: "OK", style: .Cancel, handler: handler))
            self.presentViewController(alert, animated: true, completion: nil)
            if let msg = data?[1] as? String? {
               self.reqAge.text = msg
            }
            if let msg = data?[2] as? String? {
                 self.reqGender.text = msg
            }
            if let msg = data?[3] as? String? {
                self.reqCalories.text = msg
            }
            self.reqName.clearsOnBeginEditing = false
            }
}
    @IBOutlet weak var dbStatus: UILabel!
    @IBAction func disconnButton(sender: UIButton) {
        socket.close(fast: true)
        connButt.enabled =  true
    }
    @IBAction func connectButton(sender: UIButton) {
        if socket.connected == true {
            let alert = UIAlertController(title: "Socket already connected",
                message: "Disconnect before re-connect",preferredStyle: .Alert)
            func handler(act:UIAlertAction!)
            {
            }
            alert.addAction(UIAlertAction(
                title: "OK", style: .Cancel, handler: handler))
            self.presentViewController(alert, animated: true, completion: nil)
            connButt.enabled = false
            }
        else {
        socket.connect()
        socket.on("connect") {data,ack in
            let alert = UIAlertController(title: "Connection successful",
                message: "You have connected to the Server",preferredStyle: .Alert)
            func handler(act:UIAlertAction!)
            {
            }
            alert.addAction(UIAlertAction(
                title: "OK", style: .Cancel, handler: handler))
            self.presentViewController(alert, animated: true, completion: nil)
            println("socket connected")
            self.socket.emit("handshake")
            }
    }
    }
    @IBAction func sendMessage(sender: UIButton) {
        self.socket.emit("data",
            ["name":"\(nameField.text)",
            "age":"\(ageField.text)",
            "gender":"\(genderField.text)",
            "calories":"\(calField.text)",
            "wellBeingScore":"\(wellBeingField.text)"
            ])
        }
    let socket = SocketIOClient(socketURL: "http://localhost:3000")
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.clearsOnBeginEditing = true
        ageField.clearsOnBeginEditing = true
        genderField.clearsOnBeginEditing = true
        calField.clearsOnBeginEditing = true
        reqName.clearsOnBeginEditing = true
        wellBeingField.clearsOnBeginEditing=true
        socket.onAny {println("got event: \($0.event) with items \($0.items)")}
        let data = JSON (["name":"\(nameField.text)",
                          "age":"\(ageField.text)",
                          "gender":"\(genderField.text)",
                          "calories":"\(calField.text)",
                            "wellBeingScore":"\(wellBeingField.text)",
])
          let name = data["name"]
          let wb = data["wellBeingScore"]
        println("name is \(name)")
        println("wbscore is \(wb)")
        socket.on("db status") {data, ack in
            if let msg = data?[0] as? String? {
                let alert = UIAlertController(title: "Save Successful",
                    message: "Welcome to the Fit",preferredStyle: .Alert)
                func handler(act:UIAlertAction!)
                {
                }
                alert.addAction(UIAlertAction(
                    title: "OK", style: .Cancel, handler: handler))
                self.presentViewController(alert, animated: true, completion: nil)
            }
    }
     /*
        // Requesting acks, and responding to acks
        socket.on("ackEvent") {data, ack in
            if let str = data?[0] as? String {
                println("Got ackEvent")
            }
            // data is an array
            if let int = data?[1] as? Int {
                println("Got int")
            }
            // You can specify a custom timeout interval. 0 means no timeout.
           self.socket.emitWithAck("ackTest", "test").onAck(0) {data in
                println(data?[0])
            }
            ack?("Got your event", "dude")
        }
        socket.on("jsonTest") {data, ack in
            if let json = data?[0] as? NSDictionary {
                println(json["test"]!) // foo bar
            }
        }
       */
    }
}
