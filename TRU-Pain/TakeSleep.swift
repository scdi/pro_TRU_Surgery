//
//  TakeSleep.swift
//  TRU-Care
//
//  Created by scdi on 6/4/16.
//  Copyright © 2016 scdi. All rights reserved.
//

import CareKit

/**
 Struct that conforms to the `Activity` protocol to define an activity to take
 medication.
 */
struct TakeSleep: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .takeSleep
    
    func carePlanActivity() -> OCKCarePlanActivity {
        // Create a weekly schedule.
        let startDate = NSDateComponents(year: 2017, month: 01, day: 01)
        let schedule = OCKCareSchedule.weeklySchedule(withStartDate: startDate as DateComponents, occurrencesOnEachDay: [4,4,4,4,4,4,4])
        
        // Get the localized strings to use for the activity.
        let title = NSLocalizedString("Sleep", comment: "")
        let summary = NSLocalizedString("One circle per 2 hours of sleep", comment: "")
        let instructions = NSLocalizedString("Attempt to get adequate amount of sleep each day. About eight hours is recommended", comment: "")
        
        let activity = OCKCarePlanActivity.intervention(
            withIdentifier: activityType.rawValue,
            groupIdentifier: nil,
            title: title,
            text: summary,
            tintColor: Colors.blue.color,
            instructions: instructions,
            imageURL: nil,
            schedule: schedule,
            userInfo: nil
        )
        
        return activity
    }
}
