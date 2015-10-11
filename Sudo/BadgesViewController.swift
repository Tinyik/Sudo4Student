//
//  BadgesViewController.swift
//  Sudo
//
//  Created by fong tinyik on 7/8/15.
//  Copyright (c) 2015 fong tinyik. All rights reserved.
//

import UIKit

class BadgesViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var warningLabel: UILabel!
    var imageArray: [String]!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Badges"
         imageArray = ["Badge_Newbie", "Badge_Explorer", "Badge_Adventrurer","Badge_Debugger"]
        
        let mask = UIView(frame: UIScreen.mainScreen().bounds)
        mask.backgroundColor = .blackColor()
        mask.layer.opacity = 0.7
        self.view.addSubview(mask)
        self.view.bringSubviewToFront(warningLabel)
        
    }
    
     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println(imageArray.count)
        return imageArray.count
    }
    
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("BadgeCell", forIndexPath: indexPath) as! BadgeCell
        
        cell.badgeImage.image = UIImage(named: imageArray[indexPath.row])
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(155*deviceScale, 175*deviceScale)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
         return UIEdgeInsetsMake(35*deviceScale, 20*deviceScale, 5*deviceScale, 20*deviceScale)
        
    }


}
