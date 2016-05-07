//
//  ViewController.swift
//  Moving8Ball
//
//  Created by Matthew Saliba on 16/03/2016.
//  Copyright © 2016 Matthew Saliba. All rights reserved.
//
//  https://www.youtube.com/watch?v=uY9TAakoXhA -> Good Source for speech synthesiser
//  https://www.youtube.com/watch?v=7wqy9dvYzXU -> Good source for NSLocalizedString : In German however
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

