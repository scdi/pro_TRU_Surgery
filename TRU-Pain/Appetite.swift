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
        let title = NSLocalizedString("Meals", comment: "")
        let summary = NSLocalizedString("Appetite", comment: "")
        
        let activity = OCKCarePlanActivity.assessment(
            withIdentifier: activityType.rawValue,
            groupIdentifier: nil,
            title: title,
            text: summary,
            tintColor: Colors.green.color,
            resultResettable: true,
            schedule: schedule,
            userInfo: nil
        )
        
        return activity
    }
    
    // MARK: Assessment
    
    func task() -> ORKTask {
        
        var steps = [ORKStep]()
        
        
        
        //Breakfast
        let breakfastStatusQuestionStepTitle = "How much of your breakfast meal did you eat?"
        let breakfastStatusTextChoices = [
            ORKTextChoice(text: "0. None", value: "0" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "1. A few bites", value: "10" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "2. About 25%", value: "25" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "3. About Half", value: "50" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "4. About 75%", value: "75" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "5. All of it", value: "100" as NSCoding & NSCopying & NSObjectProtocol)
        ]
        
        let breakfastStatusAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: breakfastStatusTextChoices)
        let breakfastStatusQuestionStep = ORKQuestionStep(identifier: "breakfast_status", title: breakfastStatusQuestionStepTitle, answer: breakfastStatusAnswerFormat)
        breakfastStatusQuestionStep.isOptional = false
        steps += [breakfastStatusQuestionStep]
        
        
        
        //Lunch
        let lunchStatusQuestionStepTitle = "How much of your lunch meal did you eat?"
        let lunchStatusTextChoices = [
            ORKTextChoice(text: "0. None", value: "0" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "1. A few bites", value: "10" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "2. About 25%", value: "25" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "3. About Half", value: "50" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "4. About 75%", value: "75" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "5. All of it", value: "100" as NSCoding & NSCopying & NSObjectProtocol)
        ]
        
        let lunchStatusAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: lunchStatusTextChoices)
        let lunchStatusQuestionStep = ORKQuestionStep(identifier: "lunch_status", title: lunchStatusQuestionStepTitle, answer: lunchStatusAnswerFormat)
        lunchStatusQuestionStep.isOptional = false
        steps += [lunchStatusQuestionStep]
        
        
        //Dinner
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
        let dinnerStatusQuestionStep = ORKQuestionStep(identifier: "dinner_status", title: dinnerStatusQuestionStepTitle, answer: dinnerStatusAnswerFormat)
        dinnerStatusQuestionStep.isOptional = false
        steps += [dinnerStatusQuestionStep]
        
        
        // Create an ordered task with a single question.
        let task = ORKOrderedTask(identifier: activityType.rawValue, steps: steps)
        
        return task
    }
}

