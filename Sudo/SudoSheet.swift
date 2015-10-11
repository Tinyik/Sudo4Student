//
//  sudoSheet.swift
//  Sudo
//
//  Created by fong tinyik on 6/12/15.
//  Copyright (c) 2015 fong tinyik. All rights reserved.
//

import UIKit

enum choiceType: Int {
    case A = 1
    case B
    case C
    case D
    case E
    case AB
    case AC
    case AD
    case BD
    case CD
    case BC
    case ABC
    case ABD
    case ACD
    case BCD
    case ABCD
    case NULL 
}

enum SudoUserLevelThreshold: Int {
    case Zero = 5
    case One = 20
    case Two = 50
    case Three = 100
    case Four = 200
    case Five = 400
    case Six = 800
    case Seven = 1500
    case Eight = 2500
    case Nine = 4000
    case Ten = 6000

    static let allValues = [5, 20, 50, 100, 200, 400, 800, 1500, 2500, 4000, 6000]
    
    
}

class SudoSheet: NSObject {
    
    var _answerArray=[choiceType]()
    var _sheetName: String!
    var _questionNo: Int!
 //   var _isRequireReport: Bool!
    var _isAnswerVisible: Bool!
    var _isRequireChoiceE: Bool!
    
    init(sheetName:String, questionNo:Int, isAnswerVisible:Bool, isRequireChoiceE: Bool ){
        
          _sheetName = sheetName
          _questionNo = questionNo
      //    _isRequireReport = isRequireReport
          _isAnswerVisible = isAnswerVisible
         _isRequireChoiceE = isRequireChoiceE
        
        for var i = 0; i < questionNo;  ++i{
            _answerArray.append(.NULL)
        }
        
    }
    
    func saveSheet() {
        
    }
    
    func sendSheet() {
        
    }
   
}
