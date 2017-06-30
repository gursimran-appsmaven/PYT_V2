//
//  ProfileVC.swift
//  PYT
//
//  Created by osx on 23/06/17.
//  Copyright © 2017 osx. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate, settingClassDelegate {
    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!

    @IBOutlet weak var view1Height: NSLayoutConstraint!
    @IBOutlet weak var view2Height: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var outerImg: CustomImageView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var catCollectionView: UICollectionView!
    @IBOutlet weak var actionsTableView: UITableView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var nameTxtWidth: NSLayoutConstraint!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        SettingApiClass.sharedInstance().delegate=self //delegate of api class
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews()
    {
        outerImg.layer.cornerRadius = outerImg.frame.width/2
        userImg.layer.cornerRadius = userImg.frame.width/2
        outerImg.layer.masksToBounds = true
        userImg.layer.masksToBounds = true
        
        view1Height.constant = view.frame.width * 13/25
      
        view2Height.constant = view.frame.width * 13/25 //+ catCollectionView.frame.width/2
        
        tableViewHeight.constant = CGFloat(11*55 + 20*4 + 10)/*sections*/
        contentViewHeight.constant = view1Height.constant + view2Height.constant + tableViewHeight.constant
    }
    //MARK: DataSource and delegate of tableView
    //MARK:-
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        switch section {
        case 0:
            return 2

        case 1:
            return 5
            
        case 2:
            return 3

        case 3:
            return 1

        default:
            return 0
            
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 55
        
    }
    
    func tableView( _ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        footerView.backgroundColor = UIColor(red: 208/255.0 , green: 208/255.0 , blue: 208/255.0 , alpha: 0.36)
        return footerView

    }
    func tableView( _ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        if(section==3)
        {
            return 30
        }
        return 20

    }
    func tableView( _ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0.1
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileActionsCell", for: indexPath) as! ProfileActionsCell
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.actionName.text = "Saved Destinations"

            case 1:
                cell.actionName.text = "Travel Plan"
                
            default:
                cell.actionName.text = ""
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.actionName.text = "View Tutorial"

            case 1:
                cell.actionName.text = "Share Application"

            case 2:
                cell.actionName.text = "Add More Account"

            case 3:
                cell.actionName.text = "Choose Interest"

            case 4:
                cell.actionName.text = "Change Password"

            default:
                cell.actionName.text = ""

            }
            

        case 2:
            switch indexPath.row {
            case 0:
                cell.actionName.text = "Report a problem"

            case 1:
                cell.actionName.text = "Help"

            case 2:
                cell.actionName.text = "Privacy Policy"

            default:
                cell.actionName.text = ""

            }
            

        case 3:
            switch indexPath.row {
            case 0:
                cell.actionName.text = "Logout"
            default:
                cell.actionName.text = ""

            }
        default:
            return cell
            
        }
        
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                print("Saved Destinations")
                
            case 1:
                print("Travel Plan")
                
            default:
                print(" ")

            }
        case 1:
            switch indexPath.row {
            case 0:
                print("View Tutorial")
                
            case 1:
                print("Share Application")
                
            case 2:
                print("Add More Account")
                
            case 3:
                print("Choose Interest")
                
            case 4:
                print("Change Password")
                
            default:
                print(" ")
                
            }
            
            
        case 2:
            switch indexPath.row {
            case 0:
                print("Report a problem")
                
            case 1:
                print("Help")
                
            case 2:
                print("Privacy Policy")
                
            default:
                print(" ")
                
            }
            
            
        case 3:
            switch indexPath.row {
            case 0:
                print("Logout")

            default:
                print(" ")

                
            }
        default:
            print("")

            
        }

        
    }
    
     // MARK: UICollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int   {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int
    {
        
        return 3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        
        let width1 = collectionView.frame.size.width/2  - 5
        
        return CGSize(width: width1 , height: width1) // The size of one cell
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionCell", for: indexPath) as! ProfileCollectionCell
        
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
            
        
        
    }

    
    //MARK: Text Field Delegates
    
    func getWidth(text: String) -> CGFloat
    {
        let txtField = UITextField(frame: .zero)
        txtField.text = text
        txtField.sizeToFit()
        if(txtField.frame.size.width > 72)
        {
            return txtField.frame.size.width
        }
        return 72
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let width = getWidth(text: textField.text!)
        if UIScreen.main.bounds.width - 70 > width
        {
            nameTxtWidth.constant = 0.0
            if width > nameTxtWidth.constant
            {
                nameTxtWidth.constant = width
            }
            self.view.layoutIfNeeded()
        }
        return true
    }
    
    
    
    
    
    
    
    
    
    
    
    
    

}
class ProfileActionsCell: UITableViewCell {
    @IBOutlet weak var actionName: UILabel!
    @IBOutlet weak var actionImage: UIImageView!
    @IBOutlet weak var countLbl: CustomLabel!
}
class ProfileCollectionCell: UICollectionViewCell {
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var countLbl: CustomLabel!
    
//    override func layoutSubviews() {
//        countLbl.layer.cornerRadius = 10.0
//        countLbl.layer.masksToBounds = true
//    }

}

