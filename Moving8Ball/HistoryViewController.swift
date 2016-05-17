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
    
    var TableData: NSArray!

    var count = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        getData()
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
                    
                    // call function in the main thread
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.tableView.reloadData()
                    })
                    
                }catch {
                    print("Error with Json: \(error)")
                }
            }
        }
        task.resume()
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
            return self.TableData.count
        }else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! HistoryCell
        
        let question = self.TableData[indexPath.row]["question"] as! String
        let answer = self.TableData[indexPath.row]["answer"] as! String
        let image = self.TableData[indexPath.row]["imageURL"] as! String
        
        
        // https://teamtreehouse.com/community/does-anyone-know-how-to-show-an-image-from-url-with-swift
        // need to put data into the main thread
        // also need to load the UIImage differently
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            var myImage =  UIImage(data: NSData(contentsOfURL: NSURL(string:image)!)!)
            cell.cImage.image = myImage
            self.tableView.reloadData()
        })
        
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
