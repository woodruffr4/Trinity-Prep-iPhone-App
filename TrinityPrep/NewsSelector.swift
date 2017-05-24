//
//  NewsSelector.swift
//  TrinityPrep
//
//  Created by Ricky Woodruff on 1/23/17.
//  Copyright © 2017 Ricky Woodruff. All rights reserved.
//

import UIKit

class NewsSelector: UIViewController, UITableViewDelegate {
    
    var news : [String] = ["All","Academics","Admissions","Alumni","Announcements","Aquatics","Arts","Athletics","Latest","Notes from the Quad","Past Notes from the Quad","Notes from the Quad (Middle School)","Notes from the Quad (Upper School)"]
    var links : [String] = ["http://www.trinityprep.org/rss.cfm?news=0","http://www.trinityprep.org/rss.cfm?news=14","http://www.trinityprep.org/rss.cfm?news=1","http://www.trinityprep.org/rss.cfm?news=2","http://www.trinityprep.org/rss.cfm?news=5","http://www.trinityprep.org/rss.cfm?news=4","http://www.trinityprep.org/rss.cfm?news=13","http://www.trinityprep.org/rss.cfm?news=3","http://www.trinityprep.org/rss.cfm?news=10","http://www.trinityprep.org/rss.cfm?news=7","http://www.trinityprep.org/rss.cfm?news=15","http://www.trinityprep.org/rss.cfm?news=9","http://www.trinityprep.org/rss.cfm?news=8"]
    
    var selected: Int = 8
    
    @IBAction func cancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {});
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor.clear
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> NewsSelectorCell {
        
        let theCell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsSelectorCell
        
        theCell.title.text = news[(indexPath as NSIndexPath).row]
        
        if (indexPath as NSIndexPath).row == selected {
            theCell.setSelected(true, animated: true)
        }
        
        return theCell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        newsToReadFrom = links[(indexPath as NSIndexPath).row]
        
        selected = (indexPath as NSIndexPath).row
        
        close()
        
        return indexPath
        
    }
    
    func close() {
        self.dismiss(animated: true, completion: {});
        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: nil)
        
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
