//
//  ViewController.swift
//  Moving8Ball
//
//  Created by Matthew Saliba on 16/03/2016.
//  Copyright © 2016 Matthew Saliba. All rights reserved.
//
//  http://www.learnswiftonline.com/mini-tutorials/how-to-download-and-read-json/
//  https://www.youtube.com/watch?v=QnUcndjwlh0
//  http://www.ios-blog.co.uk/tutorials/swift/swift-how-to-send-a-post-request-to-a-php-script/
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet var userInput: UITextField!
    @IBOutlet var userLabel: UILabel!
    
    var respArray = [String]()
    var speechsynt: AVSpeechSynthesizer = AVSpeechSynthesizer()
    var beforeSpeechString : String = " "
    
    var speechUtterance : AVSpeechUtterance?
    
    var userresponses = [QuestionResponseModel]()
    var voices : AVSpeechSynthesisVoice?
    
    @IBOutlet var circleImage: UIImageView!
    
    
    override func viewDidLoad() {
        
        var beforeSpeech:AVSpeechUtterance = AVSpeechUtterance(string: beforeSpeechString)
        speechsynt.speakUtterance(beforeSpeech)
        
    
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        self.respArray.append(NSLocalizedString("MAYBE",comment:"maybe comment"))
        self.respArray.append(NSLocalizedString("HAZY", comment: "hazy comment"))
        self.respArray.append(NSLocalizedString("DECIDE", comment: "decidely comment"))
        self.respArray.append(NSLocalizedString("SOURCE", comment: "sources comment"))
        self.respArray.append(NSLocalizedString("LATER", comment: "ask comment"))
        self.respArray.append(NSLocalizedString("DONTCOUNT", comment: "count comment"))
        
        if let savedResponses = loadResponses(){
            userresponses += savedResponses
        }
   
    }
    
    // load existing responses
    func loadResponses() -> [QuestionResponseModel]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(QuestionResponseModel.ArchiveURL.path!) as? [QuestionResponseModel]
    }
    
    
    // event when enter is clicked in the text field
    @IBAction func enterPressed(sender: AnyObject) {
        changeResponse()
        let tempQuestion : String? = userInput.text
        let tempAnswer: String? = userLabel.text
        
        if let temp = tempQuestion {
            if let innerTemp = tempAnswer {
                
                let userGen = QuestionResponseModel(question: temp, answer: innerTemp)
                userresponses.append(userGen!)
            }
        }
        postData(tempQuestion!, userAnswer: tempAnswer!)
    }
    
    func postData(userQuestion : String, userAnswer : String){
        
        let url: NSURL = NSURL(string: "http://li859-75.members.linode.com/addEntry.php")!
        
        
        
        let bodyData = "question=" + userQuestion + "&answer=" + userAnswer + "&username=mvhs977"
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);

        
        var session = NSURLSession.sharedSession()
//        var params = ["question" : userQuestion, "answer" : userAnswer, "username" : "mvhs977" ] as Dictionary<String, String>
        
        do {
            // curent code doesnt work as you were trying to send JSON string as the request to the server
            // server does not handle JSON strings in POST request hence why the commented string didnt work
            // if server was configured to accept JSON strings in a POST request this would have worked
            
            
            //try request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: [])
            //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
       //     request.addValue("application/json", forHTTPHeaderField: "Accept")
        
            var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                if let HTTPResponse = response as? NSHTTPURLResponse {
                    let statusCode = HTTPResponse.statusCode
                    
                    if statusCode == 200 {
                        print("OK")
                    }else {
                        fatalError("FAILED")
                    }
                }
            
            
            })
            task.resume()
        }catch {
            fatalError("FAILED")
        }
        
    }
    
    // history button press
    @IBAction func shakebuttonpressed(sender: UIButton) {}
    
    // create a response object for output
    func changeResponse(){
        
        let ball : EightBallModel = EightBallModel()
        
        let index = ball.magicResponse()
        let circle = ball.magicCircle()
        
        self.circleImage.image=UIImage(named: circle)
        self.userLabel?.text = self.respArray[index]

        speechUtterance = AVSpeechUtterance(string: self.respArray[index])
        speechsynt.speakUtterance(speechUtterance!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        let historyViewController = segue.destinationViewController as! HistoryViewController
        historyViewController.historyresponses = self.userresponses
        
    }

}

