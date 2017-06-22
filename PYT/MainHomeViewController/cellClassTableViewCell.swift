//
//  cellClassTableViewCell.swift
//  PYT
//
//  Created by Niteesh on 06/07/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit

class cellClassTableViewCell: UITableViewCell{
    
//}UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet var ChatButton: UIButton!
    @IBOutlet var userProfilePic: UIImageView!
    
    //@IBOutlet var imagesCollectionView: UICollectionView!
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    
    
    @IBOutlet weak var userProfileButton: UIButton!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var useraddressLabel: UILabel!
    @IBOutlet weak var arrowBackButton: UIButton!
    
   
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
              
//        ChatButton.layer.cornerRadius = 10.0
//        ChatButton.clipsToBounds = true
        
        userProfilePic.layer.cornerRadius = userProfilePic.frame.size.width/2
        userProfilePic.clipsToBounds=true
        imagesCollectionView.clipsToBounds=true
      
        
    }
    
    

    
    
    

//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

    
    // MARK: UICollectionViewDataSource
    

    
    var collectionViewOffset: CGFloat {
        get {
            return imagesCollectionView.contentOffset.x
        }
        
        set {
            imagesCollectionView.contentOffset.x = newValue
        }
    }
    
    
    
    /*
    func setCollectionViewDataSourceDelegate<D: (UICollectionViewDataSource & UICollectionViewDelegate)>
        (_ dataSourceDelegate: D, forRow row: Int , andForSection section : Int) {
        
        
        //let queue = NSOperationQueue()
        
       // let op1 = NSBlockOperation { () -> Void in
            
            // dispatch_async(dispatch_get_main_queue(), {
            
            self.imagesCollectionView.delegate = dataSourceDelegate
            self.imagesCollectionView.dataSource = dataSourceDelegate
            self.imagesCollectionView.tag = row // tableView indexpathrow equals cell tag
        
        
        self.imagesCollectionView.collectionViewLayout.invalidateLayout()
        
        
        OperationQueue.main.addOperation({ () -> Void in

                
      
      // self.imagesCollectionView.setContentOffset(CGPointZero, animated: true)
            
        
            //dispatch_async(dispatch_get_main_queue(), {
          self.imagesCollectionView.reloadData()
        //})
       
            
        })
        
           
      //  }
        
         //queue.addOperation(op1)
        
    }
        
    
    */
}

// locations on feed cell
class collectionViewCellClassFeed: UICollectionViewCell {
    
    @IBOutlet weak var likeView: UIView!
    
    @IBOutlet weak var geoTagLbl: UILabel!
    @IBOutlet weak var catglbl: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var selectView: UIImageView!
    @IBOutlet weak var likeimg: UIImageView!
    @IBOutlet weak var likecountlbl: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var planButton: UIButton!
    @IBOutlet weak var overlay: GradientView!
    
}


//plan cell
class planCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var planImage: CustomImageView!
    @IBOutlet weak var planName: UILabel!
   
    
}

//plan header cell
class planCollectionViewHeaderCell: UICollectionViewCell {
    @IBOutlet weak var changePlanButton: UIButton!
    
}
class storyTableHeaderCell: UITableViewCell{
    
    //}UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var storiesCollectionView: UICollectionView!
    
}


