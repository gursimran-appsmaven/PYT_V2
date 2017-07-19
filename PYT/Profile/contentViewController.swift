//
//  contentViewController.swift
//  PYT
//
//  Created by osx on 06/07/17.
//  Copyright © 2017 osx. All rights reserved.
//

import UIKit

class contentViewController: UIViewController, UIScrollViewDelegate {

    var comingFrom = NSString()//differentiate different screens to show
    
    //tutorials
    let whiteView = UIView()
    let scrollView2 = UIScrollView() //(frame: CGRect(x:0, y:0, width:320,height: 300))
    var images = ["tutorial1", "tutorial2", "tutorial3"]
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    var pageControl = UIPageControl()
    var skipBtn = UIButton()
    var doneToturials = UIButton()
    
    override func viewWillAppear(_ animated: Bool) {
       self.tabBarController?.tabBar.isHidden = true
        //self.tabBarController?.setTabBarVisible(visible: false, animated: true)

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if comingFrom == "Tutorials" {
            self.startTutorials()
        }

    }

    
    //MARK: Tutorials start here
    func startTutorials()
    {
            self.whiteView.isHidden = false
            self.whiteView.frame = CGRect(x:0, y:0, width:self.view.frame.size.width,height: self.view.frame.size.height)
            self.whiteView.backgroundColor = UIColor .white
            self.view.addSubview(whiteView)
            
            scrollView2.frame = CGRect(x:0, y:0, width:self.view.frame.width,height: self.view.frame.size.height)
            scrollView2.showsHorizontalScrollIndicator = false
            pageControl.frame = CGRect(x:self.view.frame.width/2 - 50,y: self.view.frame.height - 50, width:100, height:50)
            
            configurePageControl()
            
            scrollView2.delegate = self
            self.whiteView.addSubview(scrollView2)
            
            
            doneToturials.backgroundColor = UIColor.init(colorLiteralRed: 0/255, green: 44/255, blue: 63/255, alpha: 0)
            doneToturials.setTitle("  Done  ", for: .normal)
            doneToturials.titleLabel?.font = UIFont(name:"SFUIDisplay-Bold", size: 20)
            doneToturials.setTitleColor(UIColor (colorLiteralRed: 255.0/255.0, green: 80.0/255.0, blue: 80.0/255.0, alpha: 1), for: .normal)
            
            
            
            for index in 0..<3
            {
                frame.origin.x = self.scrollView2.frame.size.width * CGFloat(index)
                frame.size = self.scrollView2.frame.size
                scrollView2.isPagingEnabled = true
                
                
                let imageView2 = UIImageView(frame: frame)
                imageView2.contentMode = .scaleAspectFill
                imageView2.image = UIImage(named: String(images[index]))
                
                let labeltxt = UILabel()
                labeltxt.backgroundColor = UIColor .clear
                
                let Y_Co = (self.view.frame.size.height/2 + 40)
                
                labeltxt.frame = CGRect(x: frame.origin.x + (frame.size.width/2 - (frame.size.width/2 - 25)), y: Y_Co, width: frame.size.width - 50, height: 180)
                labeltxt.textAlignment = .center
                labeltxt.font = UIFont(name:"Roboto-Regular", size: 12)
                labeltxt.numberOfLines = 0
                labeltxt.textColor = UIColor .darkGray
                labeltxt.alpha = 0.8
                if index == 0{
                    labeltxt.text = ""//"Be a part of community where you can see, like, share, and comment on the travel pictures of your friends and family."
                }
                else if(index == 1)
                {
                    labeltxt.text = ""//"Discover a place in depth with reviews and nearby places. Add them to your bucketlist to carry them in your pocket as part of your travel plan. Book flights, hotels, tours, and more from one place."
                }
                else{
                    labeltxt.text = ""//"Upload and share your travel memories with your friends and family. Geo-tag your photos and become a travel guide."
                }
                
                self.scrollView2 .addSubview(imageView2)
                self.scrollView2 .addSubview(labeltxt)
                
                
                
                
                if index == 2
                {
                    
                    // imageView2 .addSubview(doneToturials)
                    self.scrollView2 .addSubview(doneToturials)
                    
                    doneToturials.frame = CGRect(x:imageView2.frame.width/2 - 125 + imageView2.frame.origin.x ,y: self.view.frame.height - 90, width:250, height:42)
                    print(doneToturials.frame)
                    
                    
                    
                }
                
                
                
                
            }
            
            self.scrollView2.contentSize = CGSize(width:self.scrollView2.frame.size.width * 3,height: self.scrollView2.frame.size.height)
            pageControl.addTarget(self, action: #selector(changePage(_sender:)), for: .valueChanged)
            
            pageControl.currentPageIndicatorTintColor = UIColor.init(colorLiteralRed: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            pageControl.pageIndicatorTintColor = UIColor.init(colorLiteralRed: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
            pageControl.layer.borderColor = UIColor.white.cgColor
            pageControl.layer.borderWidth = 0.0
            pageControl.layer.masksToBounds = false
            
            self.whiteView .bringSubview(toFront: pageControl)
            
            skipBtn.frame = CGRect(x:self.view.frame.size.width - 150 ,y: self.view.frame.height - 80, width:150, height:30)
            skipBtn.setTitle("SKIP TIPS", for: .normal)
            skipBtn.titleLabel?.font = UIFont(name:"Roboto-Medium", size: 14)
            skipBtn.setTitleColor(UIColor.init(colorLiteralRed: 104/255, green: 173/255, blue: 120/255, alpha: 1), for: .normal)
            //            self.whiteView .addSubview(skipBtn)
            skipBtn .addTarget(self, action: #selector(self.skipBtnAction), for: .touchUpInside )
            
            doneToturials.layer.cornerRadius = doneToturials.frame.size.height/2
            doneToturials.layer.borderColor=UIColor (colorLiteralRed: 255.0/255.0, green: 80.0/255.0, blue: 80.0/255.0, alpha: 1).cgColor
            doneToturials.layer.borderWidth=0
            doneToturials .addTarget(self, action: #selector(self.skipBtnAction), for: .touchUpInside)
            doneToturials.clipsToBounds = true
            
        
        
    }
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = images.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.green
        self.whiteView.addSubview(pageControl)
        
    }
    
    func changePage(_sender:Any) -> ()
        
        //func changePage(sender: AnyObject) -> ()
    {
        let x = CGFloat(pageControl.currentPage) * scrollView2.frame.size.width
        scrollView2.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        if pageNumber == 2
        {
            skipBtn.isHidden = true
        }
        else
        {
            skipBtn.isHidden = false
        }
    }
    
    func skipBtnAction()
    {
//        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {() -> Void in
//            
//            self.whiteView.frame = CGRect(x: -(self.whiteView.frame.size.width), y: 0, width: self.whiteView.bounds.width, height: self.whiteView.frame.size.height)
//            
//            
//        }, completion: {(finished: Bool) -> Void in
//            self.whiteView.removeFromSuperview()
//            
//            Udefaults.set(true, forKey: "tutorialLaunch")//uncomment this
//            
//            // self.viewDidLoad() //uncomment this
//        })

       self.backBtnAction(self)
        
    }
    
/////End of Tutorials here ---//////
    
    
    
    
    
    
    
    
    //MARK: Button Actions
    
    @IBAction func backBtnAction(_ sender: Any)
    {
     self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
