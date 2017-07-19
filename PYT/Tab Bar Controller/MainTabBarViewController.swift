//
//  MainTabBarViewController.swift
//  PYT
//
//  Created by Niteesh on 08/11/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
var againTapPost = Bool()
class MainTabBarViewController: UITabBarController {

       var againTap = Bool()
    
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.frame.size = self.tabBar.sizeThatFits(self.tabBar.frame.size)
        
        self.tabBar.setValue(true, forKey: "_hidesShadow") //hide the line in tabbar
       
               // Do any additional setup after loading the view.
    }
    
    
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        print("the selected index is : \(tabBar.items?.index(of: item))")
        
        let tabBarIndex = tabBar.items?.index(of: item)
        
        
        
        if tabBarIndex == 0 {
            
            againTapPost = false
            if againTap == false {
                againTap = true
            }
            else
            {
                
                againTap = true
                
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshToTop"), object: nil)
                
              
            }
            
            
        }
        else if tabBarIndex == 2{
            
            againTap = false
            if againTapPost == false {
                againTapPost = true
            }
            else
            {
            againTapPost = true
               NotificationCenter.default.post(name: Notification.Name(rawValue: "uploadingStart"), object: nil)
                
            }
            
            
            
        }
        else
        {
            againTap = false
            againTapPost = false
        }
        
    }
    
    
    
    
    
    
    
    
    
    func tabBarController(_ aTabBar: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
//        if !self.hasValidLogin() && (viewController != aTabBar.viewControllers[0]) {
//            // Disable all but the first tab.
//            return false
//        }
           print("---------------Its comes here------------------")
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
        URLCache.shared.removeAllCachedResponses()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UITabBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 42
        return sizeThatFits
    }
}


extension UITabBarController {
    
    func setTabBarVisible(visible:Bool, animated:Bool) {
        
        // bail if the current state matches the desired state
        if (tabBarIsVisible() == visible) { return }
        
        if visible == true {
        self.tabBar.isHidden = false
        }
        else
        {
        self.tabBar.isHidden = true
        }
        
        // get a frame calculation ready
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = (visible ? -height : height)
        
        // animate the tabBar
        UIView.animate(withDuration: animated ? 0.3 : 0.0) {
            self.tabBar.frame = frame.offsetBy(dx: 0, dy: offsetY)
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width , height: self.view.frame.height + offsetY)
            //CGRectMake(0, 0, self.view.frame.width, self.view.frame.height + offsetY)
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    
    
    
    
    func tabBarIsVisible() ->Bool {
        return self.tabBar.frame.origin.y < self.view.frame.maxY
    }
}



