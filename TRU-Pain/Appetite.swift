//
//  Appetite.swift
//  TRU-BLOOD
//
//  Created by jonas002 on 12/30/16.
//  Copyright © 2016 scdi. All rights reserved.
//

import ResearchKit
import CareKit
import CoreData



/**
 Struct that conforms to the `Assessment` protocol to define a mood
 assessment.
 */
struct Appetite: Assessment {
    // MARK: Activity
    
    let activityType: ActivityType = .appetite
    
    
    
    
    
    func carePlanActivity() -> OCKCarePlanActivity {
        
        
        
        // Create a weekly schedule.
        let startDate = DateComponents(year: 2017, month: 01, day: 01)
        let schedule = OCKCareSchedule.weeklySchedule(withStartDate: startDate as DateComponents, occurrencesOnEachDay: [1, 1, 1, 1, 1, 1, 1])
        
        // Get the localized strings to use for the assessment.
        let title = NSLocalizedString("Appetite", comment: "")
        let summary = NSLocalizedString("Meals", comment: "")
        
        let activity = OCKCarePlanActivity.assessment(
            withIdentifier: activityType.rawValue,
            groupIdentifier: nil,
            title: title,
            text: summary,
            tintColor: Colors.green.color,
            resultResettable: true,
schedule: schedule, userInfo: nil, optional: false)
        
        return activity
    }
    
    // MARK: Assessment
    
    func task() -> ORKTask {
        
        var steps = [ORKStep]()
        let step = ORKFormStep(identifier:activityType.rawValue, title: "Appetite", text: "")
        step.isOptional = false
        
        //BREAKFAST ////////// ////////// ////////// ////////// ////////// //////////
        let formItemBreakfastStatusSection = ORKFormItem(sectionTitle: " ") ////////// SECTION
        
        
        let breakfastStatusQuestionStepTitle = "How much of your breakfast meal did you eat?"
        let breakfastStatusTextChoices = [
            
            ORKTextChoice(text: "0. None", value: "0" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "1. A few bites", value: "10" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "2. About 25%", value: "25" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "3. About Half", value: "50" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "4. About 75%", value: "75" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "5. All of it", value: "100" as NSCoding & NSCopying & NSObjectProtocol)
        ]
        
        let symptomStatusAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: breakfastStatusTextChoices)
        
        let formItemBreakfastStatus = ORKFormItem(identifier:"breakfast_status", text: breakfastStatusQuestionStepTitle, answerFormat: symptomStatusAnswerFormat)//
        formItemBreakfastStatus.isOptional = false
        
        
        //BREAKFAST ////////// ////////// ////////// ////////// ////////// //////////
        let formItemLunchStatusSection = ORKFormItem(sectionTitle: " ") ////////// SECTION
        
        
        let lucnhStatusQuestionStepTitle = "How much of your lunch meal did you eat?"
        let lucnhStatusTextChoices = [
            
            ORKTextChoice(text: "0. None", value: "0" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "1. A few bites", value: "10" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "2. About 25%", value: "25" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "3. About Half", value: "50" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "4. About 75%", value: "75" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "5. All of it", value: "100" as NSCoding & NSCopying & NSObjectProtocol)
        ]
        
        let lucnhStatusAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: lucnhStatusTextChoices)
        
        let formItemLucnhStatus = ORKFormItem(identifier:"lunch_status", text: lucnhStatusQuestionStepTitle, answerFormat: lucnhStatusAnswerFormat)
        formItemLucnhStatus.isOptional = false
        
        
        //BREAKFAST ////////// ////////// ////////// ////////// ////////// //////////
        let formItemDinnerStatusSection = ORKFormItem(sectionTitle: " ") ////////// SECTION
        
        
        let dinnerStatusQuestionStepTitle = "How much of your dinner meal did you eat?"
        let dinnerStatusTextChoices = [
            
            ORKTextChoice(text: "0. None", value: "0" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "1. A few bites", value: "10" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "2. About 25%", value: "25" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "3. About Half", value: "50" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "4. About 75%", value: "75" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "5. All of it", value: "100" as NSCoding & NSCopying & NSObjectProtocol)
        ]
        
        let dinnerStatusAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: dinnerStatusTextChoices)
        
        let formItemDinnerStatus = ORKFormItem(identifier:"dinner_status", text: dinnerStatusQuestionStepTitle, answerFormat: dinnerStatusAnswerFormat)
        formItemDinnerStatus.isOptional = false
        
        
        
        
        
        
        
        step.formItems = [
            
            formItemBreakfastStatusSection,
            formItemBreakfastStatus,
            
            formItemLunchStatusSection,
            formItemLucnhStatus,
            
            formItemDinnerStatusSection,
            formItemDinnerStatus,
            
            
            
        ]
        steps += [step]
        
        
        
        // Create an ordered task with a single question.
        let task = ORKOrderedTask(identifier: activityType.rawValue, steps: steps)
        
        return task
    }
}
