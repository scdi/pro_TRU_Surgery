import CareKit
import ResearchKit

/**
 Struct that conforms to the `Assessment` protocol to define a back pain
 assessment.
 */
struct SCDPain: Assessment {
    // MARK: Activity
    
    let activityType: ActivityType = .scdPain
    
    func carePlanActivity() -> OCKCarePlanActivity {
        // Create a weekly schedule.
        let startDate = DateComponents(year: 2016, month: 01, day: 01)
        let schedule = OCKCareSchedule.weeklySchedule(withStartDate: startDate as DateComponents, occurrencesOnEachDay: [1, 1, 1, 1, 1, 1, 1])
        
        // Get the localized strings to use for the assessment.
        let title = NSLocalizedString("Sickle Cell Pain", comment: "")
        //        let summary = NSLocalizedString("Lower Back", comment: "")
        
        let activity = OCKCarePlanActivity.assessment(
            withIdentifier: activityType.rawValue,
            groupIdentifier: nil,
            title: title,
            text: "Tracker",
            tintColor: Colors.blue.color,
            resultResettable: true,
            schedule: schedule,
            userInfo: nil
        )
        
        return activity
    }
    
    // MARK: Assessment
    
    func task() -> ORKTask {
        
        var steps = [ORKStep]()
        let manager = ListDataManager()
        
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
        
        //TIME STAMP
        let eventTimeStampStep = ORKFormStep(identifier:"scdPain_eventTimeStamp", title: "Time", text: "")
        // A second field, for entering a time interval.
        let eventDateItemText = NSLocalizedString("What is the time you are reporting about?", comment: "")
        let eventDateItem = ORKFormItem(identifier:"scdPain_eventTimeStamp", text:eventDateItemText, answerFormat: ORKDateAnswerFormat.dateTime())
        eventDateItem.placeholder = NSLocalizedString("Tap to select", comment: "")
        eventTimeStampStep.formItems = [
            eventDateItem
        ]
        eventTimeStampStep.isOptional = false
        steps += [eventTimeStampStep]
        
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
        
        

        
        // Create an ordered task with a single question.
        let task = ORKOrderedTask(identifier: activityType.rawValue, steps: steps)
        
        return task
    }
}
