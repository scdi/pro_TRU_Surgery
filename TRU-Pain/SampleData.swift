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

import ResearchKit
import CareKit

//struct MyClassConstants{
//    static let testStr = "test"
//    static let arrayOfTests: [String] = ["foo", "bar", testStr]
//}

class SampleData: NSObject {
    
    // MARK: Properties
    var activities:[Activity] = []
    
    /// An array of `Activity`s used in the app.
    let activitiesBMT: [Activity] = [
        OutdoorWalk(),
        TakeSleep(),
        EatDinner(),      //Main Meals only
        EatSnack(),
        SymptomFocus(),
        Appetite(),
        BackPain(),         //GENERAL HEALTH
        Temperature(),      //Chronic Pain or just Pain
        Stool()            //Normal and Diarrhea
    ]
    
    /// An array of `Activity`s used in the app.
    let activitiesSCD: [Activity] = [
        OutdoorWalk(),
        TakeSleep(),
        EatDinner(),        //Main Meals
        EatSnack(),
        SymptomFocus(),
        Appetite(),
        SCDPain(),
        BackPain() //GENERAL HEALTH
    ]
    
    /// An array of `Activity`s used in the app.
    let activitiesSCDVOPAM: [Activity] = [
        OutdoorWalk(),
        TakeSleep(),
        EatDinner(),        //Main Meals
        EatSnack(),
        MenstruationSCD(), // Spotting(),Menstruating(),Menstruation(),AbdominalCramp(), //PainDifferentiation(),
        SymptomFocus(),
        Appetite(),
        SCDPain(),
        BackPain()         //GeneralHealth
    ]
    
    /// An array of `Activity`s used in the app.
    let activitiesVOPAM: [Activity] = [
        OutdoorWalk(),
        TakeSleep(),
        EatDinner(),        //Main Meals
        EatSnack(),
        Menstruation(), // Spotting(),Menstruating(),Menstruation(),AbdominalCramp(), //PainDifferentiation(),
        SymptomFocus(),
        Appetite(),
        SCDPain(),
        BackPain()         //GeneralHealth
        ]

    /**
        An array of `OCKContact`s to display on the Connect view.
    */
    
    
    let contacts: [OCKContact] = [
        OCKContact(contactType: .careTeam,
                   name: "Medical Emergency",
                   relation: "call 911",
                   contactInfoItems:[.phone("911")],
                   tintColor: Colors.blue.color,
                   monogram: "ER",
                   image: UIImage(named: "ER.jpg")),
        
        OCKContact(contactType: .careTeam,
                   name: "Kristi Romero",
                   relation: "Study Coordinator",
                   contactInfoItems:[.phone("919-684-1352"), .email("studycoordinator@icloud.com")],
                   tintColor: Colors.lightBlue.color,
                   monogram: "SC",
                   image: UIImage(named: "studyCoordinator.png")),
        
        OCKContact(contactType: .careTeam,
                   name: "ABMT",
                   relation: "Clinic (M-F 8-6 and S/S 8-4)",
                   contactInfoItems:[.phone("919-668-6547"), .phone("919-668-6548")],
                   tintColor: Colors.yellow.color,
                   monogram: nil,
                   image: UIImage(named: "ABMTclinic.png")),
        
        OCKContact(contactType: .careTeam,
                   name: "Patient Care Unit",
                   relation: "9200 (open M-F 8a-5p)",
                   contactInfoItems:[.phone("919-681-9241")],
                   tintColor: Colors.yellow.color,
                   monogram: nil,
                   image: UIImage(named: "patientCareUnit.jpg"))
    ]
    
    let contactsVanderbiltVOPAM: [OCKContact] = [
        OCKContact(contactType: .careTeam,
                   name: "Medical Emergency",
                   relation: "call 911",
                   contactInfoItems:[.phone("911")],
                   tintColor: Colors.blue.color,
                   monogram: "ER",
                   image: UIImage(named: "ER.jpg")),
        
        OCKContact(contactType: .careTeam,
                   name: "Sarah-Jo Stimpson, MD",
                   relation: "Study Coordinator",
                   contactInfoItems:[.phone("615-669-9323"), .email("sarah-jo.stimpson@vanderbilt.edu")],
                   tintColor: Colors.lightBlue.color,
                   monogram: "SC",
                   image: UIImage(named: "sarah-jo.jpg")),
        
        OCKContact(contactType: .careTeam,
                   name: "Melissa Day",
                   relation: "Study Coordinator",
                   contactInfoItems:[.phone("615-200-8550"), .email("melissa.e.day@vanderbilt.edu")],
                   tintColor: Colors.lightBlue.color,
                   monogram: "SC",
                   image: UIImage(named: "crc2VopamVanderbilt.png")),
        
        OCKContact(contactType: .careTeam,
                   name: "Deva Sharma, MD",
                   relation: "Study Coordinator",
                   contactInfoItems:[.phone("615-669-3498"), .email("deva.sharma@vanderbilt.edu")],
                   tintColor: Colors.lightBlue.color,
                   monogram: "SC",
                   image: UIImage(named: "crc3VopamVanderbilt.png")),
        
        
        OCKContact(contactType: .careTeam,
                   name: "Sickle Cell Center",
                   relation: "Meharry-Matthew Walker-Vanderbilt Center for Excellence in Sickle Cell Disease",
                   contactInfoItems:[.phone("615-936-1762")],
                   tintColor: Colors.yellow.color,
                   monogram: nil,
                   image: UIImage(named: "walker_clinic_120.jpg"))
        
    ]
    
    let contactsDukeSCD: [OCKContact] = [
        OCKContact(contactType: .careTeam,
                   name: "Medical Emergency",
                   relation: "call 911",
                   contactInfoItems:[.phone("911")],
                   tintColor: Colors.blue.color,
                   monogram: "ER",
                   image: UIImage(named: "ER.jpg")),
        
        OCKContact(contactType: .careTeam,
                   name: "Nirmish Shah, MD",
                   relation: "Study Coordinator",
                   contactInfoItems:[.phone("919-684-1352"), .email("nirmish.shah@duke.edu")],
                   tintColor: Colors.lightBlue.color,
                   monogram: "SC",
                   image: UIImage(named: "nirmish.shah.jpg")),
        
        OCKContact(contactType: .careTeam,
                   name: "Sheila Lambert-Adams",
                   relation: "Study Coordinator",
                   contactInfoItems:[.phone("919-684-8111"), .email("sheila.lambertadams@dm.duke.edu")],
                   tintColor: Colors.lightBlue.color,
                   monogram: "SC",
                   image: nil),
        
        OCKContact(contactType: .careTeam,
                   name: "Adult Clinic",
                   relation: "Clinic (Mon-Fri 7:30 a.m.-4:00 p.m.)",
                   contactInfoItems:[.phone("919-684-6464"), .phone("919-620-8999")],
                   tintColor: Colors.yellow.color,
                   monogram: nil,
                   image: UIImage(named: "SSlogoforbottom.jpg")),
        
    ]
    
    let contactsDukeBMT: [OCKContact] = [//
        OCKContact(contactType: .careTeam,
                   name: "Medical Emergency",
                   relation: "call 911",
                   contactInfoItems:[.phone("911")],
                   tintColor: Colors.blue.color,
                   monogram: "ER",
                   image: UIImage(named: "ER.jpg")),
        
        OCKContact(contactType: .careTeam,
                   name: "Kristi Romero",
                   relation: "Study Coordinator",
                   contactInfoItems:[.phone("919-684-1352"), .email("studycoordinator@icloud.com")],
                   tintColor: Colors.lightBlue.color,
                   monogram: "SC",
                   image: UIImage(named: "studyCoordinator.png")),
        
        OCKContact(contactType: .careTeam,
                   name: "ABMT",
                   relation: "Clinic (M-F 8-6 and S/S 8-4)",
                   contactInfoItems:[.phone("919-668-6547"), .phone("919-668-6548")],
                   tintColor: Colors.yellow.color,
                   monogram: nil,
                   image: UIImage(named: "ABMTclinic.png")),
        
        OCKContact(contactType: .careTeam,
                   name: "Patient Care Unit",
                   relation: "9200 (open M-F 8a-5p)",
                   contactInfoItems:[.phone("919-681-9241")],
                   tintColor: Colors.yellow.color,
                   monogram: nil,
                   image: UIImage(named: "patientCareUnit.jpg"))
    ]

    
    // MARK: Initialization
    
    required init(carePlanStore: OCKCarePlanStore) {
        super.init()
        
        activities = activitiesVOPAM
        
        // Populate the store with the sample activities.
        for sampleActivity in activities {
            let carePlanActivity = sampleActivity.carePlanActivity()
            
            carePlanStore.add(carePlanActivity) { success, error in
                if !success {
                    print(error?.localizedDescription ?? "XCODE error")
                }
            }
        }
//        let keychain = KeychainSwift()
//        let studyName = keychain.get("Study")
//        let studySite = keychain.get("Institution")
        
        
        
        
        
        /*
        let study = "scdvopam"
        
        if study == "vopam" {
            activities = activitiesVOPAM
            
            // Populate the store with the sample activities.
            for sampleActivity in activities {
                let carePlanActivity = sampleActivity.carePlanActivity()
                
                carePlanStore.add(carePlanActivity) { success, error in
                    if !success {
                        print(error?.localizedDescription ?? "XCODE error")
                    }
                }
            }
        }
        if study == "scdvopam" {
            activities = activitiesSCDVOPAM
            
            // Populate the store with the sample activities.
            for sampleActivity in activities {
                let carePlanActivity = sampleActivity.carePlanActivity()
                
                carePlanStore.add(carePlanActivity) { success, error in
                    if !success {
                        print(error?.localizedDescription ?? "XCODE error")
                    }
                }
            }
        }

        else if study == "scd" {
            activities = activitiesSCD
            
            // Populate the store with the sample activities.
            for sampleActivity in activities {
                let carePlanActivity = sampleActivity.carePlanActivity()
                
                carePlanStore.add(carePlanActivity) { success, error in
                    if !success {
                        print(error?.localizedDescription ?? "XCODE error")
                    }
                }
            }
            
        }
        else {
            activities = activitiesBMT
            
            // Populate the store with the sample activities.
            for sampleActivity in activities {
                let carePlanActivity = sampleActivity.carePlanActivity()
                
                carePlanStore.add(carePlanActivity) { success, error in
                    if !success {
                        print(error?.localizedDescription ?? "XCODE error")
                    }
                }
            }
        }*/

        
    }
    
    // MARK: Convenience
    
    /// Returns the `Activity` that matches the supplied `ActivityType`.
    func activityWithType(_ type: ActivityType) -> Activity? {
       

            activities = activitiesVOPAM
            
            for activity in activities where activity.activityType == type {
                return activity
            }

        
        
        return nil
    }
    
    
    func generateSampleDocument() -> OCKDocument {
        let subtitle = OCKDocumentElementSubtitle(subtitle: "First subtitle")
        
        let paragraph = OCKDocumentElementParagraph(content: "Lorem ipsum dolor sit amet, vim primis noster sententiae ne, et albucius apeirian accusata mea, vim at dicunt laoreet. Eu probo omnes inimicus ius, duo at veritus alienum. Nostrud facilisi id pro. Putant oporteat id eos. Admodum antiopam mel in, at per everti quaeque. Lorem ipsum dolor sit amet, vim primis noster sententiae ne, et albucius apeirian accusata mea, vim at dicunt laoreet. Eu probo omnes inimicus ius, duo at veritus alienum. Nostrud facilisi id pro. Putant oporteat id eos. Admodum antiopam mel in, at per everti quaeque. Lorem ipsum dolor sit amet, vim primis noster sententiae ne, et albucius apeirian accusata mea, vim at dicunt laoreet. Eu probo omnes inimicus ius, duo at veritus alienum. Nostrud facilisi id pro. Putant oporteat id eos. Admodum antiopam mel in, at per everti quaeque.")
            
        let document = OCKDocument(title: "Sample Document Title", elements: [subtitle, paragraph])
        document.pageHeader = "App Name: OCKSample, User Name: John Appleseed"
        
        return document
    }
    

}
/*
 extension SampleData {
    func generateDocumentWith(chart: OCKChart?) -> OCKDocument {
        let intro = OCKDocumentElementParagraph(content: "I've been tracking my efforts to avoid becoming a Zombie with ZombieKit. Please check the attached report to see if you're safe around me.")
        
        var documentElements: [OCKDocumentElement] = [intro]
        if let chart = chart {
            documentElements.append(OCKDocumentElementChart(chart: chart))
        }
        
        let document = OCKDocument(title: "Re: Your Brains", elements: documentElements)
        document.pageHeader = "ZombieKit: Weekly Report"
        
        return document
    }
}
*/
extension SampleData {
    func generateDocumentWith(chart: OCKChart?) -> OCKDocument {
        let intro = OCKDocumentElementParagraph(content: "I would like to share with you the progress I have been making this past days.")
        
        var documentElements: [OCKDocumentElement] = [intro]
        
            documentElements.append(OCKDocumentElementChart(chart: chart!))
        
        
        let document = OCKDocument(title: "My Health Progress", elements: documentElements)
        document.pageHeader = "Weekly Report"
        
        
        return document
    }
}

