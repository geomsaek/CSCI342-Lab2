//
//  ViewController.swift
//  Moving8Ball
//
//  Created by Matthew Saliba on 16/03/2016.
//  Copyright © 2016 Matthew Saliba. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var userInput: UITextField!
    @IBOutlet var userLabel: UILabel!
    
    
    var userresponses = [QuestionResponseModel]()
    
    @IBOutlet var circleImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)

        if let savedResponses = loadResponses(){
            userresponses += savedResponses
        }else {
            loadSampleResponse()
        }
   
    }
    
    // load existing responses
    func loadResponses() -> [QuestionResponseModel]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(QuestionResponseModel.ArchiveURL.path!) as? [QuestionResponseModel]
    }
    
    func loadSampleResponse(){
        
        let existOne = QuestionResponseModel(question: "What day is it today?", answer: "A great day!")!
        let existTwo = QuestionResponseModel(question: "Is it going to be a good year?", answer: "Maybe")!
        let existThree = QuestionResponseModel(question: "Should I eat pizza", answer: "Not even a question")!
        
        userresponses.append(existOne)
        userresponses.append(existTwo)
        userresponses.append(existThree)

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
                print("after")
            }
        }
    }
    
    // history button press
    @IBAction func shakebuttonpressed(sender: UIButton) {}
    
    // create a response object for output
    func changeResponse(){
        
        let ball : EightBallModel = EightBallModel()
        
        let response = ball.magicResponse()
        let circle = ball.magicCircle()
        
        self.circleImage.image=UIImage(named: circle)
        self.userLabel?.text = response
        
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

