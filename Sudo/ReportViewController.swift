//
//  ReportViewController.swift
//  Sudo
//
//  Created by fong tinyik on 6/10/15.
//  Copyright (c) 2015 fong tinyik. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var reportSheet: UITableView!
    @IBOutlet weak var reportContainer: UIView!
    @IBOutlet weak var exReportSheet: UITableView!
    @IBOutlet weak var percentageLable: UILabel!
    
    
    var studentAnswerArray: NSMutableArray!
    var wrongAnswer: Dictionary<Int, Int>!
    var questionNumber: Int!
    var isFirstTimeOpen: Bool!
    var report: SheetReport!
    var sheetName: String!
    var isRequireChoiceE: Bool!
    var isAnswerVisible : Bool!
    
    
    
    override func viewDidLoad() {
        self.exReportSheet.addObserver(self, forKeyPath: "contentSize", options: nil, context: nil)
        self.reportSheet.addObserver(self, forKeyPath: "contentSize", options: nil, context: nil)
        super.viewDidLoad()
        if isRequireChoiceE == true {
            reportSheet.hidden = true
            exReportSheet.hidden = false
        }else {
            reportSheet.hidden = false
            exReportSheet.hidden = true
        }
        self.navigationItem.title = sheetName
        reportContainer.layer.cornerRadius = 5
        reportContainer.layer.shadowColor = UIColor.blackColor().CGColor
        reportContainer.layer.shadowOpacity = 0.2
        reportContainer.layer.shadowOffset = CGSizeMake(-0.5, 0.5)
        
        //  speedSheet.userInteractionEnabled = false
        reportSheet.userInteractionEnabled = false
        exReportSheet.userInteractionEnabled = false
        //  speedSheet.separatorStyle = .None
        reportSheet.separatorStyle = .None
        exReportSheet.separatorStyle = .None
        scroller.userInteractionEnabled = true
        scroller.contentSize = CGSizeMake(375, 1600)
        // speedSheet.layer.cornerRadius = 3
        // speedSheet.layer.opacity = 0.9
        
        let correctness = Int((1 - Double(wrongAnswer.count)/Double(questionNumber))*100)
        percentageLable.text = "\(correctness)"
        
        if isFirstTimeOpen == true {
            var currentUser = BmobUser.getCurrentUser()
            var exp = currentUser.objectForKey("Experience") as! Int
            exp += (questionNumber - wrongAnswer.count)*5
            currentUser.setObject(exp, forKey: "Experience")
            
            currentUser.updateInBackgroundWithResultBlock({ (isSuccessful, error) -> Void in
                if isSuccessful == true {
                    println(currentUser.objectForKey("Experience"))
                }
            })
            
            report = SheetReport(overallAccuracy: correctness, wrongAnswer: wrongAnswer, studentAnswerArray: studentAnswerArray, questionNumber: questionNumber, sheetName: sheetName, isRequireChoiceE: isRequireChoiceE,isAnswerVisible: isAnswerVisible)
            reports.append(report)
            
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let documentDir = paths[0] as! String
            let docPath = documentDir.stringByAppendingPathComponent("ReportRecords.plist")
            NSKeyedArchiver.archiveRootObject(reports, toFile: docPath)
            
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.exReportSheet.removeObserver(self, forKeyPath: "contentSize", context: nil)
        self.reportSheet.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        
        if object as! UITableView == exReportSheet {
            var frame = self.exReportSheet.frame
            frame.size = self.exReportSheet.contentSize
            self.exReportSheet.frame = frame
            exReportSheet.frame.origin = CGPointMake(0, 0)
            
            // self.reportContainer.frame = CGRectMake(self.reportContainer.frame.origin.x, self.reportContainer.frame.origin.y, self.reportContainer.frame.width, frame.height)
            if isiPhone6 == true {
                
                var size = scroller.contentSize
                size.height =  CGFloat(400*2 + studentAnswerArray.count*65+83)
                scroller.contentSize = size
                reportContainer.frame = CGRectMake(reportContainer.frame.origin.x, reportContainer.frame.origin.y, reportContainer.frame.width, CGFloat(studentAnswerArray.count*65+83))
                
            }else {
                
                var size = scroller.contentSize
                size.height =  CGFloat(450*2 + studentAnswerArray.count*55+83)
                scroller.contentSize = size
                reportContainer.frame = CGRectMake(reportContainer.frame.origin.x, reportContainer.frame.origin.y, reportContainer.frame.width, CGFloat(studentAnswerArray.count*55+83))
                
            }
        }
        
        if object as! UITableView == reportSheet {
            var frame = self.reportSheet.frame
            frame.size = self.reportSheet.contentSize
            self.reportSheet.frame = frame
            reportSheet.frame.origin = CGPointMake(0, 0)
            
            // self.reportContainer.frame = CGRectMake(self.reportContainer.frame.origin.x, self.reportContainer.frame.origin.y, self.reportContainer.frame.width, frame.height)
            
            var size = scroller.contentSize
            if isiPhone6 == true {
                size.height =  CGFloat(400*2 + studentAnswerArray.count*65+83)
                scroller.contentSize = size
                reportContainer.frame = CGRectMake(reportContainer.frame.origin.x,
                    reportContainer.frame.origin.y, reportContainer.frame.width, CGFloat(studentAnswerArray.count*65+83))
            }else {
                size.height =  CGFloat(450*2 + studentAnswerArray.count*55+83)
                scroller.contentSize = size
                reportContainer.frame = CGRectMake(reportContainer.frame.origin.x, reportContainer.frame.origin.y, reportContainer.frame.width, CGFloat(studentAnswerArray.count*55+83))
                
            }
            
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentAnswerArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65*deviceScale
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == reportSheet {
            var cell: ChoiceCell!
            if cell == nil{
                cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! ChoiceCell
            }
            cell.wrongMarker.hidden = true
            cell.questionNo.text = String(indexPath.row+1)
            cell.superTableView = self.reportSheet
            cell.selectionStyle = .None
            switch studentAnswerArray[indexPath.row] as! Int {
            case 1: cell.choiceA.selected = true
            case 2: cell.choiceB.selected = true
            case 3: cell.choiceC.selected = true
            case 4: cell.choiceD.selected = true
            default: break
            }
            
            if isAnswerVisible == true {
                for (key, value) in wrongAnswer {
                    
                    if indexPath.row == key {
                        switch value {
                        case 1: cell.choiceA.highlighted = true
                        case 2: cell.choiceB.highlighted = true
                        case 3: cell.choiceC.highlighted = true
                        case 4: cell.choiceD.highlighted = true
                        default: break
                        }
                        cell.wrongMarker.hidden = false
                    }
                    
                }
            }else {
                for (key, value) in wrongAnswer {
                    if indexPath.row == key {
                        cell.wrongMarker.hidden = false
                    }
                }
            }
            
            return cell
        }else {
            
            var cell: ExChoiceCell!
            if cell == nil{
                cell = tableView.dequeueReusableCellWithIdentifier("exReportCell", forIndexPath: indexPath) as! ExChoiceCell
            }
            
            cell.wrongMarker.hidden = true
            cell.questionNo.text = String(indexPath.row+1)
            cell.superTableView = self.exReportSheet
            cell.selectionStyle = .None
            switch studentAnswerArray[indexPath.row] as! Int {
            case 1: cell.choiceA.selected = true
            case 2: cell.choiceB.selected = true
            case 3: cell.choiceC.selected = true
            case 4: cell.choiceD.selected = true
            case 5: cell.choiceE.selected = true
            default: break
                
            }
            // cell.wrongMarker.hidden = true
            if isAnswerVisible == true {
                for (key, value) in wrongAnswer {
                    
                    if indexPath.row == key {
                        switch value {
                        case 1: cell.choiceA.highlighted = true
                        case 2: cell.choiceB.highlighted = true
                        case 3: cell.choiceC.highlighted = true
                        case 4: cell.choiceD.highlighted = true
                        case 5: cell.choiceE.highlighted = true
                        default: break
                        }
                        cell.wrongMarker.hidden = false
                    }
                }
            }else {
                for (key, value) in wrongAnswer {
                    if indexPath.row == key {
                        cell.wrongMarker.hidden = false
                    }
                }
            }
            
            
            return cell
        }
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
    
    
}