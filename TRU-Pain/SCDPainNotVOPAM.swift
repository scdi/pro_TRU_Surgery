//
//  SCDPainNotVOPAM.swift
//  TRU-Pain
//
//  Created by jonas002 on 9/28/17.
//  Copyright © 2017 scdi. All rights reserved.
//


import CareKit
import ResearchKit
import DefaultsKit
/**
 Struct that conforms to the `Assessment` protocol to define a back pain
 assessment.
 */
struct SCDPainNotVOPAM: Assessment {
    // MARK: Activity
    
    let activityType: ActivityType = .scdPainNotVOPAM
    
    func carePlanActivity() -> OCKCarePlanActivity {
        // Create a weekly schedule.
        let startDate = DateComponents(year: 2016, month: 01, day: 01)
        let schedule = OCKCareSchedule.weeklySchedule(withStartDate: startDate as DateComponents, occurrencesOnEachDay: [1, 1, 1, 1, 1, 1, 1])
        
        // Get the localized strings to use for the assessment.
        let title = NSLocalizedString("Sickle Cell Pain", comment: "")
        //        let summary = NSLocalizedString("Lower Back", comment: "")
        
        let activity = OCKCarePlanActivity.assessment(withIdentifier: activityType.rawValue, groupIdentifier: nil, title: title, text: "Tracker", tintColor: Colors.blue.color, resultResettable: true, schedule: schedule, userInfo: nil, optional: false)
        
        
        
        return activity
    }
    
    // MARK: Assessment
    
    func task() -> ORKTask {
        
        var steps = [ORKStep]()
        let manager = ListDataManager()
        let defaults = Defaults.shared
         
        let key = Key<String>("PainType")
        defaults.set("SCDPain", for: key)
        
        //1.    Are you experiencing pain today? y/n
        let notVOPAMPainQuestionStepTitle = "Are you experiencing pain today?"
        let notVOPAMPainAnswerFormat = ORKBooleanAnswerFormat()
        let notVOPAMPainQuestionStep = ORKQuestionStep(identifier: "notVOPAMPainIdentifier", title: notVOPAMPainQuestionStepTitle, answer: notVOPAMPainAnswerFormat)
        notVOPAMPainQuestionStep.isOptional = false
        steps += [notVOPAMPainQuestionStep]
        
        let scdPainQuestionStepTitle = "Are you experiencing sickle cell pain?"
        let scdPainAnswerFormat = ORKBooleanAnswerFormat()
        let scdPainQuestionStep = ORKQuestionStep(identifier: "scdPainIdentifier", title: scdPainQuestionStepTitle, answer: scdPainAnswerFormat)
        scdPainQuestionStep.isOptional = false
        steps += [scdPainQuestionStep]
        
        
        //SCD Pain Experience
        let scdPainExperienceQuestionStepTitle = "Compare to your usual sickle cell pain, how is this one?"
        let scdPainExperienceTextChoices = [
            ORKTextChoice(text: "Yes, I have sickle cell pain", value: "Less" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "No, I have a different type of pain", value: "Same" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "I have both sickle cell pain and non-sickle cell pain", value: "Better" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "I’m not sure which type of pain I am experiencing", value: "Crisis" as NSCoding & NSCopying & NSObjectProtocol),
            ]
        
        let scdPainExperienceAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: scdPainExperienceTextChoices)
        let scdPainExperienceQuestionStep = ORKQuestionStep(identifier: "scdPainExperienceIdentifier", title: scdPainExperienceQuestionStepTitle, answer: scdPainExperienceAnswerFormat)
        scdPainExperienceQuestionStep.isOptional = false
        steps += [scdPainExperienceQuestionStep]
        
        
        
        
        // Get the localized strings to use for the task.
        let question = NSLocalizedString("Rate your sickle cell pain?", comment: "")
        let maximumValueDescription = NSLocalizedString("Worst ever", comment: "")
        let minimumValueDescription = NSLocalizedString("None", comment: "")
        
        // Create a question and answer format.
        let answerFormat = ORKAnswerFormat.continuousScale(
            withMaximumValue: 10.0,
            minimumValue: 0.0,
            defaultValue: -1,
            maximumFractionDigits: 1,
            vertical: false,
            maximumValueDescription: maximumValueDescription,
            minimumValueDescription: minimumValueDescription
        )
        
        let questionStep = ORKQuestionStep(identifier: activityType.rawValue, title: question, answer: answerFormat)
        questionStep.isOptional = false
        steps += [questionStep]
        

        //Affected body locations
        let bodyLocationArray: Array = manager.getArrayFor(string: "Body Locations")
        var bodyLocationChoices:[ORKTextChoice] = []
        for item in bodyLocationArray {
            let textString = item
            let choice =    ORKTextChoice(text: textString, value:textString as NSCoding & NSCopying & NSObjectProtocol)
            bodyLocationChoices.append(choice)
        }
        
        let choiceM =    ORKTextChoice(text: "None", value:"None" as NSCoding & NSCopying & NSObjectProtocol)
        bodyLocationChoices.insert(choiceM, at: 0)
        
        let bodyLocationQuestionStepTitle = "Affected body locations?"
        let bodyLocationTextChoices = bodyLocationChoices
        let bodyLocationAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .multipleChoice, textChoices: bodyLocationTextChoices)
        let bodyLocationQuestionStep = ORKQuestionStep(identifier: "scdPain_affected_body_locations", title: bodyLocationQuestionStepTitle, answer: bodyLocationAnswerFormat)
        bodyLocationQuestionStep.isOptional = false
        steps += [bodyLocationQuestionStep]
        
        
        //Symptom Status
        let symptomStatusQuestionStepTitle = "Compare to your usual sickle cell pain, how is this one?"
        let symptomStatusTextChoices = [
            ORKTextChoice(text: "Less", value: "Less" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Same", value: "Same" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Worse", value: "Better" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Crisis", value: "Crisis" as NSCoding & NSCopying & NSObjectProtocol),
            ]
        
        let symptomStatusAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: symptomStatusTextChoices)
        let symptomStatusQuestionStep = ORKQuestionStep(identifier: "scdPain_status", title: symptomStatusQuestionStepTitle, answer: symptomStatusAnswerFormat)
        symptomStatusQuestionStep.isOptional = false
        steps += [symptomStatusQuestionStep]
        
        let spottingQuestionStepTitle = "Are you having non-sickle cell pain?"
        let spottingTextChoices = [
            ORKTextChoice(text: "No", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Yes", value: 1 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        let spottingAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: spottingTextChoices)
        let spottingQuestionStep = ORKQuestionStep(identifier: "nonscdPain", title: spottingQuestionStepTitle, answer: spottingAnswerFormat)
        spottingQuestionStep.isOptional = false
        steps += [spottingQuestionStep]
        
        //PAIN DIFFERENCE
        //“Can you tell the difference between your sickle cell pain and your menstrual pain?”
        let scdPainDiffQuestionStepTitle = "Can you tell the difference between your sickle cell pain and your menstrual pain?"
        let scdPainDiffTextChoices = [
            ORKTextChoice(text: "No", value: "No" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Yes", value: "Yes" as NSCoding & NSCopying & NSObjectProtocol)
            
        ]
        let scdPainDiffAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: scdPainDiffTextChoices)
        let scdPainDiffQuestionStep = ORKQuestionStep(identifier: "differentiatesPain", title: scdPainDiffQuestionStepTitle, answer: scdPainDiffAnswerFormat)
        scdPainDiffQuestionStep.isOptional = false
        steps += [scdPainDiffQuestionStep]
        
        //PAIN DIFFERENCE 2
        //“Can you tell the difference between your sickle cell pain and your menstrual pain?”
        let scdPainDiff2QuestionStepTitle = "Is the sickle cell pain that you experience during your menstrual period the same as the sickle cell pain that you experience when you don’t have your menstrual period?"
        let scdPainDiff2TextChoices = [
            ORKTextChoice(text: "No", value: "No" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Yes", value: "Yes" as NSCoding & NSCopying & NSObjectProtocol)
            
        ]
        let scdPainDiff2AnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: scdPainDiff2TextChoices)
        let scdPainDiff2QuestionStep = ORKQuestionStep(identifier: "differentiatesSCDPainCharacter", title: scdPainDiff2QuestionStepTitle, answer: scdPainDiff2AnswerFormat)
        scdPainDiff2QuestionStep.isOptional = false
        steps += [scdPainDiffQuestionStep]
        
        // Create an ordered task with a single question.
        let task = ORKOrderedTask(identifier: activityType.rawValue, steps: steps)
        
        return task
    }
}
