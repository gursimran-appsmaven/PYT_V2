//
//  ProfileVC.swift
//  PYT
//
//  Created by osx on 23/06/17.
//  Copyright © 2017 osx. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController,UITabBarDelegate,UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    private func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        footerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        return footerView
    }
    
    private func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 30
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
        

        
    }

}
class ProfileActionsCell: UITableViewCell {
    @IBOutlet weak var actionName: UILabel!
    @IBOutlet weak var actionImage: UIImageView!
    @IBOutlet weak var countLbl: CustomLabel!
}
