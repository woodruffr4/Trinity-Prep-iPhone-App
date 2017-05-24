//
//  NewsViewController.swift
//  TrinityPrep
//
//  Created by Ricky Woodruff on 1/23/17.
//  Copyright © 2017 Ricky Woodruff. All rights reserved.
//

import UIKit

var urlToOpen: String = ""

var newsToReadFrom: String = "http://www.trinityprep.org/rss.cfm?news=10"

var refreshAlert = UIAlertController(title: "Error", message: "No network connection.", preferredStyle: UIAlertControllerStyle.alert)

var newsTable: UITableView = UITableView()

class NewsViewController: UIViewController, SlideMenuDelegate, UITableViewDelegate, XMLParserDelegate {

    var xmlParser: XMLParser!
    
    @IBOutlet var table: UITableView!
    
    var activity: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var entryTitle: String!
    var entryDate: String!
    var entryLink: String!
    var entryDuration: String!
    var entryImgURL: String = ""
    var entrySubtitle: String!
    var entryDescription: String!
    var currentParsedElement = String()
    var weAreInsideAnItem = false
    
    var feeds = [NewsItem]()
    var images = [UIImage]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTable=table
        
        let open = UISwipeGestureRecognizer(target: self, action: #selector(openWindow))
        open.direction=UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(open)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadList(_:)),name:NSNotification.Name(rawValue: "load"), object: nil)
        self.activity = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 100,height: 100))
        self.activity.center = self.view.center
        self.activity.hidesWhenStopped = true
        self.activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(self.activity)
        self.view.bringSubview(toFront: self.activity)
        self.activity.startAnimating()
        print(feeds.count)
        
        if(feeds.count==0) {
            refresh()
        } else {
            
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let refreshControl=UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Updating...")

        refreshControl.addTarget(self, action: #selector(pullRefresh(_:)), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            table.refreshControl = refreshControl
        } else {
            table.backgroundView = refreshControl
        }
        
         self.table.insertSubview(refreshControl, at: 0)
        
        let attrs = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "Georgia", size: 22)!
        ]
        
        navigationController?.navigationBar.titleTextAttributes = attrs
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 231/255, green: 180/255, blue: 15/255, alpha: 1)
        
        let btn1 = UIButton(type: .system)
        btn1.setImage(UIImage(named: "menu"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(onSlideMenuButtonPressed(_:)), for: .touchUpInside)
        btn1.tintColor = UIColor.white
        let item1 = UIBarButtonItem(customView: btn1)
        
        self.navigationItem.setLeftBarButton(item1, animated: true)
        self.navigationItem.title="News"
        
    }
    
    func openWindow(_gesture: UISwipeGestureRecognizer) {
        if(_gesture.direction==UISwipeGestureRecognizerDirection.right) {
            if(_gesture.location(in: view).x >= 0 && _gesture.location(in: view).x <= 70) {
                onSlideMenuButtonPressed(button)
            }
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
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0-buffer, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height+buffer);
            self.table.alpha=0.5
            sender.isEnabled = true
            
        }, completion:nil)
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
    
    func showAlert() {
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
    func refresh() {
        
        if !Network.isConnectedToNetwork() {
            
            showAlert()
            
            if(self.activity.isAnimating) {
                self.activity.stopAnimating()
            }
            
            return
        }
        
        feeds.removeAll()
        images.removeAll()
        
        
        let urlString = URL(string: newsToReadFrom)
        let rssUrlRequest:URLRequest = URLRequest(url:urlString!)
        let queue:OperationQueue = OperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(rssUrlRequest, queue: queue) {
            (response, data, error) -> Void in
            self.xmlParser = XMLParser(data: data!)
            self.xmlParser.delegate = self
            self.xmlParser.parse()
        }
    }
    
    func parser(_ parser: XMLParser,didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        if elementName == "item" {
            weAreInsideAnItem = true
        }
        if weAreInsideAnItem {
            switch elementName {
            case "title":
                entryTitle = String()
                currentParsedElement = "title"
            case "description":
                entryDescription = String()
                currentParsedElement = "description"
            case "link":
                entryLink = String()
                currentParsedElement = "link"
            case "enclosure":
                self.entryImgURL = String()
                self.entryImgURL = self.entryImgURL + (attributeDict["url"])!
                currentParsedElement = "enclosure"
            default: break
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if weAreInsideAnItem {
            switch currentParsedElement {
            case "title":
                self.entryTitle = self.entryTitle + string
            case "description":
                self.entryDescription = self.entryDescription + string
            case "link":
                self.entryLink = self.entryLink + string
            default: break
            }
        }
    }
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        if weAreInsideAnItem {
            switch elementName {
            case "title":
                currentParsedElement = ""
            case "description":
                currentParsedElement = ""
            case "link":
                currentParsedElement = ""
            case "enclosure":
                currentParsedElement = ""
            default: break
            }
            if elementName == "item" {
                let entryNews = NewsItem()
                entryNews.title = entryTitle
                entryNews.desc = entryDescription
                entryNews.link = entryLink
                entryNews.imgURL = entryImgURL
                feeds.append(entryNews)
                weAreInsideAnItem = false
            }
        }
    }
    
    
    func parserDidEndDocument(_ parser: XMLParser){
        
        for s in feeds {
            if let url = URL(string: s.imgURL) {
                if let data = try? Data(contentsOf: url) {
                    self.images.append(UIImage(data: data)!)
                }
            }
        }
        refreshUI()
        //print("done")
    }
    
    func refreshUI() {
        DispatchQueue.main.async(execute: {
            self.table.reloadData()
            if(self.activity.isAnimating) {
                self.activity.stopAnimating()
            }
            if(self.table.refreshControl?.isRefreshing)! {
                self.table.refreshControl?.endRefreshing()
            }
            
        });
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(feeds.count>0) {
            return feeds.count
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> cell {
        
        let theCell : cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! cell
        
        theCell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if(!feeds.isEmpty && !images.isEmpty) {
            
            if ((indexPath as NSIndexPath).row < feeds.count - 1) {
                theCell.title?.text = "\(feeds[(indexPath as NSIndexPath).row].title)"
            }
            
            if ((indexPath as NSIndexPath).row < images.count-1) {
                theCell.pic?.image=images[(indexPath as NSIndexPath).row]
            }
            
        }
        
        return theCell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if !feeds.isEmpty {
            
            if feeds[(indexPath as NSIndexPath).row].link == "" {
                urlToOpen = "http://google.com"
            } else {
                urlToOpen = feeds[(indexPath as NSIndexPath).row].link
            }
            
        }
        
        return indexPath
        
    }
    
    func loadList(_ notification: Notification){
        //load data here
        self.refresh()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func pullRefresh(_ refreshControl: UIRefreshControl) {
        // Do your job, when done:
        DispatchQueue.main.async(execute: {
            self.refresh()
        });
    }

class NewsItem: NSObject {
    var title = String()
    var date = String()
    var link = String()
    var desc = String()
    var imgURL = String()
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
