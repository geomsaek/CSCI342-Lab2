//
//  HistoryViewController.swift
//  Moving8Ball
//
//  Created by Matthew Saliba on 13/04/2016.
//  Copyright © 2016 Matthew Saliba. All rights reserved.
//

extension NSURLSessionTask {

    func start(){
        self.resume()
    }
}

import UIKit

class HistoryViewController: UITableViewController{

    var historyresponses = [QuestionResponseModel]()
    

    var overlayView = UIView()
    var overlay : UIView?
    var activityIndicator = UIActivityIndicatorView()
    
    var TableData: NSArray!
    var initial = false
    var cache = NSCache()

    var count = 0
    
    override func viewDidLoad() {
        self.setLoadingScreen(true)
        self.getData()
        super.viewDidLoad()
    }
    
    
    func getData(){

        let requestURL: NSURL = NSURL(string: "http://li859-75.members.linode.com/retrieveAllEntries.php")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            
            if (statusCode == 200) {
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    self.TableData = json as! NSArray
                    print(json)
                    // call function in the main thread
                    dispatch_async(dispatch_get_main_queue(), {
                        self.setLoadingScreen(false)
                        self.tableView.reloadData()
                    })
                    
                }catch {
                    print("Error with Json: \(error)")
                }
            }
        }
        task.resume()
    }
    
    // set the loading screen
    func setLoadingScreen(display: Bool){
        
        if display {
            
            overlay = UIView(frame: view.frame)
            overlay!.backgroundColor = UIColor.blackColor()
            overlay!.alpha = 0.8
            
            view.addSubview(overlay!)
            
            overlayView.frame = CGRectMake(0, 0, 80, 80)
            overlayView.center = view.center
            overlayView.backgroundColor = UIColor(white: 0x0000000, alpha: 1)
            overlayView.clipsToBounds = true
            overlayView.layer.cornerRadius = 10
            
            activityIndicator.frame = CGRectMake(0, 0, 40, 40)
            activityIndicator.activityIndicatorViewStyle = .WhiteLarge
            activityIndicator.center = CGPointMake(overlayView.bounds.width / 2, overlayView.bounds.height / 2)
            
            overlayView.addSubview(activityIndicator)
            view.addSubview(overlayView)
            
            activityIndicator.startAnimating()
        }else {
            
            overlay?.removeFromSuperview()
            activityIndicator.stopAnimating()
            overlayView.removeFromSuperview()
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let temp = TableData?.count{
            return temp
        }else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! HistoryCell
            
        let location = self.TableData[indexPath.row]["imageURL"] as! String
        let cachePrev : NSData? = self.cache.objectForKey(location) as? NSData
        
        if cachePrev == nil {
            let data : NSData = NSData(contentsOfURL: NSURL(string:location)!)!
            self.cache.setObject(data, forKey: location)
        }
        
        
        let question = self.TableData[indexPath.row]["question"] as! String
        let answer = self.TableData[indexPath.row]["answer"] as! String
        
        // https://teamtreehouse.com/community/does-anyone-know-how-to-show-an-image-from-url-with-swift
        // need to put data into the main thread
        // also need to load the UIImage differently
        
        if initial == false {
            self.initial = true
            
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if let goodData = cachePrev {
                
                    let cacheImage = UIImage(data: goodData)
                    cell.cImage.image = cacheImage
                }
                
            })
            self.tableView.reloadData()
        }else {
            
            //var cachePrev : NSData? = self.cache.objectForKey(image) as? NSData
            if let goodData = cachePrev {
                
                let cacheImage = UIImage(data: goodData)
                cell.cImage.image = cacheImage
            }
            
        }
        
        cell.answer.text = answer
        cell.question.text = question
        

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    
    // Override to support rearranging the table view.
    /*override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    */

}
