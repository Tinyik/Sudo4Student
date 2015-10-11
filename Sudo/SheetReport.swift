//
//  SheetReport.swift
//  Sudo
//
//  Created by fong tinyik on 7/6/15.
//  Copyright (c) 2015 fong tinyik. All rights reserved.
//

import UIKit

class SheetReport: NSObject, NSCoding {
    
    var overallAccuracy: Int!
    var studentAnswerArray: NSMutableArray!
    var wrongAnswer: Dictionary<Int, Int>!
    var questionNumber: Int!
    var sheetName: String!
    var isRequireChoiceE: Bool!
    var isAnswerVisible: Bool!
    
    init(overallAccuracy: Int, wrongAnswer: Dictionary<Int, Int>, studentAnswerArray: NSMutableArray, questionNumber: Int, sheetName: String, isRequireChoiceE: Bool, isAnswerVisible: Bool) {
        super.init()
        self.overallAccuracy = overallAccuracy
        self.wrongAnswer = wrongAnswer
        self.studentAnswerArray = studentAnswerArray
        self.questionNumber = questionNumber
        self.sheetName = sheetName
        self.isRequireChoiceE = isRequireChoiceE
        self.isAnswerVisible = isAnswerVisible
        
       
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.overallAccuracy, forKey: "overallAccuracy")
        aCoder.encodeObject(self.wrongAnswer, forKey: "wrongAnswer")
        aCoder.encodeObject(self.studentAnswerArray, forKey: "studentAnswerArray")
        aCoder.encodeObject(self.questionNumber, forKey: "questionNumber")
        aCoder.encodeObject(self.sheetName, forKey: "sheetName")
        aCoder.encodeObject(self.isRequireChoiceE, forKey: "isRequireChoiceE")
        aCoder.encodeObject(self.isAnswerVisible, forKey: "isAnswerVisible")
        
    }
    
    required init(coder aDecoder: NSCoder) {
       
        self.overallAccuracy = aDecoder.decodeObjectForKey("overallAccuracy") as! Int
        self.wrongAnswer = aDecoder.decodeObjectForKey("wrongAnswer") as! Dictionary<Int, Int>
        self.studentAnswerArray = aDecoder.decodeObjectForKey("studentAnswerArray") as! NSMutableArray
        self.questionNumber = aDecoder.decodeObjectForKey("questionNumber") as! Int
        self.sheetName = aDecoder.decodeObjectForKey("sheetName") as! String
//        self.isRequireChoiceE = aDecoder.decodeBoolForKey("isRequireChoiceE") as Bool
//        self.isAnswerVisible = aDecoder.decodeBoolForKey("isAnswerVisible") as Bool
        self.isRequireChoiceE = aDecoder.decodeObjectForKey("isRequireChoiceE") as! Bool
        self.isAnswerVisible = aDecoder.decodeObjectForKey("isAnswerVisible") as! Bool
       
        
    }
    
    override init() {
        
    }
    
    
    
    
}
