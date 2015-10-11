//
//  ViewController.swift
//  Sudo
//
//  Created by fong tinyik on 5/31/15.
//  Copyright (c) 2015 fong tinyik. All rights reserved.
//

import UIKit

var isTeacher : Bool!
class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var phoneField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var classField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var register_1: UIView!
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var register_2: UIView!
    @IBOutlet weak var schoolField: UITextField!
    @IBOutlet weak var loginGreen: UIButton!
    @IBOutlet weak var registerGreen: UIButton!
    @IBOutlet weak var loginPasswordField: UITextField!
    @IBOutlet weak var sendVeriSMS: UIButton!
    
    var countDown: Int!
    var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        codeField.delegate = self
        self.register_1.layer.shadowColor = UIColor.blackColor().CGColor
        self.register_1.layer.shadowOpacity = 0.26
        self.register_1.layer.shadowOffset  = CGSizeMake(-1,1)
        self.register_1.layer.cornerRadius = 5
        
        self.register_2.layer.shadowColor = UIColor.blackColor().CGColor
        self.register_2.layer.shadowOpacity = 0.26
        self.register_2.layer.shadowOffset  = CGSizeMake(-1,1)
        self.register_2.layer.cornerRadius = 5
        registerButton.setBackgroundImage(UIImage(named: "RegiBtn_0001_Register"), forState: UIControlState.Selected)
        registerButton.addTarget(self, action: "handleSelection:", forControlEvents: .TouchUpInside)
        loginButton.setBackgroundImage(UIImage(named: "RegiBtn_0002_Log-in-拷贝"), forState: UIControlState.Selected)
        loginButton.addTarget(self, action: "_handleSelection:", forControlEvents: .TouchUpInside)
        registerButton.tintColor = UIColor.clearColor()
        loginButton.tintColor = UIColor.clearColor()
        registerButton.selected = true
        loginGreen.hidden = true
        loginPasswordField.hidden = true
        setShadow(loginGreen)
        setShadow(registerGreen)
        setShadow(sendVeriSMS)
        
        
        
    }

    func updateCountDown() {
        countDown = countDown - 1
        sendVeriSMS.setTitle("\(countDown)", forState: .Normal)
        
        if countDown == 0 {
            sendVeriSMS.setTitle("Verification", forState: .Normal)
            sendVeriSMS.userInteractionEnabled = true
            timer.invalidate()
        }
    }
    //FIXME: 当什么都不输入时会Experience不设置
    
    @IBAction func confirm() {
        var currentUser = BmobUser.getCurrentUser()
        if currentUser != nil {
            println("IDENTIFIED")
            currentUser.password = passwordField.text
            currentUser.setObject(isTeacher, forKey: "isTeacher")
            currentUser.setObject(nameField.text, forKey: "username")
            currentUser.setObject(schoolField.text, forKey: "School")
            var classes = classField.text.componentsSeparatedByString("&")
            currentUser.setObject(classes, forKey: "Class")
            currentUser.setObject(0, forKey: "Experience")
            currentUser.updateInBackground()
            println(BmobUser.getCurrentUser().objectForKey("mobilePhoneNumber"))
            
            self.performSegueWithIdentifier("login", sender: nil)
            
            
        }
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        backGroundTap()
        if textField == loginPasswordField {
            loginUser()
            println("sdfds")
        }
        
        println("sdf")
        return true
        
    }
    
    @IBAction func backGroundTap() {
        codeField.resignFirstResponder()
        phoneField.resignFirstResponder()
        loginPasswordField.resignFirstResponder()
        passwordField.resignFirstResponder()
        nameField.resignFirstResponder()
        classField.resignFirstResponder()
        schoolField.resignFirstResponder()
    }
    
    @IBAction func sendSMS(sender: UIButton) {
        countDown = 60
        sender.userInteractionEnabled = false
        let phoneNumber = phoneField.text
        BmobSMS.requestSMSCodeInBackgroundWithPhoneNumber(phoneNumber, andTemplate: nil, resultBlock: {
            (number, error) -> () in
             println("SMS SENT")

        })
        
        phoneField.resignFirstResponder()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateCountDown", userInfo: nil, repeats: true)
        timer.fire()
   

}

    @IBAction func registerUser() {
    let phoneNumber = phoneField.text
    let smsCode = codeField.text
        BmobUser.signOrLoginInbackgroundWithMobilePhoneNumber(phoneNumber, andSMSCode: smsCode){(_user , error) -> () in
            if _user != nil {
            
            UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options:.CurveEaseInOut, animations: { () -> Void in
                self.register_1.transform = CGAffineTransformMakeTranslation(-400, 0)
                self.register_2.transform = CGAffineTransformMakeTranslation(-413, 0)
                }, completion: nil)
                
            }else {
                let alert = UIAlertView(title: nil, message: "验证码输入有误！", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
            
                   }
    }
    @IBAction func loginUser() {
        let phoneNumber = phoneField.text
        let password = loginPasswordField.text
        BmobUser.loginInbackgroundWithAccount(phoneNumber, andPassword: password){
            (_user,error) -> Void in
            
            if _user != nil {
               self.performSegueWithIdentifier("login", sender: nil)
               
                
            }else {
                let alert = UIAlertView(title: nil, message: "手机号或密码不正确。", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                
            }
            
        }
    }
    
    func handleSelection(sender: UIButton) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,0), dispatch_get_main_queue()) { () -> Void in
            sender.selected = true
        }
        if loginButton.selected {
            loginButton.selected = false        }
    
        codeField.hidden = false
        loginGreen.hidden = true
        registerGreen.userInteractionEnabled = true
        registerGreen.hidden = false
        loginPasswordField.hidden = true
       
    }
    
    func _handleSelection(sender: UIButton){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,0), dispatch_get_main_queue()) { () -> Void in
            sender.selected = true
        }
        if registerButton.selected {
            registerButton.selected = false}
        
        loginGreen.hidden = false
        codeField.hidden = true
        registerGreen.userInteractionEnabled = false
        registerGreen.hidden = true
        loginPasswordField.hidden = false
        
        
        
    }
    
   
    func keyboardWillShow(notification: NSNotification) {
        
        self.view.frame.origin.y = -200
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        self.view.frame.origin.y = 0
        
    }

    func setShadow(sender: UIButton){
        sender.layer.shadowColor = UIColor.blackColor().CGColor
        sender.layer.shadowOffset = CGSizeMake(0.5, 0.5)
        sender.layer.shadowOpacity = 0.16
    
    }
}