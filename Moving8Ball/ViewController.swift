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
    @IBOutlet weak var shake : UIButton?
    
    @IBOutlet var circleImage: UIImageView!
    
    
    @IBAction func enterPressed(sender: AnyObject) {
        changeResponse()
    }
    @IBAction func shakebuttonpressed(sender: UIButton) {
        
        changeResponse()
        
    }
    
    func changeResponse(){
        
        
        let ball : EightBallModel = EightBallModel()
        
        let response = ball.magicResponse()
        let circle = ball.magicCircle()
        
        self.circleImage.image=UIImage(named: circle)
        

            // Fade out to set the text
            UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.userLabel.alpha = 0.0
                
                }, completion: {
                    (finished: Bool) -> Void in
                    
                    //Once the label is completely invisible, set the text and fade it back in
                    self.userLabel?.text = response
                    
                    // Fade in
                    UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        self.userLabel.alpha = 1.0
                        }, completion: nil)
            })

        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    


}

