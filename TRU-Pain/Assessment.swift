//
//  Assessment.swift
//  TRU-BLOOD
//
//  Created by jonas002 on 1/2/17.
//  Copyright © 2017 scdi. All rights reserved.
//

/*
 Copyright (c) 2016, Apple Inc. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 1.  Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2.  Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
 
 3.  Neither the name of the copyright holder(s) nor the names of any contributors
 may be used to endorse or promote products derived from this software without
 specific prior written permission. No license is granted to the trademarks of
 the copyright holders even if such marks are included in this software.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import CareKit
import ResearchKit

//import CoreData

/**
 Protocol that adds a method to the `Activity` protocol that returns an `ORKTask`
 to present to the user.
 */
protocol Assessment: Activity {
    func task() -> ORKTask
    
}


/**
 Extends instances of `Assessment` to add a method that returns a
 `OCKCarePlanEventResult` for a `OCKCarePlanEvent` and `ORKTaskResult`. The
 `OCKCarePlanEventResult` can then be written to a `OCKCarePlanStore`.
 */

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


extension Assessment {
    func buildResultForCarePlanEvent(_ event: OCKCarePlanEvent, taskResult: ORKTaskResult) -> OCKCarePlanEventResult {
        print("taskResult.taskRunUUID")
        print(taskResult.taskRunUUID)
//        print(event.date)
//        print(event.state   )
//        print(event.activity)
        
        
        let symptomDefault = UserDefaults()
        symptomDefault.set("NO", forKey: "symptomKey")
        var symptomDate = NSDate()
        var resultForDisplay:String = " "
        
        //Meals Appetite START
        var array:[Int]? = []
        if taskResult.identifier == "appetite" {
            for eachResult in taskResult.results! {
                print("each result" + String(describing:eachResult))
                
                if let textResult = eachResult as? ORKStepResult, let answer = textResult.results {
                    for result in answer {
                        print("resutls" + String(describing:result))
                        if let text = result as? ORKChoiceQuestionResult, let response = text.answer as? Array<Any> {
                            let mealResponse = response[0]
                            let smallInt = Int(mealResponse as! String)
                            array?.append(smallInt!)
                            
                        }
                    }
                    print("my text result answer" + String(describing:(answer as AnyObject).firstItem))
                }
            }
            //ends the for loop
            let sum:Double =  Double((array?.reduce(0, +))!)/3
            print("Summ -- " + String(describing: sum))
            return OCKCarePlanEventResult(valueString:  String(format: "%2.f", sum)+"%", unitString: "", userInfo: nil)
        }
        //Meals Appetite END
        
        
        
        for aResult in taskResult.results! {
            //Task level
            print("task Identifiers: \(taskResult.identifier)\n")
            
            
            
            if aResult.identifier == "symptom_focus" {
                print("aResult.identifier7 symptom_focus")
                if let textResult = aResult as? ORKChoiceQuestionResult, let answers = textResult.choiceAnswers {
                    
                        print("access symptom focus previousSymptoms")
                        let timeFormatter = DateFormatter()
                        timeFormatter.timeStyle = .short
                        let symptomsResulted = answers as NSArray
                        let symptomResult = symptomsResulted.componentsJoined(by: ",")
                        print("timeResult - symptom Date \(symptomDate) ")
                        print("timeResult - symptom pain location  \(symptomResult) ")
                        let dayFormatter = DateFormatter()
                        dayFormatter.dateFormat = "yyyyMMdd"
                        
                        let manager = ListDataManager()
                        let previousSymtoms = manager.findTodaySymptomFocus(date: dayFormatter.string(from: symptomDate as Date))
                        print(previousSymtoms)
                        
                        return OCKCarePlanEventResult(valueString: symptomResult, unitString: previousSymtoms, userInfo: nil)
                }
            }
            
            if let results = taskResult.results as? [ORKStepResult] {
                for stepResult: ORKStepResult in results {
                    print("identifiers for result? "+stepResult.identifier) //those are the steps
                    for result in stepResult.results! {
                        if let questionResult = result as? ORKQuestionResult {
                            print(questionResult)
                            if questionResult.identifier == "symptom_eventTimeStamp" {
                                symptomDate = (questionResult.answer! as? NSDate)!
                                print("date assessed. \(symptomDate) 0")
                            }
                            if questionResult.identifier == "menstruating" {
                                let resultForDisplayArray = (questionResult.answer! as? NSArray)!
                                resultForDisplay = resultForDisplayArray[0] as! String
                                print("menstruating. \(resultForDisplay) 0")
                            }
                        }
                    }
                }
            }
            
        }
        
        
        // Get the first result for the first step of the task result.
        print("first result identifier: \(taskResult.firstResult as! ORKStepResult)")
        guard let firstResult = taskResult.firstResult as? ORKStepResult, let stepResult = firstResult.results?.first else { fatalError("Unexepected task results") }
        print("first result identifier: \(firstResult.identifier)")
        var menstrualFlow:[Int] = []
        
        if firstResult.identifier == "symptomFocus" {
            print("symptomFocus-symptomFocus")
            
        }
        if firstResult.identifier == "scdPain" {
            print("painFocus-symptomFocus")
            if let numericResult = stepResult as? ORKScaleQuestionResult, let answer = numericResult.scaleAnswer {
                print("pain numericResult - numericResult \(answer as Double)")
                let x = answer as Double
                let xString = String(x.roundTo(places: 1))
                return OCKCarePlanEventResult(valueString: xString, unitString: "out of 10", userInfo: nil)
            }
        }
        
        if firstResult.identifier == "temperature" {
            print("we are getting temperature data")
            if let numericResult = stepResult as? ORKNumericQuestionResult, let answer = numericResult.numericAnswer {
                print("temperature numericResult - numericResult \(answer as Double)")
                let x = answer as Double
                let xString = String(x.roundTo(places: 1))
                return OCKCarePlanEventResult(valueString: xString, unitString: numericResult.unit, userInfo: nil)
            }
        }
        
        
        //symptom_intensity_level
        
        if firstResult.identifier == "MenstruationFormText" {
            
            for someResult in firstResult.results! {
                print("identifiers:::: \(someResult.identifier) \n and someResult \(someResult)")
                if someResult.identifier == "pad01" {
                    if let numericResult = someResult as? ORKNumericQuestionResult, let score = numericResult.answer as! Int?, score >= 0 {
                        print("pad01 answer number: \(numericResult.numericAnswer)")
                        menstrualFlow.append((numericResult.numericAnswer as! Int)*2)
                    }
                }
                if someResult.identifier == "pad02" {
                    if let numericResult = someResult as? ORKNumericQuestionResult, let score = numericResult.answer as! Int?, score >= 0 {
                        print("pad02 answer number: \(numericResult.numericAnswer)")
                        menstrualFlow.append((numericResult.numericAnswer as! Int)*5)
                    }
                }
                if someResult.identifier == "pad03" {
                    if let numericResult = someResult as? ORKNumericQuestionResult, let score = numericResult.answer as! Int?, score >= 0 {
                        print("pad03 answer number: \(numericResult.numericAnswer)")
                        menstrualFlow.append((numericResult.numericAnswer as! Int)*10)
                    }
                }
                if someResult.identifier == "tampon01" {
                    if let numericResult = someResult as? ORKNumericQuestionResult, let score = numericResult.answer as! Int?, score >= 0 {
                        print("tampon01 answer number: \(numericResult.numericAnswer)")
                        menstrualFlow.append((numericResult.numericAnswer as! Int)*2)
                    }
                }
                if someResult.identifier == "tampon02" {
                    if let numericResult = someResult as? ORKNumericQuestionResult, let score = numericResult.answer as! Int?, score >= 0 {
                        print("tampon02 answer number: \(numericResult.numericAnswer)")
                        menstrualFlow.append((numericResult.numericAnswer as! Int)*5)
                    }
                }
                if someResult.identifier == "tampon03" {
                    if let numericResult = someResult as? ORKNumericQuestionResult, let score = numericResult.answer as! Int?, score >= 0 {
                        print("tampon03 answer number: \(numericResult.numericAnswer)")
                        menstrualFlow.append((numericResult.numericAnswer as! Int)*10)
                    }
                }
                print("menstrualFlow!\(menstrualFlow.reduce(0, +))")
                
            }
            
            let menstrualDailyFlow = menstrualFlow.reduce(0, +)
            return OCKCarePlanEventResult(valueString: String(menstrualDailyFlow), unitString: "Units", userInfo: nil)
        }
        
        
        
        
        
        
        // Determine what type of result should be saved.
        if let scaleResult = stepResult as? ORKScaleQuestionResult, let answer = scaleResult.scaleAnswer {
            print("scaleResult - scaleResult")
            
            if scaleResult.identifier == "normal stool" {
                print("we are getting stool data")
                
                if let scaleResult = stepResult as? ORKScaleQuestionResult, let answer = scaleResult.scaleAnswer {
                    //we need value unit string for diarrhea
                    var unitString = " "
                    if let results = taskResult.results as? [ORKStepResult] {
                        for stepResult: ORKStepResult in results {
                            for result in stepResult.results! {
                                if let questionResult = result as? ORKQuestionResult {
                                    print(questionResult)
                                    if questionResult.identifier == "diarrhea stool" {
                                        print(questionResult.answer!)
                                        if let scaleResult = questionResult as? ORKScaleQuestionResult, let answer = scaleResult.scaleAnswer {
                                            unitString = "normal, "+answer.stringValue+" diarrhea"
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                    
                    print("stool - scaleResult \(answer.stringValue)")
                    return OCKCarePlanEventResult(valueString: answer.stringValue, unitString:unitString, userInfo: nil)
                }
            }
            else {
                return OCKCarePlanEventResult(valueString: answer.stringValue, unitString: "out of 10", userInfo: nil)
            }
        }
            
        else if let numericResult = stepResult as? ORKNumericQuestionResult, let answer = numericResult.numericAnswer {
            print("numericResult - numericResult \(answer.stringValue)")
            let x = answer as Double
            let xString = String(x.roundTo(places: 1))
            return OCKCarePlanEventResult(valueString: xString, unitString: numericResult.unit, userInfo: nil)
        }
            
            
            
        else if let timeResult = stepResult as? ORKTimeOfDayQuestionResult, let answer = timeResult.dateComponentsAnswer {
            
            //let hour = String(describing: answer.hour!)
            //let minute = String(describing: answer.minute!)
            let userCalendar = Calendar.current
            let someDateTime = userCalendar.date(from: answer as DateComponents!)
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            print("timeResult - someDateTime \(someDateTime) ")
            return OCKCarePlanEventResult(valueString: formatter.string(from: someDateTime!), unitString: "", userInfo: nil)
        }
            
        else if let dateTimeResult = stepResult as? ORKDateQuestionResult, let answer = dateTimeResult.dateAnswer {
            print("timeResult and date")
            //let hour = String(describing: answer.hour!)
            //let minute = String(describing: answer.minute!)
            //let userCalendar = Calendar.current
            symptomDate = answer as NSDate
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            print("timeResult - symptomDate \(symptomDate) ")
            print(resultForDisplay + "OK")
            return OCKCarePlanEventResult(valueString: formatter.string(from: symptomDate as Date), unitString: resultForDisplay, userInfo: nil)
        }
            
        else if let booleanResult = stepResult as? ORKBooleanQuestionResult, let answer = booleanResult.booleanAnswer {
            print("boolResult - booleanResult")
            if answer.boolValue.description == "true" {
                return OCKCarePlanEventResult(valueString: "Yes", unitString: "", userInfo: nil)
            } else {
                return OCKCarePlanEventResult(valueString: "No", unitString: "", userInfo: nil)
            }
            
        }
            
        else if let textResult = stepResult as? ORKChoiceQuestionResult, let answers = textResult.choiceAnswers {
            print("textResult - textResult")
            if (answers.first! as AnyObject).debugDescription  == "0" {
                return OCKCarePlanEventResult(valueString: "No", unitString: "", userInfo: nil)
            }
            else if (answers.first! as AnyObject).debugDescription  == "1" {
                return OCKCarePlanEventResult(valueString: "Yes", unitString: "", userInfo: nil)
            }
            else if (answers.first! as AnyObject).debugDescription  == "2" {
                return OCKCarePlanEventResult(valueString: "Started today", unitString: "", userInfo: nil)
            }
            else if (answers.first! as AnyObject).debugDescription  == "3" {
                return OCKCarePlanEventResult(valueString: "Continuing", unitString: "", userInfo: nil)
            }
            else if (answers.first! as AnyObject).debugDescription  == "4" {
                return OCKCarePlanEventResult(valueString: "Ended yesterday", unitString: "", userInfo: nil)
            }
            else if (answers.first! as AnyObject).debugDescription  == "999" {
                return OCKCarePlanEventResult(valueString: "NA", unitString: "", userInfo: nil)
            }
                
            else if (answers.first! as AnyObject).debugDescription  == "New" {
                return OCKCarePlanEventResult(valueString: "New", unitString: "", userInfo: nil)
            }
            else if (answers.first! as AnyObject).debugDescription  == "Same" {
                return OCKCarePlanEventResult(valueString: "Same", unitString: "", userInfo: nil)
            }
            else if (answers.first! as AnyObject).debugDescription  == "Worse" {
                return OCKCarePlanEventResult(valueString: "Worse", unitString: "", userInfo: nil)
            }
            else if (answers.first! as AnyObject).debugDescription  == "Better" {
                return OCKCarePlanEventResult(valueString: "Better", unitString: "", userInfo: nil)
            }
            else if (answers.first! as AnyObject).debugDescription  == "Resolved" {
                return OCKCarePlanEventResult(valueString: "Resolved", unitString: "", userInfo: nil)
            }
            else if stepResult.identifier == "symptom_focus" {
                print("access symptom focus previousSymptoms")
                let timeFormatter = DateFormatter()
                timeFormatter.timeStyle = .short
                let symptomsResulted = answers as NSArray
                let symptomResult = symptomsResulted.componentsJoined(by: ",")
                print("timeResult - symptom Date \(symptomDate) ")
                print("timeResult - symptom pain location  \(symptomResult) ")
                let dayFormatter = DateFormatter()
                dayFormatter.dateFormat = "yyyyMMdd"
                
                let manager = ListDataManager()
                let previousSymtoms = manager.findTodaySymptomFocus(date: dayFormatter.string(from: symptomDate as Date))
                    
                
                print("previousSymptoms")
                print(previousSymtoms)
                
                return OCKCarePlanEventResult(valueString: symptomResult, unitString: previousSymtoms, userInfo: nil)
            }
                
            else {
                let painLocation = answers as NSArray
                let string = painLocation.componentsJoined(by: ",")
                return OCKCarePlanEventResult(valueString: string, unitString: "", userInfo: nil)
            }
        }
        
        
        fatalError("Unexpected task result type")
    }
}
//        var symptoms: [Care]!
//        symptoms = Care.mr_findAll() as! [Care]
//        if symptoms.count > 0 {
//            for (index, element) in symptoms.enumerated() {
//                if let data = String(symptoms[index].title) {
//                    print("item:\(data) \(index):\(element)")
//                }
//            }
//        }


