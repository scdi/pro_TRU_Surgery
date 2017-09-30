//
//  GeneralHealth.swift
//  TRU-Care
//
//  Created by jonas002 on 6/25/17.
//  Copyright © 2017 scdi. All rights reserved.
//

import CareKit
import ResearchKit

/**
 Struct that conforms to the `Assessment` protocol to define a back pain
 assessment.
 */
struct GeneralHealth: Assessment {
    // MARK: Activity
    
    let activityType: ActivityType = .generalHealth
    
    func carePlanActivity() -> OCKCarePlanActivity {
        // Create a weekly schedule.
        let startDate = DateComponents(year: 2016, month: 01, day: 01)
        let schedule = OCKCareSchedule.weeklySchedule(withStartDate: startDate as DateComponents, occurrencesOnEachDay: [1, 1, 1, 1, 1, 1, 1])
        
        // Get the localized strings to use for the assessment.
        let title = NSLocalizedString("General Health" , comment: "")
        let summary = NSLocalizedString("Daily", comment: "")
        
        let activity = OCKCarePlanActivity.assessment(withIdentifier: activityType.rawValue, groupIdentifier: nil, title: title, text: summary, tintColor: Colors.green.color, resultResettable: true, schedule: schedule, userInfo: nil, optional: false)
        
        return activity
    }
    
    // MARK: Assessment
    
    func task() -> ORKTask {
        var steps = [ORKStep]()
        
        let step = ORKFormStep(identifier:"GeneralHealthForm", title: "General Health", text: "")
        
        //HEALTH TODAY
        let formItemGeneralHealthSection = ORKFormItem(sectionTitle: " ") ////////// SECTION
        let generalHealthScaleAnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 10,
                                                                   minimumValue: 0,
                                                                   defaultValue: -1,
                                                                   step: 1,
                                                                   vertical: false,
                                                                   maximumValueDescription: NSLocalizedString("Best ever", comment: ""),
                                                                   minimumValueDescription: NSLocalizedString("Worst ever", comment: ""))
        let formItemGeneralHealth = ORKFormItem(identifier:"GeneralHealth", text: NSLocalizedString("1. On a scale from 0 to 10, how would you rate your health today?", comment: ""), answerFormat: generalHealthScaleAnswerFormat)
        //formItemGeneralHealth.placeholder = NSLocalizedString("Enter number", comment: "")
        
        
        //STRESS
        let formItemStressSection = ORKFormItem(sectionTitle: " ") ////////// SECTION
        let stressScaleAnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 10,
                                                            minimumValue: 0,
                                                            defaultValue: -1,
                                                            step: 1,
                                                            vertical: false,
                                                            maximumValueDescription: NSLocalizedString("High", comment: ""),
                                                            minimumValueDescription: NSLocalizedString("Low", comment: ""))
        let formItemStress = ORKFormItem(identifier:"StressItem", text: NSLocalizedString("2. On a scale from 0 to 10, how would you rate your stress today?", comment: ""), answerFormat: stressScaleAnswerFormat)
        //formItemStress.placeholder = NSLocalizedString("Enter number", comment: "")
        
        
        //SLEEP
        let formItemSleepSection = ORKFormItem(sectionTitle: " ") ////////// SECTION
        let sleepScaleAnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 12,
                                                           minimumValue: 0,
                                                           defaultValue: -1,
                                                           step: 1,
                                                           vertical: false,
                                                           maximumValueDescription: NSLocalizedString("", comment: ""),
                                                           minimumValueDescription: NSLocalizedString("", comment: ""))
        let formItemSleep = ORKFormItem(identifier:"SleepItem", text: NSLocalizedString("4. How many hours of sleep did you have last night?", comment: ""), answerFormat: sleepScaleAnswerFormat)
        //formItemSleep.placeholder = NSLocalizedString("Enter number", comment: "")
        
        //SLEEP QUALITY
        let formItemSleepQualitySection = ORKFormItem(sectionTitle: " ") ////////// SECTION
        let sleepQualityScaleAnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 10,
                                                                  minimumValue: 0,
                                                                  defaultValue: -1,
                                                                  step: 1,
                                                                  vertical: false,
                                                                  maximumValueDescription: NSLocalizedString("Quite satisfied", comment: ""),
                                                                  minimumValueDescription: NSLocalizedString("Not at all", comment: ""))
        let formItemSleepQuality = ORKFormItem(identifier:"SleepQualityItem", text: NSLocalizedString("3. How satisfied are you with the quality of sleep you got last night?", comment: ""), answerFormat: sleepQualityScaleAnswerFormat)
        //formItemSleepQuality.placeholder = NSLocalizedString("Enter number", comment: "")
        
        
        
        
        
        
        
        
        //SYMPTOM INTERFERENCE
        let formItemSymptomsInterferenceSection = ORKFormItem(sectionTitle: " ") ////////// SECTION
        
        let symptomsInterferenceScaleAnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 10,
                                                                          minimumValue: 0,
                                                                          defaultValue: -1,
                                                                          step: 1,
                                                                          vertical: false,
                                                                          maximumValueDescription: NSLocalizedString("Quite a bit", comment: ""),
                                                                          minimumValueDescription: NSLocalizedString("Not at all", comment: ""))
        let formItemSymptomsInterference = ORKFormItem(identifier:"SymptomsInterference", text: NSLocalizedString("5. Did you have symptoms interfering with your activities today?", comment: ""), answerFormat: symptomsInterferenceScaleAnswerFormat)
        
        
        step.isOptional = false
        formItemGeneralHealth.isOptional = false
        formItemStress.isOptional = false
        formItemSymptomsInterference.isOptional = false
        formItemSleepQuality.isOptional = false
        formItemSymptomsInterference.isOptional = false
        
        //NSLocalizedString("Did your symptoms interfere with your activities today?", comment: "")
        step.formItems = [
            
            formItemGeneralHealthSection,
            formItemGeneralHealth,
            
            formItemStressSection,
            formItemStress,
            
            formItemSleepSection,
            formItemSleep,
            
            formItemSleepQualitySection,
            formItemSleepQuality,
            
            formItemSymptomsInterferenceSection,
            formItemSymptomsInterference
            
        ]
        steps += [step]
        
        
        // Create an ordered task with a single question.
        let task = ORKOrderedTask(identifier: activityType.rawValue, steps: steps)
        let taskDefault = UserDefaults()
        taskDefault.set("YES", forKey: "vasKey")
        
        return task
    }
}

