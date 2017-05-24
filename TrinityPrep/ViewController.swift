//
//  ViewController.swift
//  TrinityPrep
//
//  Created by Ricky Woodruff on 1/22/17.
//  Copyright © 2017 Ricky Woodruff. All rights reserved.
//

import UIKit

var tv: UITableView = UITableView()

var button: UIButton!

class ViewController: UIViewController, UITableViewDelegate, SlideMenuDelegate {
    
    
    @IBOutlet var table: UITableView!
    
    var showStatusBar = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        
        tv=table
        
        let open = UISwipeGestureRecognizer(target: self, action: #selector(self.openWindow))
        open.direction=UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(open)
        
        if(refreshAlert.actions.count==0) {
            refreshAlert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: { (Void) in
            }))
        }
        
//        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.slide))
//        self.view.addGestureRecognizer(pan)
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        table.backgroundColor=UIColor.lightGray
        table.separatorStyle = .none
        
        let attrs = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "Georgia", size: 22)!
        ]
        
        navigationController?.navigationBar.titleTextAttributes = attrs
        
        //UINavigationBar.appearance().titleTextAttributes = attrs
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 30/255, blue: 65/255, alpha: 1)
        
        let btn1 = UIButton(type: .system)
        btn1.setImage(UIImage(named: "menu"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(onSlideMenuButtonPressed(_:)), for: .touchUpInside)
        btn1.tintColor = UIColor.white
        let item1 = UIBarButtonItem(customView: btn1)
        button=btn1
        
        self.navigationItem.setLeftBarButton(item1, animated: true)
        self.navigationItem.title="Trinity Preparatory School"
        self.view.backgroundColor=UIColor.lightGray
    }
    
    func openWindow(_gesture: UISwipeGestureRecognizer) {
        if(_gesture.direction==UISwipeGestureRecognizerDirection.right) {
            if(_gesture.location(in: view).x >= 0 && _gesture.location(in: view).x <= 70) {
                onSlideMenuButtonPressed(button)
            }
        }
    }
    
//    func slide(_gesture: UIPanGestureRecognizer) {
//        
//        let leftToRight: Bool = (_gesture.velocity(in: view).x > 0)
//        
//        if(leftToRight) {
//            
//            switch(_gesture.state) {
//                
//            case .began:
//                
//                if(_gesture.location(in: self.view).x >= 0 && _gesture.location(in: self.view).x <= 5) {
//                    print("moving")
//                }
//                
//                break;
//                
//            case .changed:
//                
//                _gesture.view!.center.x = _gesture.view!.center.x + _gesture.translation(in: view).x
//                _gesture.setTranslation(CGPoint.zero, in: self.view)
//                print("changing")
//                break;
//                
//            case .ended:
//                
//                    // animate the side panel open or closed based on whether the view has moved more or less than halfway
//                    let hasMovedGreaterThanHalfway = _gesture.view!.center.x > view.bounds.size.width
//                    animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
//                
//                break;
//                
//            default:
//                break;
//                
//            }
//        }
//        
//        
//    }
//    
//    func animateLeftPanel(shouldExpand: Bool) {
//        if (shouldExpand) {
//            
//            //open the side menu
//        } else {
//            
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        switch(index){
        case 0:
            print("Home\n", terminator: "")
            on="Home"
            navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 30/255, blue: 65/255, alpha: 1)
            self.openViewControllerBasedOnIdentifier("Home")
            
            break
        case 1:
            print("News\n", terminator: "")
            on="News"
            navigationController?.navigationBar.barTintColor = UIColor(red: 218/255, green: 168/255, blue: 0, alpha: 1)
            self.openViewControllerBasedOnIdentifier("News")
            
            break
        case 2:
            print("Schedule\n",terminator:"")
            on="Schedule"
            navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 30/255, blue: 65/255, alpha: 1)
            self.openViewControllerBasedOnIdentifier("Schedule")
            
            break;
        case 3:
            
            print("Grille\n",terminator:"")
            on="Grille"
            self.openViewControllerBasedOnIdentifier("Grille")
            
            
            break;
        default:
            print("default\n", terminator: "")
        }
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
            print("Same VC")
        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    func onSlideMenuButtonPressed(_ sender : UIButton){
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            print("hiding")
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                frameMenu.origin.y = 0-buffer
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
                self.table.alpha=1.0
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        let menuVC : MenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        
        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        self.navigationController?.view.addSubview(menuVC.view)
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0-buffer, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height+buffer);
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0-buffer, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height+buffer);
            
            self.table.alpha=0.5
            sender.isEnabled = true
            self.view.layer.shadowOpacity=0.8
        }, completion:nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> EventCell {
        
        let theCell : EventCell = tableView.dequeueReusableCell(withIdentifier: "Event", for: indexPath) as! EventCell
        
        theCell.backgroundColor=UIColor.lightGray
        theCell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let view : UIView=theCell.Post
        
        view.addShadow(shadowColor: UIColor.black.cgColor, shadowOffset: CGSize.init(width: 5, height: 5), shadowOpacity: 0.4, shadowRadius: 6)
        view.cornerRadius=20.0
        
        if(indexPath.row==0) {
            theCell.title.text="Soccer"
        }
        else if(indexPath.row==1) {
            theCell.title.text="Cross Country"
        }
        else {
            theCell.title.text="Basketball"
        }
        
        theCell.title.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.black, thickness: 1.0)
        
        return theCell
    }

}

