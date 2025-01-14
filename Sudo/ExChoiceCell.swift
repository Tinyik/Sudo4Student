//
//  ExChoiceCell.swift
//  Sudo
//
//  Created by fong tinyik on 7/9/15.
//  Copyright (c) 2015 fong tinyik. All rights reserved.
//

import UIKit

class ExChoiceCell: UITableViewCell {
    weak var superTableView: UITableView!
    @IBOutlet weak var questionNo: UILabel!
    @IBOutlet weak var choiceA: UIButton!
    @IBOutlet weak var choiceB: UIButton!
    @IBOutlet weak var choiceC: UIButton!
    @IBOutlet weak var choiceD: UIButton!
    @IBOutlet weak var choiceE: UIButton!
    @IBOutlet weak var wrongMarker: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // wrongMarker.hidden = true
        choiceA.setBackgroundImage(UIImage(named: "Sudo-Choices_0001_Selected"), forState: UIControlState.Selected)
        choiceB.setBackgroundImage(UIImage(named: "Sudo-Choices_0001_Selected"), forState: UIControlState.Selected)
        choiceC.setBackgroundImage(UIImage(named: "Sudo-Choices_0001_Selected"), forState: UIControlState.Selected)
        choiceD.setBackgroundImage(UIImage(named: "Sudo-Choices_0001_Selected"), forState: UIControlState.Selected)
        choiceE.setBackgroundImage(UIImage(named: "Sudo-Choices_0001_Selected"), forState: UIControlState.Selected)
        
        
        choiceA.setBackgroundImage(UIImage(named: "Report_0000_Correction"), forState: UIControlState.Highlighted)
        choiceB.setBackgroundImage(UIImage(named: "Report_0000_Correction"), forState: UIControlState.Highlighted)
        choiceC.setBackgroundImage(UIImage(named: "Report_0000_Correction"), forState: UIControlState.Highlighted)
        choiceD.setBackgroundImage(UIImage(named: "Report_0000_Correction"), forState: UIControlState.Highlighted)
        choiceE.setBackgroundImage(UIImage(named: "Report_0000_Correction"), forState: UIControlState.Highlighted)
       

        choiceA.addTarget(self, action: "recordChoiceA:", forControlEvents: UIControlEvents.TouchUpInside)
        choiceB.addTarget(self, action: "recordChoiceB:", forControlEvents: UIControlEvents.TouchUpInside)
        choiceC.addTarget(self, action: "recordChoiceC:", forControlEvents: UIControlEvents.TouchUpInside)
        choiceD.addTarget(self, action: "recordChoiceD:", forControlEvents: UIControlEvents.TouchUpInside)
        choiceE.addTarget(self, action: "recordChoiceE:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
    }
    
    
    func recordChoiceA(sender: UIButton) {
        //println(sender.tag)
        println("RCA")
        choiceA.selected = !choiceA.selected
        let no = self.questionNo.text?.toInt()
        studentSheet._answerArray[no!-1] = .A
        
    }
    func recordChoiceB(sender: UIButton) {
        // println(sender.tag)
        choiceB.selected = !choiceB.selected
        let no = self.questionNo.text?.toInt()
        studentSheet._answerArray[no!-1] = .B
        
    }
    func recordChoiceC(sender: UIButton) {
        // println(sender.tag)
        choiceC.selected = !choiceC.selected
        let no = self.questionNo.text?.toInt()
        studentSheet._answerArray[no!-1] = .C
        
    }
    func recordChoiceD(sender: UIButton) {
        //  println(sender.tag)
        choiceD.selected = !choiceD.selected
        let no = self.questionNo.text?.toInt()
        studentSheet._answerArray[no!-1] = .D
        
        
    }
    func recordChoiceE(sender: UIButton) {
        println("RCE")
        //  println(sender.tag)
        choiceE.selected = !choiceE.selected
        let no = self.questionNo.text?.toInt()
        studentSheet._answerArray[no!-1] = .E
        
        
    }
    
    @IBAction func handleSelection(sender: UIButton) {
        self.superTableView.reloadData()
        println("reload")
        for answer in studentSheet._answerArray {
            println(answer.rawValue)
        }
    }

}
