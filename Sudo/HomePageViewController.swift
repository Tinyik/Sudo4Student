//
//  HomePageViewController.swift
//  Sudo
//
//  Created by fong tinyik on 6/1/15.
//  Copyright (c) 2015 fong tinyik. All rights reserved.
//

import UIKit
var studentSheet: SudoSheet!
var reports: [SheetReport]!
var deviceScale: CGFloat!
var isiPhone6: Bool!
class HomePageViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UIAlertViewDelegate {
    
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var answerContainer: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var sideBar: UIView!
    @IBOutlet weak var answerView: UITableView!
    @IBOutlet weak var exAnswerView: UITableView!
    @IBOutlet weak var sideBarScroller: UIScrollView!
    @IBOutlet weak var badgesBtn: UIButton!
    @IBOutlet weak var settingView: UIControl!
    @IBOutlet weak var sheetNameLabel: UILabel!
    @IBOutlet weak var recordView: UICollectionView!
    @IBOutlet weak var savedView: UIImageView!
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var threshholdLabel: UILabel!
    @IBOutlet weak var settingSchoolField: UITextField!
    @IBOutlet weak var settingPwField: UITextField!
    @IBOutlet weak var settingClassField: UITextField!
    
    
    
    var maskView: UIView!
    var mask: UIView!
    var showReportBtn: UIButton!
    
    
    
    //Search Display
    var contactQuery: BmobQuery!
    var rowNo: Int!
    var tempTeacher: BmobUser!
    var teacherArray: NSMutableArray!
    var notification: SheetNotificationView!
    var sheetArray = [BmobObject]()
    var numberOfRows: Int!
    var _questionNumber : Int!
    var _sheetName : String!
    //  var _isRequireReport : Bool!
    var _isAnswerVisible : Bool!
    var _isRequireChoiceE: Bool!
    var _teacherAnswer : NSArray!
    var _studentAnswer : NSMutableArray!
    var _wrongAnswer : Dictionary<Int, Int>!
    var _objectID: String!
    
    var tempStudentAnswerArray: NSMutableArray!
    var tempWrongAnswer: Dictionary<Int, Int>!
    var tempQuestionNumber: Int!
    var tempSheetName: String!
    var tempIsRequireE: Bool!
    var tempIsAnswerVisible: Bool!
    
    
    func loadUserData() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDir = paths[0] as! String
        let docPath = documentDir.stringByAppendingPathComponent("ReportRecords.plist")
        if let _reports = NSKeyedUnarchiver.unarchiveObjectWithFile(docPath) as? [SheetReport] {
            reports = _reports
            
        }else{
            reports = []
            println("NIL")
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        
        savedView.layer.opacity = 0
        settingView.layer.opacity = 0
        loadUserData()
        answerView.delegate = self
        answerView.dataSource = self
        answerView.separatorStyle = .None
        exAnswerView.separatorStyle = .None
        sendButton.hidden = true
        sendButton.layer.opacity = 0
        answerContainer.layer.shadowColor = UIColor.blackColor().CGColor
        answerContainer.layer.cornerRadius = 5
        answerContainer.layer.shadowOffset = CGSizeMake(-1, 1)
        answerContainer.layer.shadowOpacity = 0.26
        sideBarScroller.bounces = true
        sideBarScroller.userInteractionEnabled = true
        syncOnlineSheets()
        
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.recordView.reloadData()
    }
    func handleSheetSelection(sender: UIGestureRecognizer) {
        _questionNumber = sheetArray[sender.view!.tag].objectForKey("QuestionNumber") as! Int
        _sheetName = sheetArray[sender.view!.tag].objectForKey("SheetName") as! String
        //   _isRequireReport = sheetArray[sender.view!.tag].objectForKey("isRequireReport") as! Bool
        _isRequireChoiceE = sheetArray[sender.view!.tag].objectForKey("isRequireChoiceE") as! Bool
        _isAnswerVisible = sheetArray[sender.view!.tag].objectForKey("isAnswerVisible") as! Bool
        _teacherAnswer = sheetArray[sender.view!.tag].objectForKey("Answer") as! NSArray
        
        
        _objectID = sheetArray[sender.view!.tag].objectId
        
        
        println(_teacherAnswer)
        self.numberOfRows = _questionNumber
        answerView.reloadData()
        self.sheetNameLabel.text = _sheetName
        tempSheetName = (sender.view as! SheetNotificationView).sheetNameLabel.text!
        studentSheet = SudoSheet(sheetName: _sheetName, questionNo: _questionNumber, isAnswerVisible: _isAnswerVisible, isRequireChoiceE: _isRequireChoiceE)
        
        
    }
    
    func handleRecordSelection(sender: UIGestureRecognizer) {
        tempStudentAnswerArray = reports[sender.view!.tag].studentAnswerArray
        tempWrongAnswer = reports[sender.view!.tag].wrongAnswer
        tempQuestionNumber = reports[sender.view!.tag].questionNumber
        tempIsRequireE = reports[sender.view!.tag].isRequireChoiceE
        tempIsAnswerVisible = reports[sender.view!.tag].isAnswerVisible
        
        performSegueWithIdentifier("showRecord", sender: nil)
    }
    
    
    func compareAnswer(studentAnswer: NSMutableArray, withTeacherAnswer teacherAnswer: NSArray) {
        println(teacherAnswer.count)
        
        println(studentAnswer.count)
        _wrongAnswer = Dictionary()
        
        for var i = 0; i < teacherAnswer.count; ++i {
            if studentAnswer[i] as! Int != teacherAnswer[i] as! Int {
                _wrongAnswer[i] = teacherAnswer[i] as! Int
            }
            
            
            
        }
        
        println(_wrongAnswer)
        
    }
    @IBAction func inputCancelled() {
        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.sendButton.transform = CGAffineTransformMakeTranslation(0, 90*deviceScale)
            self.sendButton.layer.opacity = 1
            
            }, completion: nil)
        
        UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .CurveEaseOut, animations: { () -> Void in
            
            self.answerContainer.transform = CGAffineTransformIdentity
            }, completion: nil)
        
    }
    
    @IBAction func inputAnswers() {
        if _isRequireChoiceE == true {
            answerView.hidden = true
            exAnswerView.hidden = false
        }else{
            exAnswerView.hidden = true
            answerView.hidden = false
        }
        
        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.answerContainer.transform = CGAffineTransformMakeTranslation(0, -610*deviceScale)
            self.answerContainer.layer.opacity = 1
            
            
            }, completion: nil)
        
        sendButton.hidden = false
        
        answerContainer.hidden = false
        answerView.reloadData()
        exAnswerView.reloadData()
        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.sendButton.transform = CGAffineTransformMakeTranslation(0, -90*deviceScale)
            self.sendButton.layer.opacity = 1
            
            }, completion: nil)
        
        
        
    }
    
    @IBAction func showBadges(sender: UIButton) {
        
        
    }
    @IBAction func showSettings() {
        settingView.backgroundColor = UIColor(patternImage: UIImage(named: "Setting")!)
        settingPwField.text = BmobUser.getCurrentUser().password
        settingSchoolField.text = BmobUser.getCurrentUser().objectForKey("School") as? String
        let gRec = UISwipeGestureRecognizer(target: self, action: "settingCancelled")
        gRec.direction = .Left
        
        settingView.addGestureRecognizer(gRec)
        
        
        //  settingClassField.text = BmobUser.getCurrentUser().objectForKey("Class") as? String
        var classString = ""
        for _class in BmobUser.getCurrentUser().objectForKey("Class") as! [String] {
            classString += _class + "&"
        }
        classString = dropLast(classString)
        settingClassField.text = classString
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.settingView.transform = CGAffineTransformMakeTranslation(375*deviceScale, 0)
            self.settingView.layer.opacity = 1
            
            }, completion: nil)
        
        dismissSideBar(nil)
        
        self.navigationItem.title = "Profile Setting"
        self.view.bringSubviewToFront(settingView)
        
        
        
        
    }
    
    func syncOnlineSheets() {
        self.sheetArray = []
        for notif in sideBarScroller.subviews {
            notif.removeFromSuperview()
        }
        var query = BmobQuery(className: "SudoSheet_")
        //MARK: 暂时只支持学生仅一个学校的情况
        query.whereKey("Class", containedIn: BmobUser.getCurrentUser().objectForKey("Class") as? [String])
        query.whereKey("School", equalTo: BmobUser.getCurrentUser().objectForKey("School"))
        
        
        
        //FIXME: 检查Session是否已经结束
        query.whereKey("isSessionEnded", equalTo: false)
        query.findObjectsInBackgroundWithBlock { (sheets, error) -> Void in
            for sheet in sheets {
                println(sheet.objectId)
                if let _sheet = sheet as? BmobObject {
                    
                    self.sheetArray.append(_sheet)
                    
                }
            }
            self.loadSideBarData()
            
        }
        
    }
    
    func loadSideBarData() {
        var query = BmobQuery(className: "StudentSheet_")
        query.whereKey("StudentName", equalTo: BmobUser.getCurrentUser().username)
        query.findObjectsInBackgroundWithBlock { (sheets, error) -> Void in
            
            if sheets.count > 0 {
                for completedSheet in sheets {
                    for incomingSheet in self.sheetArray {
                        if incomingSheet.objectId == (completedSheet as! BmobObject).objectForKey("SheetID") as! String {
                            let index = find(self.sheetArray, incomingSheet)
                            self.sheetArray.removeAtIndex(index!)
                            
                        }
                    }
                }
            }
            
            for sheet in self.sheetArray {
                if isiPhone6 == true {
                    self.notification = SheetNotificationView.initNotificationView()
                }else{
                    self.notification = SheetNotificationView.initiPhone5NotificationView()
                }
                var notifImage = UIImage(named: "SideBar_IncomingSheet")
                
                self.notification.userInteractionEnabled = true
                
                self.notification.imageView.image = notifImage
                self.notification.frame = self.notification.imageView.frame
                self.notification.backgroundColor = UIColor.clearColor()
                //self.notification.imageView.userInteractionEnabled = true
                var posiY: CGFloat!
                if isiPhone6 == true {
                    posiY = CGFloat((self.sheetArray as NSArray).indexOfObject(sheet)*115)
                }else {
                    posiY = CGFloat((self.sheetArray as NSArray).indexOfObject(sheet)*98)
                }
                // Set the tag
                self.notification.tag = (self.sheetArray as NSArray).indexOfObject(sheet)
                println(self.notification.tag)
                self.notification.frame.origin = CGPointMake(5*deviceScale, posiY)
                self.notification.sheetNameLabel.text = sheet.objectForKey("SheetName") as! String
                let tap = UITapGestureRecognizer(target: self, action: "dismissSideBar:")
                tap.addTarget(self, action: "handleSheetSelection:")
                tap.addTarget(self, action: "inputAnswers")
                self.notification.addGestureRecognizer(tap)
                
                if let questionNo = sheet.objectForKey("QuestionNumber") as? NSNumber {
                    self.notification.questionNumberLabel.text = questionNo.stringValue + " 题"
                    
                }
                self.notification.teacherNameLabel.text = sheet.objectForKey("TeacherIdentifier") as! String
                self.sideBarScroller.addSubview(self.notification)
                self.sideBarScroller.contentSize = CGSizeMake(260*deviceScale, posiY + 125)
                
                
                
                
            }
            
        }
    }
    
    @IBAction func sideBarButtonClicked() {
        println("SYNC")
        syncOnlineSheets()
        navigationItem.leftBarButtonItem?.enabled = false
        sideBar.layer.shadowColor = UIColor.blackColor().CGColor
        sideBar.layer.shadowOffset = CGSizeMake(2, 2)
        sideBar.layer.shadowOpacity = 0.4
        var exp = BmobUser.getCurrentUser().objectForKey("Experience") as! Int
        expLabel.text = "\(exp)"
        var min = SudoUserLevelThreshold.allValues[SudoUserLevelThreshold.allValues.count-1]
        for threshhold in SudoUserLevelThreshold.allValues {
            if (threshhold < min && threshhold > exp )  {
                min = threshhold
            }
        }
        levelLabel.text = "\(find(SudoUserLevelThreshold.allValues, min)!)"
        threshholdLabel.text = "\(min)"
        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            //  self.sideBar.removeFromSuperview()
            self.maskView = UIView(frame: CGRectMake(0, 0, 375*deviceScale, 700*deviceScale))
            self.maskView.backgroundColor = .blackColor()
            self.maskView.layer.opacity = 0.6
            self.view.addSubview(self.maskView)
            //  self.view.transform = CGAffineTransformMakeScale(0.9, 0.9)
            self.view.layer.opacity = 1
            
            }, completion: nil)
        
        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            // self.view.addSubview(self.sideBar)
            self.view.bringSubviewToFront(self.sideBar)
            
            // self.sideBar.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(259, 0),CGAffineTransformMakeScale(1/0.9, 1/0.9))
            self.sideBar.transform = CGAffineTransformMakeTranslation(292*deviceScale, 0)
            
            
            }, completion: nil)
        
    }
    
    @IBAction func dismissSideBar(sender: UIButton?) {
        navigationItem.leftBarButtonItem?.enabled = true
        self.maskView.hidden = true
        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            // self.view.addSubview(self.sideBar)
            self.view.bringSubviewToFront(self.sideBar)
            self.view.transform = CGAffineTransformMakeScale(1, 1)
            self.view.layer.opacity = 1
            
            
            self.sideBar.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(-259*deviceScale, 0),CGAffineTransformMakeScale(1, 1))
            
            
            }) {
                (finished) -> Void in
                
                if (finished == true && sender == self.badgesBtn )  {
                    self.performSegueWithIdentifier("showBadges", sender: nil)
                }
        }
        
        
    }
    
    @IBAction func sendSheet(sender: UIButton) {
        
        var confAlert = UIAlertView(title: "确认发送", message: "是否确认发送这份答卷？确认后将无法重新答题。", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确认")
        confAlert.show()
        
        
        //  sendNotification()
        
    }
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            sendButton.hidden = true
            
            //Update Experience
            var currentUser = BmobUser.getCurrentUser()
            var exp = currentUser.objectForKey("Experience") as! Int
            exp += numberOfRows*3
            currentUser.setObject(exp, forKey: "Experience")
            // FIXME: 添加EXP 增加提醒
            currentUser.updateInBackgroundWithResultBlock { (isSuccessful, error) -> Void in
                if isSuccessful == true {
                    println("SUCCESSFUL")
                    println(currentUser.objectForKey("Experience"))
                }
            }
            UIView.animateWithDuration(1.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.answerContainer.transform = CGAffineTransformMakeTranslation(0, -1220)
                // self.answerView.layer.opacity = 0
                
                }, completion:{(Bool) in
                    
                    self.answerContainer.transform = CGAffineTransformIdentity
                    
                }
                
            )
            
            
            UIView.animateWithDuration(1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.sendButton.transform = CGAffineTransformMakeTranslation(0, 90*deviceScale)
                self.sendButton.layer.opacity = 1
                }, completion: nil)
            
            println(studentSheet._answerArray.count)
            _studentAnswer = NSMutableArray()
            for answer in studentSheet._answerArray {
                
                _studentAnswer.addObject(answer.rawValue)
                
            }
            println("--------------")
            println(_studentAnswer.count)
            println("--------------")
            
            compareAnswer(_studentAnswer, withTeacherAnswer: _teacherAnswer)
            
            //See report MaskView
            mask = UIView(frame: UIScreen.mainScreen().bounds)
            mask.layer.opacity = 0.6
            mask.backgroundColor = .blackColor()
            showReportBtn = UIButton(frame: CGRectMake(110*deviceScale, 500*deviceScale, 159*deviceScale, 64*deviceScale))
            showReportBtn.setBackgroundImage(UIImage(named: "SeeReport.png"), forState: .Normal)
            showReportBtn.addTarget(self, action: "showReport", forControlEvents: UIControlEvents.TouchUpInside)
            
            
            UIApplication.sharedApplication().keyWindow?.addSubview(mask)
            UIApplication.sharedApplication().keyWindow?.addSubview(showReportBtn)
            println("dd")
            // FIXME: 还未处理两个Boolean值
            
            //Bmob Server Configurations
            
            var studentResponse = BmobObject(className: "StudentSheet_")
            var _answerArray = NSArray(array: _studentAnswer)
            studentResponse.setObject(_answerArray, forKey: "Answer")
            studentResponse.setObject(_objectID, forKey: "SheetID")
            studentResponse.setObject(BmobUser.getCurrentUser().username, forKey: "StudentName")
            studentResponse.setObject(_isRequireChoiceE, forKey: "isRequireChoiceE")
            studentResponse.saveInBackground()

        }
    }
    
    @IBAction func settingConfirmed() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.settingView.layer.opacity = 0
            self.settingView.transform = CGAffineTransformMakeTranslation(-375, 0)
            }, completion: nil)
        
        var currentUser = BmobUser.getCurrentUser()
        if settingPwField.text != "" {
            currentUser.setObject(settingPwField.text, forKey: "password")
        }
        currentUser.setObject(settingSchoolField.text, forKey: "School")
        var classes = settingClassField.text.componentsSeparatedByString("&")
        currentUser.setObject(classes, forKey: "Class")
        currentUser.updateInBackgroundWithResultBlock { (isSuccessful, error) -> Void in
            if isSuccessful == true {
                UIView.animateWithDuration(1.5, delay: 1
                    , usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                        
                        self.savedView.layer.opacity = 0.85
                        
                    }, completion: nil)
                
                UIView.animateWithDuration(1.5, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    
                    self.savedView.layer.opacity = 0
                    
                    }, completion: nil)
            }
        }
        
        self.navigationItem.title = "DashBoard"
        
        
    }

    
    @IBAction func settingCancelled() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.settingView.transform = CGAffineTransformMakeTranslation(-375*deviceScale, 0)
            self.settingView.layer.opacity = 0
            }, completion: nil)
        self.navigationItem.title = "DashBoard"
        
    }
    
    
    
    
    
    func sendNotification() {
        
        let push = BmobPush()
        let query = BmobQuery.queryForUser()
        push.setQuery(query)
        push.setMessage("New sheet sent by teacher!")
        push.sendPushInBackground()
        
    }
    
    func handleCellDisplay(answer: choiceType, cell: ChoiceCell) {
        var choiceButtons = [cell.choiceA,cell.choiceB, cell.choiceC, cell.choiceD]
        if answer != .NULL
            
        { choiceButtons[answer.rawValue-1].selected = true
            choiceButtons.removeAtIndex(answer.rawValue-1)}
        
        for button in choiceButtons {
            
            button.selected = false
        }
    }
    
    func handleExCellDisplay(answer: choiceType, cell: ExChoiceCell) {
        var choiceButtons = [cell.choiceA,cell.choiceB, cell.choiceC, cell.choiceD,cell.choiceE]
        if answer != .NULL
            
        { choiceButtons[answer.rawValue-1].selected = true
            choiceButtons.removeAtIndex(answer.rawValue-1)}
        
        for button in choiceButtons {
            
            button.selected = false
        }
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return reports.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! RecordCell
        
        let tap = UITapGestureRecognizer(target: self, action: "handleRecordSelection:")
        cell.imageView.userInteractionEnabled = true
        cell.imageView.addGestureRecognizer(tap)
        cell.overallCrtLabel.text = "\(reports[indexPath.row].overallAccuracy)"
        cell.sheetNameLabel.text = reports[indexPath.row].sheetName
        cell.imageView.tag = indexPath.row
        
        if cell.overallCrtLabel.text?.toInt() <= 60 {
            cell.overallCrtLabel.textColor = UIColor(red: 231/255, green: 41/255, blue: 77/255, alpha: 1)
        }else if cell.overallCrtLabel.text?.toInt() <= 70{
            cell.overallCrtLabel.textColor = UIColor(red: 235/255, green: 97/255, blue: 0, alpha: 1)
        }else if cell.overallCrtLabel.text?.toInt() <= 80 {
            cell.overallCrtLabel.textColor = UIColor(red: 74/255, green: 156/255, blue: 173/255, alpha: 1)
        }else {
            cell.overallCrtLabel.textColor = UIColor(red: 107/255, green: 204/255, blue: 152/255, alpha: 1)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(155*deviceScale, 165*deviceScale)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(35*deviceScale, 20*deviceScale, 5*deviceScale, 20*deviceScale)
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if self.numberOfRows != nil {
            return numberOfRows
        }else {
            return 5
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == answerView {
            var cell: ChoiceCell!
            if cell == nil{
                cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! ChoiceCell
            }
            
            cell.questionNo.text = String(indexPath.row+1)
            cell.superTableView = self.answerView
            
            // Configure the cell...
            
            
            cell.selectionStyle = .None
            if studentSheet != nil {
                for (index, answer) in enumerate(studentSheet._answerArray) {
                    
                    if cell.questionNo.text == String(index+1) {
                        
                        handleCellDisplay(answer, cell: cell)
                    }
                }
                
            }
            //   println(indexPath.row)
            return cell
        }else{
            var cell: ExChoiceCell!
            if cell == nil{
                cell = tableView.dequeueReusableCellWithIdentifier("exCell", forIndexPath: indexPath) as! ExChoiceCell
            }
            
            cell.questionNo.text = String(indexPath.row+1)
            cell.superTableView = self.exAnswerView
            
            // Configure the cell...
            
            cell.selectionStyle = .None
            if studentSheet != nil {
                for (index, answer) in enumerate(studentSheet._answerArray) {
                    
                    if cell.questionNo.text == String(index+1) {
                        
                        handleExCellDisplay(answer, cell: cell)
                    }
                }
                
            }
            //   println(indexPath.row)
            return cell
            
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65*deviceScale
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    
    
    
    @IBAction func backgroundTap() {
        
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .CurveEaseIn, animations: { () -> Void in
            // self.teacherSearchBar.transform = CGAffineTransformMakeTranslation(0, -44)
            }, completion: nil)
        
        //  teacherSearchBar.resignFirstResponder()
        
        
    }
    
    
    @IBAction func logOutUser() {
        BmobUser.logout()
    }
    
    func showReport() {
        mask.removeFromSuperview()
        showReportBtn.removeFromSuperview()
        performSegueWithIdentifier("showReport", sender: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showReport" {
            if let report = segue.destinationViewController as? ReportViewController {
                report.isFirstTimeOpen = true
                report.studentAnswerArray = _studentAnswer
                report.wrongAnswer = _wrongAnswer
                report.questionNumber = _questionNumber
                report.isRequireChoiceE = _isRequireChoiceE
                report.isAnswerVisible = _isAnswerVisible
                report.sheetName = tempSheetName
                println("KKK")
            }
            
        }
        if segue.identifier == "showRecord" {
            if let report = segue.destinationViewController as? ReportViewController {
                report.isFirstTimeOpen = false
                report.studentAnswerArray = tempStudentAnswerArray
                report.wrongAnswer = tempWrongAnswer
                report.questionNumber = tempQuestionNumber
                report.isRequireChoiceE = tempIsRequireE
                report.isAnswerVisible = tempIsAnswerVisible
                
            }
            
        }
        if segue.identifier == "showBadges" {
            if let report = segue.destinationViewController as? BadgesViewController {
                // FIXME: Do something to show user's correspondent badges & achievements
            }
            
        }
        
        
    }
    
    @IBAction func SettingBackGroundTap() {
        settingClassField.resignFirstResponder()
        settingPwField.resignFirstResponder()
        settingSchoolField.resignFirstResponder()
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        self.view.frame.origin.y = -150
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        self.view.frame.origin.y = 0
        
    }
    
}


