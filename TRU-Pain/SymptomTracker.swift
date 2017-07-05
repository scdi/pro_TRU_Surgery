//
//  SymptomTracker.swift
//  TRU-Pain
//
//  Created by jonas002 on 7/4/17.
//  Copyright © 2017 scdi. All rights reserved.
//

import CareKit
import ResearchKit

/**
 Struct that conforms to the `Assessment` protocol to define a back pain
 assessment.
 */
struct SymptomTracker: Assessment {
    // MARK: Activity
    
    let activityType: ActivityType = .symptomTracker
    
    func carePlanActivity() -> OCKCarePlanActivity {
        // Create a weekly schedule.
        let startDate = DateComponents(year: 2016, month: 01, day: 01)
        let schedule = OCKCareSchedule.weeklySchedule(withStartDate: startDate as DateComponents, occurrencesOnEachDay: [1, 1, 1, 1, 1, 1, 1])
        
        // Get the localized strings to use for the assessment.
        let title = NSLocalizedString("Symptom" , comment: "")
        let summary = NSLocalizedString("Tracker", comment: "")
        
        let activity = OCKCarePlanActivity.assessment(withIdentifier: activityType.rawValue, groupIdentifier: "Assessments", title: title, text: summary, tintColor: Colors.green.color, resultResettable: true, schedule: schedule,
                                                      userInfo: nil,
                                                      optional: false
        )
        
        return activity
    }
    
    // MARK: Assessment
    
    func task() -> ORKTask {
        let manager = ListDataManager() //get data from core data uploaded from onboard folder
        var steps = [ORKStep]()
        
        let defaults = UserDefaults.standard
        defaults.setValue("Normal", forKey: "ScaleType")
        print("defaults value are set");
        
        let step = ORKFormStep(identifier:"SymptomTrackerForm", title: "General Health", text: "")
        
        //SYMPTOM NAME
        let symptomArray: Array = manager.getArrayFor(string: "Symptoms")
        var choices:[ORKTextChoice] = []
        for item in symptomArray {
            let textString = item
            let choice =    ORKTextChoice(text: textString, value:textString as NSCoding & NSCopying & NSObjectProtocol)
            choices.append(choice)
        }
        
        let formItemSymptomNameSection = ORKFormItem(sectionTitle: " ") ////////// SECTION
        
        let symptomNameAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: choices)
        let formItemSymptomName = ORKFormItem(identifier:"symptom_focus", text: NSLocalizedString("1. What is the symptom that you would like to track?", comment: ""), answerFormat: symptomNameAnswerFormat)
        
        
        
        //SYMPTOM INTENSITY LEVEL ////////// ////////// ////////// ////////// ////////// //////////
        let formItemSymptomIntensitySection = ORKFormItem(sectionTitle: " ") ////////// SECTION
        
        let symptomIntensityAnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 10,
                                                                 minimumValue: 0,
                                                                 defaultValue: -1,
                                                                 step: 1,
                                                                 vertical: false,
                                                                 maximumValueDescription: NSLocalizedString("High", comment: ""),
                                                                 minimumValueDescription: NSLocalizedString("Low", comment: ""))
        let formItemSymptomIntensity = ORKFormItem(identifier:"symptom_intensity_level", text: NSLocalizedString("On a scale of 0-10, how intense is your symptom?", comment: ""), answerFormat: symptomIntensityAnswerFormat)
        formItemSymptomIntensity.isOptional = false
        
        
        //SYMPTOM STATUS ////////// ////////// ////////// ////////// ////////// //////////
        let formItemSymptomStatusSection = ORKFormItem(sectionTitle: " ") ////////// SECTION
        
        
        let symptomStatusQuestionStepTitle = "2. What is the status of this symptom?"
        let symptomStatusTextChoices = [
            
            ORKTextChoice(text: "New", value: "New" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Resolved", value: "Resolved" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Better", value: "Better" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Same", value: "Same" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Worse", value: "Worse" as NSCoding & NSCopying & NSObjectProtocol)
        ]
        
        let symptomStatusAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: symptomStatusTextChoices)
        
        let formItemSymptomStatus = ORKFormItem(identifier:"symptom_status", text: symptomStatusQuestionStepTitle, answerFormat: symptomStatusAnswerFormat)
        formItemSymptomStatus.isOptional = false
        
        
        //INTERVENTIONS ////////// ////////// ////////// ////////// ////////// //////////
        let formInterventionSection = ORKFormItem(sectionTitle: " ") ////////// SECTION
        let interventionArray: Array = manager.getArrayFor(string: "Interventions")
        var interventionChoices:[ORKTextChoice] = []
        for item in interventionArray {
            let textString = item
            let choice =    ORKTextChoice(text: textString, value:textString as NSCoding & NSCopying & NSObjectProtocol)
            interventionChoices.append(choice)
        }
        let choiceN =    ORKTextChoice(text: "None", value:"None" as NSCoding & NSCopying & NSObjectProtocol)
        interventionChoices.insert(choiceN, at: 0)
        let interventionsTextChoices = interventionChoices
        
        let interventionsAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .multipleChoice, textChoices: interventionsTextChoices)
        let formItemSymptomIntervention = ORKFormItem(identifier:"symptom_interventions", text: NSLocalizedString("Select interventions done, if any.", comment: ""), answerFormat: interventionsAnswerFormat)
        
        
        let formItemTextInterventions = NSLocalizedString("", comment: "")
        let formItemOtherInterventions = ORKFormItem(identifier: "other_interventions", text: formItemTextInterventions, answerFormat: ORKAnswerFormat.textAnswerFormat(withMaximumLength: 120))
        formItemOtherInterventions.placeholder = NSLocalizedString("4. Tap to specify other interventions", comment: "")
        formItemOtherInterventions.isOptional = true
        //formItemSleep.placeholder = NSLocalizedString("Enter number", comment: "")
        
        
        
        
        //RELIEF ////////// ////////// ////////// ////////// ////////// //////////
        let formItemSymptomsInterferenceSection = ORKFormItem(sectionTitle: " ") ////////// SECTION
        
        let symptomsInterferenceScaleAnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 5,
                                                                          minimumValue: 0,
                                                                          defaultValue: -1,
                                                                          step: 1,
                                                                          vertical: false,
                                                                          maximumValueDescription: NSLocalizedString("Quite a bit", comment: ""),
                                                                          minimumValueDescription: NSLocalizedString("Not at all", comment: ""))
        let formItemSymptomsInterference = ORKFormItem(identifier:"SymptomsInterference", text: NSLocalizedString("5. How much is this symptom interfering with your activities?", comment: ""), answerFormat: symptomsInterferenceScaleAnswerFormat)
        
        
        
        
        //NSLocalizedString("Did your symptoms interfere with your activities today?", comment: "")
        step.formItems = [
            
            formItemSymptomNameSection,
            formItemSymptomName,
            
            formItemSymptomIntensitySection,
            formItemSymptomIntensity,
            
            formItemSymptomStatusSection,
            formItemSymptomStatus,
            
            
            formInterventionSection,
            formItemSymptomIntervention,
            formItemOtherInterventions,
            
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

