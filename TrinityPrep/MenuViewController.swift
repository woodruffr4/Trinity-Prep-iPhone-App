//
//  MenuViewController.swift
//  TrinityPrep
//
//  Created by Ricky Woodruff on 1/23/17.
//  Copyright © 2017 Ricky Woodruff. All rights reserved.
//

import UIKit

var on="Home"

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

var buffer: CGFloat = 44

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /**
     *  Array to display menu options
     */
    @IBOutlet var tblMenuOptions : UITableView!
    
    /**
     *  Transparent button to hide menu
     */
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    /**
     *  Array containing menu options
     */
    var arrayMenuOptions = [Dictionary<String,String>]()
    
    /**
     *  Menu button which was tapped to display the menu
     */
    var btnMenu : UIButton!
    
    /**
     *  Delegate of the MenuVC
     */
    var delegate : SlideMenuDelegate?
    
    @IBOutlet var createdAndDesigned: UIView!
    
    func closeMenu() {
        if (self.delegate != nil) {
            let index = Int32(btnMenu.tag)
            print(btnMenu.tag)
            
            /*if(button == self.btnCloseMenuOverlay){
             index = -1
             }*/
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0-buffer, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height+buffer)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
            self.view.superview?.window?.windowLevel=UIWindowLevelStatusBar-1
            self.view.superview?.alpha=1.0
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
        do {
            tv.alpha=1.0
        }
        do {
            newsTable.alpha=1.0
        }
        if(scheduleInstance != nil) {
            scheduleInstance?.DisplaySchedule.alpha=1.0
            scheduleInstance?.view.backgroundColor=UIColor.lightGray
        }
        if(grilleMenu != nil) {
            grilleMenu.alpha=1.0
        }
        btnMenu.tag=0
    }
    
    func swiped(_gesture: UISwipeGestureRecognizer) {
            if(_gesture.direction==UISwipeGestureRecognizerDirection.left) {
                print("left")
                closeMenu()
            }
    }
    
    func tappedOutside(_gesture: UITapGestureRecognizer) {
        if(_gesture.location(in: self.view).x>tblMenuOptions.frame.width) {
            closeMenu()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(on)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let tapOutside = UITapGestureRecognizer(target: self, action: #selector(self.tappedOutside))
        tapOutside.cancelsTouchesInView=false
        self.view.addGestureRecognizer(tapOutside)
        
        tblMenuOptions.tableFooterView = UIView()
        tblMenuOptions.separatorColor=UIColor.clear
        //self.view.backgroundColor=UIColor(red: 0/255, green: 30/255, blue: 65/255, alpha: 1)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateArrayMenuOptions()
        self.view.backgroundColor=UIColor.clear
        //self.tblMenuOptions.backgroundColor=UIColor.white
        UIApplication.shared.isStatusBarHidden = true
        
        let path = UIBezierPath(roundedRect:createdAndDesigned.bounds,
                                byRoundingCorners:[.bottomRight, .bottomLeft],
                                cornerRadii: CGSize(width: 10, height:  10))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        createdAndDesigned.layer.mask = maskLayer
        
    }
    
    func updateArrayMenuOptions(){
        arrayMenuOptions.append(["title":"Home", "icon":"news"])
        arrayMenuOptions.append(["title":"News", "icon":"news"])
        arrayMenuOptions.append(["title":"Schedule","icon":"clock"])
        arrayMenuOptions.append(["title":"Grille","icon":"news"])
        arrayMenuOptions.append(["title":"Settings","icon":"news"])
        
        tblMenuOptions.reloadData()
    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!){
        btnMenu.tag=0
        
        if (self.delegate != nil) {
            let index = Int32(button.tag)
            /*if(button == self.btnCloseMenuOverlay){
                index = -1
            }*/
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0-buffer, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height+buffer)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu", for: indexPath) 
        
        //cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        //cell.backgroundColor = UIColor.clear
        cell.backgroundColor=UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
        tblMenuOptions.backgroundColor=UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
        
        let lblTitle : UILabel = cell.textLabel!
        let imgIcon : UIImageView = cell.imageView!
        
        
        imgIcon.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        lblTitle.text = arrayMenuOptions[indexPath.row]["title"]!
        lblTitle.textColor=UIColor.black
        
        if(on==lblTitle.text!) {
            print(lblTitle.text!)
            cell.setSelected(true, animated: false)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row==0) {
            tv.alpha=1.0
        }
        else if(indexPath.row==1) {
            newsTable.alpha=1.0
        }
        else if(indexPath.row==2) {
            if(scheduleInstance != nil) {
                scheduleInstance?.DisplaySchedule.alpha=1.0
                scheduleInstance?.view.backgroundColor=UIColor.lightGray
            }
        }
        self.view.window?.windowLevel=UIWindowLevelStatusBar-1
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
        btnMenu.tag=indexPath.row
        self.onCloseMenuClick(btn)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func backViewController() -> UIViewController
    {
        let numberOfViewControllers = self.navigationController?.viewControllers.count
        
        if numberOfViewControllers! < 2
        {
            return UIViewController()
        }
        else
        {
            return self.navigationController!.viewControllers[numberOfViewControllers! - 2] as UIViewController
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }  
}
