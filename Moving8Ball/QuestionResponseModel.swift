//
//  QuestionResponseModel.swift
//  Moving8Ball
//
//  Created by Matthew Saliba on 12/04/2016.
//  Copyright © 2016 Matthew Saliba. All rights reserved.
//

import Foundation
import UIKit

class QuestionResponseModel: NSObject, NSCoding {

    
    var question : String?
    var answer : String?
    
    // archiving paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("questionresponsemodels")
    
    // MARK: Types
    
    struct PropertyKey {
        static let questionKey = "question"
        static let answerKey = "answer"
    }
    
    // MARK: Initialisation
    
    init?(question: String, answer: String){
        self.question = question
        self.answer = answer
        
        super.init()
        
        if answer.isEmpty || question.isEmpty {
            return nil
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        let question = aDecoder.decodeObjectForKey(PropertyKey.questionKey) as! String
        let answer = aDecoder.decodeObjectForKey(PropertyKey.answerKey) as! String
        
        self.init(question: question, answer: answer)
        
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(question, forKey: PropertyKey.questionKey)
        aCoder.encodeObject(answer, forKey: PropertyKey.answerKey)
    }
}