//
//  GrilleViewController.swift
//  TrinityPrep
//
//  Created by Ricky Woodruff on 5/21/17.
//  Copyright © 2017 Ricky Woodruff. All rights reserved.
//

import UIKit

var grilleMenu: UIWebView!

class GrilleViewController: UIViewController, SlideMenuDelegate {

    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !Network.isConnectedToNetwork() {
            
            showAlert()
            
            return
        }
        
        let open = UISwipeGestureRecognizer(target: self, action: #selector(self.openWindow))
        open.direction=UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(open)
        
        let url = URL (string: "http://www.sagedining.com/menus/trinitypreparatory");
        let requestObj = URLRequest(url: url!);
        webView.scalesPageToFit=true
        webView.scrollView.bounces = true
        webView.clipsToBounds=true
        webView.frame=view.frame
        webView.isOpaque=false
        webView.backgroundColor=UIColor.white
        DispatchQueue.main.async(execute: {
            self.webView.loadRequest(requestObj);
        })
        grilleMenu=webView

        // Do any additional setup after loading the view.
    }
    
    func openWindow(_gesture: UISwipeGestureRecognizer) {
        if(_gesture.direction==UISwipeGestureRecognizerDirection.right) {
            if(_gesture.location(in: view).x >= 0 && _gesture.location(in: view).x <= 70) {
                onSlideMenuButtonPressed(button)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let attrs = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "Georgia", size: 22)!
        ]
        
        navigationController?.navigationBar.titleTextAttributes = attrs
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 30/255, blue: 65/255, alpha: 1)
        //navigationController?.preferredStatusBarStyle = UIStatusBarStyle.defaults
        
        let btn1 = UIButton(type: .system)
        btn1.setImage(UIImage(named: "menu"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(onSlideMenuButtonPressed(_:)), for: .touchUpInside)
        btn1.tintColor = UIColor.white
        let item1 = UIBarButtonItem(customView: btn1)
        
        self.navigationItem.setLeftBarButton(item1, animated: true)
        self.navigationItem.title="Grille Menu"
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
            navigationController?.navigationBar.barTintColor = UIColor.white
            self.openViewControllerBasedOnIdentifier("Grille")
            
            
            break;
        default:
            print("default\n", terminator: "")
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
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                frameMenu.origin.y = 0-buffer
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
                self.webView.alpha=1.0
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
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0-buffer, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height+buffer);
            self.webView.alpha=0.5
            sender.isEnabled = true
            
        }, completion:nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert() {
        self.present(refreshAlert, animated: true, completion: nil)
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
