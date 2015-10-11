//
//  SheetNotificationView.swift
//  Sudo
//
//  Created by fong tinyik on 6/30/15.
//  Copyright (c) 2015 fong tinyik. All rights reserved.
//

import UIKit

class SheetNotificationView: UIView {

    @IBOutlet weak var sheetNameLabel: UILabel!
    
    @IBOutlet weak var teacherNameLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var questionNumberLabel: UILabel!

    
    class func initNotificationView() -> SheetNotificationView {
    
        let nibView = NSBundle.mainBundle().loadNibNamed("SheetNotificationView", owner: nil, options: nil) as NSArray
        
        return nibView.objectAtIndex(0) as! SheetNotificationView
    }
   
    class func initiPhone5NotificationView() -> SheetNotificationView {
        let nibView = NSBundle.mainBundle().loadNibNamed("kSheetNotificationView", owner: nil, options: nil) as NSArray
        
        return nibView.objectAtIndex(0) as! SheetNotificationView
    }
    
   }

