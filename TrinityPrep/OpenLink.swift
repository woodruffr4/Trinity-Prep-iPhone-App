//
//  OpenLink.swift
//  TrinityPrep
//
//  Created by Ricky Woodruff on 1/23/17.
//  Copyright © 2017 Ricky Woodruff. All rights reserved.
//

import UIKit

class OpenLink: UIViewController {
    
    @IBOutlet var webView: UIWebView!
    @IBAction func close(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {});
    }
    
    @IBAction func shareButton(_ sender: AnyObject) {
        if(urlToOpen != "") {
            let firstActivityItem = "Check this out!"
            let secondActivityItem : URL = URL(string: urlToOpen)!
            
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
            
            // This lines is for the popover you need to show in iPad
            activityViewController.popoverPresentationController?.barButtonItem = (sender as! UIBarButtonItem)
            
            // This line remove the arrow of the popover to show in iPad
            activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
            
            // Anything you want to exclude
            activityViewController.excludedActivityTypes = [
                UIActivityType.postToWeibo,
                UIActivityType.print,
                UIActivityType.assignToContact,
                UIActivityType.saveToCameraRoll,
                UIActivityType.addToReadingList,
                UIActivityType.postToFlickr,
                UIActivityType.postToVimeo,
                UIActivityType.postToTencentWeibo
            ]
            
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if urlToOpen != "" {
            
            let url = URL (string: urlToOpen);
            let requestObj = URLRequest(url: url!);
            
            self.webView.frame = self.view.bounds
            webView.isOpaque=true
            webView.backgroundColor=UIColor.white
            webView.clipsToBounds=true
            webView.scalesPageToFit = true
            webView.allowsLinkPreview = true
            
            self.webView.loadRequest(requestObj);
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor=UIColor.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*func displayAlert(title: String, message: String) {
     let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
     alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
     presentViewController(alertController, animated: true, completion: nil)
     return
     }*/
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
