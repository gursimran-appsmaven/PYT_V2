//
//  cellClassTableViewCell.swift
//  PYT
//
//  Created by Niteesh on 06/07/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

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
    
    //Interest
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var fullLocationLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var planButton: UIButton!
    @IBOutlet weak var likeCountLbl: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var gradientView: GradientView!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
              
//        ChatButton.layer.cornerRadius = 10.0
//        ChatButton.clipsToBounds = true
        

//        imagesCollectionView.clipsToBounds=true
      
        
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

class VideoCellFeedClass: UICollectionViewCell {
    
    // I have put the avplayer layer on this view
    @IBOutlet weak var videoPlayerSuperView: UIView!
    var avPlayer: AVPlayer?
    var avPlayerLayer: AVPlayerLayer?
    var paused: Bool = false
    
    @IBOutlet weak var likeimg: UIImageView!
    @IBOutlet weak var likecountlbl: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var planButton: UIButton!
    @IBOutlet weak var geoTagLbl: UILabel!

    
    //This will be called everytime a new value is set on the videoplayer item
    var videoPlayerItem: AVPlayerItem? = nil {
        didSet {
            /*
             If needed, configure player item here before associating it with a player.
             (example: adding outputs, setting text style rules, selecting media options)
             */
            avPlayer?.replaceCurrentItem(with: self.videoPlayerItem)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Setup you avplayer while the cell is created
        self.setupMoviePlayer()
    }
    
    func setupMoviePlayer(){
        self.avPlayer = AVPlayer.init(playerItem: self.videoPlayerItem)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        avPlayer?.volume = 3
        avPlayer?.actionAtItemEnd = .none
        
//                You need to have different variations
//                according to the device so as the avplayer fits well
//        if UIScreen.main.bounds.width == 375 {
            let widthRequired = screenBounds.width - 4
//            avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: widthRequired, height: widthRequired/1.78)
//        }else if UIScreen.main.bounds.width == 320 {
//            avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: (self.frame.size.height - 120) * 1.78, height: self.frame.size.height - 120)
//        }else{
//            let widthRequired = self.frame.size.width
//            avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: widthRequired, height: widthRequired/1.78)
//        }
        
        
        self.avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: widthRequired/1.25, height: widthRequired/1.25*0.73)
        self.videoPlayerSuperView.layer.insertSublayer(self.avPlayerLayer!, at: 0)

        
        // This notification is fired when the video ends, you can handle it in the method.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.playerItemDidReachEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer?.currentItem)
    }
    
    func stopPlayback(){
        self.avPlayer?.pause()
    }
    
    func startPlayback(){
        self.avPlayer?.play()
    }
    
    // A notification is fired and seeker is sent to the beginning to loop the video again
    func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: kCMTimeZero)
    }
}

//plan cell
class planCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var planImage: CustomImageView!
    @IBOutlet weak var planName: UILabel!
    @IBOutlet weak var deletplanButton: UIButton!
    
}

//plan header cell
class planCollectionViewHeaderCell: UICollectionViewCell {
    
}
class storyTableHeaderCell: UITableViewCell
{
    //}UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var storiesCollectionView: UICollectionView!
    
}


