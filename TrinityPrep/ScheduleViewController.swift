//
//  ScheduleViewController.swift
//  TrinityPrep
//
//  Created by Ricky Woodruff on 1/24/17.
//  Copyright © 2017 Ricky Woodruff. All rights reserved.
//

import UIKit

var us: Int = 0
var day : String = " "
var minStart = [Int]()
var minEnd = [Int]()
var per = [String]()

var scheduleInstance: ScheduleViewController? = nil

class ScheduleViewController: UIViewController, SlideMenuDelegate {
    
    var currentPeriod = -1
    
    @IBOutlet var DisplaySchedule: UIView!
    
    @IBOutlet var DayType: UILabel!
    
    @IBOutlet var MinsLeft: UILabel!
    
    var activity: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scheduleInstance = self
        
        let open = UISwipeGestureRecognizer(target: self, action: #selector(openWindow))
        open.direction=UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(open)
        
        self.view.backgroundColor=UIColor.lightGray
        
        if !Network.isConnectedToNetwork() {
            
            showAlert()
            DayType.text=""
            MinsLeft.text=""
            
            if(self.activity.isAnimating) {
                self.activity.stopAnimating()
            }
            
            return
        }

        let url = URL(string: "https://www.trinityprep.org/calendar/calendar_1516_gmt.rss")
        DispatchQueue.main.async{
            self.activity = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 100,height: 100))
            self.activity.center = self.view.center
            self.activity.hidesWhenStopped = true
            self.activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
            self.view.addSubview(self.activity)
            self.view.bringSubview(toFront: self.activity)
            self.activity.startAnimating()
        }
        
        
        
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {
            
            (data, response, error) in
            
            
            
            if error == nil {
                
                
                
                let urlContent = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                
                
                
                var charArr: [Character]=[Character]()
                
                
                
                var str:String=""
                
                
                
                if ((urlContent as? String) != nil) {
                    
                    str=urlContent as! String
                    
                }
                
                
                for char in str.characters {
                    
                    charArr.append(char)
                    
                }
                
                
                
                var dayItIs:[Character]=[Character]()
                
                
                
                for i in (0 ..< (charArr.count-11)) {
                    
                    if(charArr[i]=="<" && charArr[i+1]=="t" && charArr[i+2]=="i" && charArr[i+3]=="t" && charArr[i+4]=="l" && charArr[i+5]=="e" && charArr[i+6]==">" && charArr[i+7]=="D" && (charArr[i+8]=="A" || charArr[i+8]=="a") && (charArr[i+9]=="Y" || charArr[i+9]=="y") && charArr[i+10]==" ") {
                        
                        dayItIs.append(charArr[i+11])
                        
                        break;
                        
                    }
                    
                }
                
                //self.WhatDayIsIt.backgroundColor = UIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 1)
                
                day="\(dayItIs[0])"
                
                if(us==0) {
                    self.getUpperSchoolSchedule()
                } else {
                    self.getMiddleSchoolSchedule()
                }
                DispatchQueue.main.async{
                    
                    self.DayType.text="\(dayItIs[0]) Day"
                    
                    self.tick()
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 1.0,
                                                      target: self,
                                                      selector: #selector(ScheduleViewController.tick),
                                                      userInfo: nil,
                                                      repeats: true)
                    if(self.activity.isAnimating) {
                        self.activity.stopAnimating()
                    }
                }
                
            }
            
        }) 
        
        task.resume()
        
        
        // Do any additional setup after loading the view.
    }
    
    func openWindow(_gesture: UISwipeGestureRecognizer) {
        if(_gesture.direction==UISwipeGestureRecognizerDirection.right) {
            if(_gesture.location(in: view).x >= 0 && _gesture.location(in: view).x <= 70) {
                onSlideMenuButtonPressed(button)
            }
        }
    }
    
    func getUpperSchoolSchedule() {
        let dayAStart = [470, 479, 527, 575, 604, 652, 700, 749, 796, 844, 888]
        let dayAEnd = [475, 523, 571, 600, 648, 696, 744, 792, 840, 888, 915]
        let dayAPeriods = ["Advisory", "1st Period", "2nd Period",
                           "Assembly/Break", "3rd Period", "4th Period", "5th Period",
                           "US Lunch", "6th Period", "7th Period", "Study Period"]
        let dayBStart = [470, 479, 563, 592, 676, 760, 804, 888]
        let dayBEnd = [475, 559, 588, 672, 756, 800, 884, 915]
        let dayBPeriods = ["Advisory", "1st Period",
                           "US Assembly", "3rd Period", "5th Period",
                           "US Lunch", "7th Period", "Study Period"]
        let dayCStart = [470, 504, 588, 621, 705, 753, 801, 885]
        let dayCEnd = [500, 584, 617, 701, 749, 797, 881, 915]
        let dayCPeriods = ["Advisory", "2nd Period",
                           "Break", "4th Period", "US Chapel",
                           "US Lunch", "6th Period", "Study Period"]
        let dayDStart = [470, 479, 527, 575, 584, 632, 680, 728, 776, 824, 872]
        let dayDEnd = [475, 523, 571, 580, 628, 676, 724, 772, 820, 868, 900]
        let dayDPeriods = ["Advisory", "1st Period", "2nd Period",
                           "Break", "3rd Period", "4th Period", "5th Period",
                           "US Lunch", "6th Period", "7th Period", "Assembly/Pep Rally"]
        let dayEStart = [470, 479, 563, 621, 705, 753, 801, 885]
        let dayEEnd = [475, 559, 617, 701, 749, 797, 881, 915]
        let dayEPeriods = ["Advisory", "2nd Period",
                           "Assembly", "4th Period", "US Chapel",
                           "US Lunch", "6th Period", "Study Period"]
        let dayFStart = [470, 504, 588, 672, 756, 800, 884]
        let dayFEnd = [500, 584, 668, 752, 796, 880, 915]
        let dayFPeriods = ["Advisory", "2nd Period",
                           "Assembly", "4th Period", "US Lunch",
                           "6th Period", "Study Period"]
        
        if(day=="A") {
            minStart=dayAStart
            minEnd = dayAEnd
            per = dayAPeriods
        }
        else if(day=="B") {
            minStart=dayBStart
            minEnd = dayBEnd
            per = dayBPeriods
        }
        else if(day=="C") {
            minStart=dayCStart
            minEnd = dayCEnd
            per = dayCPeriods
        }
        else if(day=="D") {
            minStart=dayDStart
            minEnd = dayDEnd
            per = dayDPeriods
        }
        else if(day=="E") {
            minStart=dayEStart
            minEnd = dayEEnd
            per = dayEPeriods
        }
        else if(day=="F") {
            minStart=dayFStart
            minEnd = dayFEnd
            per = dayFPeriods
        }
    }
    
    func getMiddleSchoolSchedule() {
        let dayAStart = [470, 479, 527, 575, 604, 652, 700, 749, 796, 844, 888]
        let dayAEnd = [475, 523, 571, 600, 648, 696, 744, 792, 840, 888, 915]
        let dayAPeriods = ["Advisory", "1st Period", "2nd Period",
                           "Assembly/Break", "3rd Period", "4th Period", "MS Lunch",
                           "5th Period", "6th Period", "7th Period", "Study Period"]
        let dayBStart = [470, 479, 563, 592, 676, 720, 804, 888]
        let dayBEnd = [475, 559, 588, 672, 716, 800, 884, 915]
        let dayBPeriods = ["Advisory", "1st Period",
                           "MS Break", "3rd Period", "MS Lunch",
                           "5th Period", "7th Period", "Study Period"]
        let dayCStart = [470, 504, 588, 621, 705, 753, 801, 885]
        let dayCEnd = [500, 584, 617, 701, 749, 797, 881, 915]
        let dayCPeriods = ["Advisory", "2nd Period",
                           "Break", "4th Period", "MS Lunch",
                           "MS Chapel", "6th Period", "Study Period"]
        let dayDStart = [470, 479, 527, 575, 584, 632, 680, 728, 776, 824, 872]
        let dayDEnd = [475, 523, 571, 580, 628, 676, 724, 772, 820, 868, 900]
        let dayDPeriods = ["Advisory", "1st Period", "2nd Period",
                           "Break", "3rd Period", "4th Period", "MS Lunch",
                           "5th Period", "6th Period", "7th Period", "Assembly/Pep Rally"]
        let dayEStart = [470, 479, 563, 621, 705, 753, 801, 885]
        let dayEEnd = [475, 559, 617, 701, 749, 797, 881, 915]
        let dayEPeriods = ["Advisory", "2nd Period",
                           "Assembly", "4th Period", "MS Lunch",
                           "MS Chapel", "6th Period", "Study Period"]
        let dayFStart = [470, 504, 588, 672, 716, 800, 884]
        let dayFEnd = [500, 584, 668, 712, 796, 880, 915]
        let dayFPeriods = ["Advisory", "2nd Period",
                           "Assembly", "MS Lunch", "4th Period",
                           "6th Period", "Study Period"]
        
        if(day=="A") {
            minStart=dayAStart
            minEnd = dayAEnd
            per = dayAPeriods
        }
        else if(day=="B") {
            minStart=dayBStart
            minEnd = dayBEnd
            per = dayBPeriods
        }
        else if(day=="C") {
            minStart=dayCStart
            minEnd = dayCEnd
            per = dayCPeriods
        }
        else if(day=="D") {
            minStart=dayDStart
            minEnd = dayDEnd
            per = dayDPeriods
        }
        else if(day=="E") {
            minStart=dayEStart
            minEnd = dayEEnd
            per = dayEPeriods
        }
        else if(day=="F") {
            minStart=dayFStart
            minEnd = dayFEnd
            per = dayFPeriods
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        let attrs = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "Georgia", size: 22)!
        ]
        
        navigationController?.navigationBar.titleTextAttributes = attrs
        
        let btn1 = UIButton(type: .system)
        btn1.setImage(UIImage(named: "menu"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(onSlideMenuButtonPressed(_:)), for: .touchUpInside)
        btn1.tintColor = UIColor.white
        let item1 = UIBarButtonItem(customView: btn1)
        
        self.navigationItem.setLeftBarButton(item1, animated: true)
        self.navigationItem.title="Schedule"
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
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                frameMenu.origin.y = 0-buffer
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
                self.view.backgroundColor=UIColor.lightGray
                self.DisplaySchedule.alpha=1.0
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
            self.view.backgroundColor=UIColor(white: 1, alpha: 0.7)
            self.DisplaySchedule.alpha=0.5
            sender.isEnabled = true
            
        }, completion:nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func tick() {
        
        let minute=getMins()
        
        currentPeriod = -1
        
        for i in (0 ..< minStart.count) {
            /*if (minute < minStart[i]) {
             if (minute < minEnd[i - 1]) {
             currentPeriod = i - 1;
             break;
             } else {
             currentPeriod = i;
             break;
             }
             }*/
            if(minute >= minStart[i] && minute < minEnd[i]) {
                currentPeriod = i;
                break;
            }
            else if(i>0 && minute < minStart[i] && minute >= minEnd[i-1]) {
                currentPeriod = i;
                break;
            }
        }
        
        if(currentPeriod == -1) {
            MinsLeft?.text = "Not currently in School"
        } else {
            MinsLeft?.text = "\(abs(minEnd[currentPeriod]-minute)) minute(s) left in \(per[currentPeriod])"
        }
        
        
    }
    
    func getMins() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        let nowHour=Int(formatter.string(from: Date()))!
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "mm"
        let nowMin=Int(formatter2.string(from: Date()))!
        
        let minute=(nowHour*60)+nowMin
        return minute
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
