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

import UIKit
import CareKit
import ResearchKit
//import WatchConnectivity
import CoreData
import Alamofire
import Foundation
import CoreLocation
import UserNotifications
import DefaultsKit


//enum ReadDataExceptions : Error {
//    case moreThanOneRecordCameBack
//}


class RootViewController: UITabBarController {
    // MARK: Properties
    
    
    
    fileprivate let sampleData: SampleData
    //fileprivate let vopamData: VOPAMSampleData //VOPAM:
    
    fileprivate let storeManager = CarePlanStoreManager.sharedCarePlanStoreManager
    
    fileprivate var careCardViewController: OCKCareCardViewController!
    
    //VOPAM:
    //fileprivate var vopamCardViewController: OCKCareCardViewController!
    
    fileprivate var symptomTrackerViewController: OCKSymptomTrackerViewController!
    
    fileprivate var insightsViewController: OCKInsightsViewController!
    
    fileprivate var connectViewController: OCKConnectViewController!
    
    //fileprivate var watchManager: WatchConnectivityManager?
    
    private var videoRecordingViewController:UIViewController!
    private var locationViewController:UIViewController!
    private let dataManager = DataManager(baseURL: API.AuthenticatedBaseURL)
    
    //add:report
    fileprivate var insightChart: OCKBarChart? = nil
    
    
    var container: NSPersistentContainer!
    var isFirstUpdate:Bool = false //CORE LOCATION
    var taskUUID: UUID?
    let listDataManager = ListDataManager()
    
    
    public lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    // MARK: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        sampleData = SampleData(carePlanStore: storeManager.store)
        
        
        super.init(coder: aDecoder)
        
        /*
         var geo: [DGeoData]!
         geo = DGeoData.mr_findAll() as! [DGeoData]
         if geo.count > 0 {
         for (index, element) in geo.enumerated() {
         print("item geo: \(element.taskUUID)) \(index):\(element)")
         }
         }
         
         var symptoms: [DSymptomFocus]!
         symptoms = DSymptomFocus.mr_findAll() as! [DSymptomFocus]
         if symptoms.count > 0 {
         for (index, element) in symptoms.enumerated() {
         print("item: \(element.name)) \(index):\(element)")
         }
         }
         */
        
        
        /*
         var health: [DGeneralHealth]!
         health = DGeneralHealth.mr_findAll() as! [DGeneralHealth]
         if health.count > 0 {
         for (index, element) in health.enumerated() {
         print("item: \(element.taskRunUUID)) \(index):\(element)")
         }
         }
         var stool: [DStool]!
         stool = DStool.mr_findAll() as! [DStool]
         if stool.count > 0 {
         for (index, element) in stool.enumerated() {
         print("item: \(element.taskRunUUID)) \(index):\(element)")
         }
         }
         var temperature: [DTemperature]!
         temperature = DTemperature.mr_findAll() as! [DTemperature]
         if temperature.count > 0 {
         for (index, element) in temperature.enumerated() {
         print("item: \(element.taskRunUUID)) \(index):\(element)")
         }
         }
         */
        //self.viewSymptoms()
        //self.findCurrentLocation(taskID: "viewLoad") //CORE LOCATION
//        let keychain = KeychainSwift()
//        
//        let defaults = UserDefaults()
//        defaults.setValue("NO", forKey: "hasPasswordForProfile")
        
        
        let defaults = UserDefaults()
        defaults.setValue("NO", forKey: "hasPasswordForProfile")
        
        
        careCardViewController = createCareCardViewController()
        symptomTrackerViewController = createSymptomTrackerViewController()
        insightsViewController = createInsightsViewController()
        connectViewController = createConnectViewController()
        
        
        self.viewControllers = [
            UINavigationController(rootViewController: careCardViewController),
            UINavigationController(rootViewController: symptomTrackerViewController),
            UINavigationController(rootViewController: insightsViewController),
            UINavigationController(rootViewController: connectViewController),
            
        ]
        storeManager.delegate = self
        //watchManager = WatchConnectivityManager(withStore: storeManager.store)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.gray], for: .normal)
        
        
    }
    
    // MARK: Convenience
    private func createVideoRecordingViewController() -> UIViewController {
        let vc = UIStoryboard(name: "MainStoryboard", bundle: nil)
        let viewController = vc.instantiateViewController(withIdentifier: "videoRecorderViewControllerSB")
        let homeUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear.png"), style: .plain, target: self, action: #selector(RootViewController.toHome))
        viewController.navigationItem.leftBarButtonItem  = homeUIBarButtonItem
        homeUIBarButtonItem.tintColor = Colors.careKitRed.color
        // Setup the controller's title and tab bar item
        viewController.title = NSLocalizedString("Media", comment: "")
        viewController.tabBarItem = UITabBarItem(title: viewController.title, image: UIImage(named:"film-clap-board"), selectedImage: UIImage(named: "film-clap-board"))
        
        return viewController
    }
    
    private func createLocationViewController() -> UIViewController {
        let vc = UIStoryboard(name: "MainStoryboard", bundle: nil)
        let viewController = vc.instantiateViewController(withIdentifier: "locationStoryBoard")
        let homeUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear.png"), style: .plain, target: self, action: #selector(RootViewController.toHome))
        viewController.navigationItem.leftBarButtonItem  = homeUIBarButtonItem
        homeUIBarButtonItem.tintColor = Colors.careKitRed.color
        // Setup the controller's title and tab bar item
        viewController.title = NSLocalizedString("Location", comment: "")
        viewController.tabBarItem = UITabBarItem(title: viewController.title, image: UIImage(named:"video"), selectedImage: UIImage(named: "video"))
        
        return viewController
    }
    
    
    fileprivate func createCareCardViewController() -> OCKCareCardViewController {
        let viewController = OCKCareCardViewController(carePlanStore: storeManager.store)
        let homeUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear.png"), style: .plain, target: self, action: #selector(RootViewController.toHome))
        viewController.navigationItem.leftBarButtonItem  = homeUIBarButtonItem
        //viewController.maskImageTintColor = Colors.careKitRed.color
        homeUIBarButtonItem.tintColor = Colors.careKitRed.color
        // Setup the controller's title and tab bar item
        viewController.title = NSLocalizedString("Health", comment: "")
//        viewController.isSorted = false
//        viewController.isGrouped = false
        
        viewController.tabBarItem = UITabBarItem(title: viewController.title, image: UIImage(named:"carecard"), selectedImage: UIImage(named: "carecard-filled"))
        
        return viewController
    }
    
    fileprivate func createVOPAMCardViewController() -> OCKCareCardViewController {
        let viewController = OCKCareCardViewController(carePlanStore: storeManager.store)
        let homeUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear.png"), style: .plain, target: self, action: #selector(RootViewController.toHome))
        viewController.navigationItem.leftBarButtonItem  = homeUIBarButtonItem
        //viewController.maskImageTintColor = Colors.careKitRed.color
        homeUIBarButtonItem.tintColor = Colors.careKitRed.color
        // Setup the controller's title and tab bar item
        viewController.title = NSLocalizedString("VOPAM", comment: "")
        
        viewController.tabBarItem = UITabBarItem(title: viewController.title, image: UIImage(named:"carecard"), selectedImage: UIImage(named: "carecard-filled"))
        
        return viewController
    }
    
    
    fileprivate func createSymptomTrackerViewController() -> OCKSymptomTrackerViewController {
        let viewController = OCKSymptomTrackerViewController(carePlanStore: storeManager.store)
        viewController.delegate = self
        let homeUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear.png"), style: .plain, target: self, action: #selector(RootViewController.toHome))
        viewController.navigationItem.leftBarButtonItem  = homeUIBarButtonItem
        homeUIBarButtonItem.tintColor = Colors.careKitRed.color
        //viewController.progressRingTintColor = Colors.careKitRed.color
        viewController.navigationItem.rightBarButtonItem?.tintColor = Colors.careKitRed.color
        
        // Setup the controller's title and tab bar item
        viewController.title = NSLocalizedString("Symptoms", comment: "")
        viewController.tabBarItem = UITabBarItem(title: viewController.title, image: UIImage(named:"symptoms"), selectedImage: UIImage(named: "symptoms-filled"))
//        viewController.isSorted = false
//        viewController.isGrouped = false
        return viewController
    }
    
    
    fileprivate func createConnectViewController() -> OCKConnectViewController {
        
        let defaults = UserDefaults.standard
        let studyName = defaults.value(forKey: "Study") as? String
        //let studySite = defaults.get("Institution")
        
//        let study = (studySite?.lowercased())!+(studyName?.lowercased())!
        let study = studyName?.lowercased()
        
        var contacts = [OCKContact]()
        print("CONTACT TO CHOOSE \(study)")
        contacts = sampleData.contactsDukeBMT
        
        
        print("CONTACTS chosen \(contacts)")
        let viewController = OCKConnectViewController(contacts:contacts)
        viewController.delegate = self
        let homeUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear.png"), style: .plain, target: self, action: #selector(RootViewController.toHome))
        viewController.navigationItem.leftBarButtonItem  = homeUIBarButtonItem
        homeUIBarButtonItem.tintColor = Colors.careKitRed.color
        // Setup the controller's title and tab bar item
        viewController.title = NSLocalizedString("Connect", comment: "")
        viewController.tabBarItem = UITabBarItem(title: viewController.title, image: UIImage(named:"connect"), selectedImage: UIImage(named: "connect-filled"))
        //        self.highlightIcon()
        return viewController
    }
    
    
    fileprivate func createInsightsViewController() -> OCKInsightsViewController {
        // Create an `OCKInsightsViewController` with sample data.
        //let headerTitle = NSLocalizedString("Chart", comment: "")
        //let viewController = OCKInsightsViewController(insightItems: storeManager.insights, headerTitle: headerTitle, headerSubtitle: "")
        
        let activityType1: ActivityType = .generalHealth
        let widget1 = OCKPatientWidget.defaultWidget(withActivityIdentifier: activityType1.rawValue, tintColor: OCKColor.red)
        let viewController = OCKInsightsViewController(insightItems: storeManager.insights, patientWidgets: [widget1], thresholds: [activityType1.rawValue], store:storeManager.store)
        
        let homeUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear.png"), style: .plain, target: self, action: #selector(RootViewController.toHome))
        viewController.navigationItem.leftBarButtonItem  = homeUIBarButtonItem
        
        homeUIBarButtonItem.tintColor = Colors.careKitRed.color
        // Setup the controller's title and tab bar item
        viewController.title = NSLocalizedString("Insights", comment: "")
        viewController.tabBarItem = UITabBarItem(title: viewController.title, image: UIImage(named:"insights"), selectedImage: UIImage(named: "insights-filled"))
        print("storemanager insight \(storeManager.insights)")
        return viewController
    }
    
    
    func highlightIcon()  {
        self.selectedIndex = 0
        
        self.tabBar.selectedItem = tabBar.items![1]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        print("0")
        
    }
    
    func toHome() -> () {
        performSegue(withIdentifier: "ckReturnHome", sender: nil)
        
        //MagicalRecord.save({ (context) in  })
        
    }
    
}



extension RootViewController: OCKSymptomTrackerViewControllerDelegate {
    
    /// Called when the user taps an assessment on the `OCKSymptomTrackerViewController`.
    func symptomTrackerViewController(_ viewController: OCKSymptomTrackerViewController, didSelectRowWithAssessmentEvent assessmentEvent: OCKCarePlanEvent) {
        // Lookup the assessment the row represents.
        guard let activityType = ActivityType(rawValue: assessmentEvent.activity.identifier) else { return }
        guard let sampleAssessment = sampleData.activityWithType(activityType) as? Assessment else { return }
        
        /*
         Check if we should show a task for the selected assessment event
         based on its state.
         */
        guard assessmentEvent.state == .initial ||
            assessmentEvent.state == .notCompleted ||
            (assessmentEvent.state == .completed && assessmentEvent.activity.resultResettable) else { return }
        
        // Show an `ORKTaskViewController` for the assessment's task.
        let taskViewController = ORKTaskViewController(task: sampleAssessment.task(), taskRun: nil)
        taskViewController.delegate = self
        
        present(taskViewController, animated: true, completion: nil)
    }
}



extension RootViewController: ORKTaskViewControllerDelegate {
    
    func getContext () -> NSManagedObjectContext {
        let context = NSManagedObjectContext.default()
        return context!
    }
    
    
    //
    //    func saveContext() throws{
    //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //        let context = appDelegate.persistentContainer.viewContext
    //        if context.hasChanges {
    //            try context.save()
    //        }
    //    }
    
    //    func viewSymptoms()  {
    //        // Initialize Fetch Request
    //        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
    //
    //        // Create Entity Description
    //        let entityDescription = NSEntityDescription.entity(forEntityName: "CKSymptom", in: getContext())
    //
    //        // Configure Fetch Request
    //        fetchRequest.entity = entityDescription
    //
    //        do {
    //            let result = try getContext().fetch(fetchRequest)
    //            print(result)
    //
    //        } catch {
    //            let fetchError = error as NSError
    //            print(fetchError)
    //        }
    //        do {
    //            let result = try getContext().fetch(fetchRequest)
    //
    //            if (result.count > 0) {
    //                let person = result[0] as! NSManagedObject
    //
    //                print("1 - \(person)")
    //
    //                if let first = person.value(forKey: "status"), let last = person.value(forKey: "triggers") {
    //                    print("\(first) \(last)")
    //                }
    //
    //                print("2 - \(person)")
    //            }
    //
    //        } catch {
    //            let fetchError = error as NSError
    //            print(fetchError)
    //        }
    //
    //
    //
    //        var symptoms = [SymptomInFocus]()
    //        symptoms = SymptomInFocus.mr_findAll() as! [SymptomInFocus]
    //        print("those are my symptoms \(symptoms)")
    //
    //}
    
    
    
    //CORE LOCATION
    func findCurrentLocation(taskID:String) {
        self.isFirstUpdate = true;
        locationManager.startUpdatingLocation()
        print("finding current location")
        print("finding current location \(taskID)")
    }
    
    
    /// Called with then user completes a presented `ORKTaskViewController`.
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "yyyyMMdd"
        
        let dateFormatterForsubtitution = DateFormatter()
        dateFormatterForsubtitution.dateFormat = "yyyy-MM-dd"
        
        
        // Make sure the reason the task controller finished is that it was completed.
        guard reason == .completed else { return }
        
        
        guard let event = symptomTrackerViewController.lastSelectedAssessmentEvent,
            let activityType = ActivityType(rawValue: event.activity.identifier),
            let sampleAssessment = sampleData.activityWithType(activityType) as? Assessment else { return }
        _ = sampleAssessment.buildResultForCarePlanEvent(event, taskResult: taskViewController.result)
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)
        let components = event.date
        let date = calendar?.date(from: components)
        
        var newDateString:String = ""
        newDateString = dateFormatterForsubtitution.string(from: date!)
        print("newDateString 463: \(newDateString)")
        
        
        if let results = taskViewController.result.results as? [ORKStepResult] {
            
            //yyyy-MM-dd'T'HH:mm:ssZ -- 2016-12-10T18:58:03-0500
            
            //Start SymptomFocus
            if taskViewController.result.identifier == "symptomTracker" {
                var dSymptomFocus:DSymptomFocus!
                let keychain = KeychainSwift()
                dSymptomFocus = listDataManager.createSymptomFocus(entityName: "DSymptomFocus")
                
                if let username = keychain.get("username_TRU-BLOOD") {
                    dSymptomFocus.participantID =  username
                }
                dSymptomFocus.taskRunUUID = String(describing: taskViewController.result.taskRunUUID as UUID)
                dSymptomFocus.timestamp = taskViewController.result.endDate as NSDate?
                dSymptomFocus.timestampString = formatter.string(from: taskViewController.result.endDate)
                dSymptomFocus.timestampEnd = taskViewController.result.endDate as NSDate?
                dSymptomFocus.timestampEndString = formatter.string(from: taskViewController.result.endDate)
                dSymptomFocus.dayString = dayFormatter.string(from: date!)
                
                print("we have focus symptom focus")
                for stepResult: ORKStepResult in results {
                    print(stepResult.startDate)
                    print(stepResult.endDate)
                    print(stepResult.identifier)
                    
                    for result in stepResult.results! {
                        print("----- > triggers result identifier, start date and end date \n")
                        print(result.identifier)
                        print(result.startDate)
                        print(result.endDate)
                        
                        
                        if let questionResult = result as? ORKQuestionResult {
                            print("----- > questionResult identifier, start date and end date \n")
                            print(questionResult.startDate)
                            print(questionResult.identifier)
                            print(questionResult.questionType)
                            
                            //var bodyLocationsString: String = ""
                            if questionResult.identifier == "symptom_focus" {
                                let array = questionResult.answer as! NSArray
                                //print("questionResult.answer to save \(array) and first object\(String(describing: array.firstObject))")
                                dSymptomFocus.name = array.firstObject as! String!
                            }
                            
                            if questionResult.identifier == "symptomTracker_eventTimeStamp" {
                                print("symptomTracker_eventTimeStamp 508" )
                                if let date = questionResult.answer! as? NSDate {
                                    
                                    //this is the today date but not necessarily the date for which this person is entering the data
                                    //we will will replace that date with the date the person is entering the data but keep the time that the perrson want to tenter the data for
                                    print("date. \(date) 0")
                                    dSymptomFocus.date = date
                                    var aString:String = ""
                                    aString = formatter.string(from: date as Date)
                                    let mystring = aString.dropFirst(10)
                                    let realDateTimeString = newDateString+mystring
                                    
                                    dSymptomFocus.dateString = realDateTimeString//formatter.string(from: date as Date)
                                    print("dateString. \(String(describing: dSymptomFocus.dateString)) 0") //this the date the user reports as the event date and time.
                                } else {
                                    print("we did not enter a date so we could use the current date : \(Date())")
                                }
                            }
                            
                            if questionResult.identifier == "symptom_intensity_level" {
                                let measure = (questionResult.answer! as? NSNumber)?.stringValue
                                print("intensityLevel = \(String(describing: measure))")
                                //                            dSymptomFocus.intensity = measure
                                let x = (questionResult.answer! as? Double)
                                let xRounded = x!.roundTo(places: 1)
                                
                                dSymptomFocus.intensity = String(xRounded)
                                dSymptomFocus.metric = "outOf10"
                                
                            }
                            
                           
                            
                            if questionResult.identifier == "symptom_status" {
                                print("SymptomStatus 531")
                                if let array = questionResult.answer as? NSArray {
                                    print("questionResult.answer to save \(array) and first object\(String(describing: array.firstObject))")
                                    print("questionResult.answer.status to save \(String(describing: questionResult.answer))")
                                    //symptom.status = questionResult.answer as? String
                                    dSymptomFocus.status = array.firstObject as? String
                                }
                            }
                            
//                            if questionResult.identifier == "symptom_affected_body_locations" {
//                                guard let myArray = questionResult.answer as? NSArray, myArray.count >= 1 else {
//                                    print("String is nil or empty.")
//                                    dSymptomFocus.bodyLocations = "none"
//                                    //use return, break, continue, or throw
//                                    break
//                                }
//                                print("questionResult.answer has data in the array")
//                                let string = myArray.componentsJoined(by: ",") as String
//                                dSymptomFocus.bodyLocations = string
//
//                            }
//                            if questionResult.identifier == "other_locations" {
//                                print("other_locations answer ", String(describing:questionResult.answer))
//                                guard let string = questionResult.answer as? String, !string.isEmpty else {
//                                    dSymptomFocus.otherBodyLocations = "none"
//                                    break
//                                }
//
//                                dSymptomFocus.otherBodyLocations = string
//                                print(string)
//                                print("PPPaPP")
//                            }
                            
                            if questionResult.identifier == "other_interventions" {
                                //print("other_interventions answer \(String(describing: questionResult.answer))")
                                guard let string = questionResult.answer as? String, !string.isEmpty else {
                                    dSymptomFocus.otherInterventions = "none"
                                    break
                                }
                                
                                dSymptomFocus.otherInterventions = string
                                print(string)
                                print("PPPsPP")
                                
                            }
//                            if questionResult.identifier == "other_triggers" {
//                                print("other_triggers answer \(String(describing: questionResult.answer)) \n")
//                                guard let string = questionResult.answer as? String, !string.isEmpty else {
//                                    dSymptomFocus.otherTriggers = "none"
//                                    break
//                                }
//
//                                dSymptomFocus.otherTriggers = string
//                                print(string)
//                                print("PPPPP")
//
//                            }
                            
                            if questionResult.identifier == "symptom_interventions" {
                                guard let array = questionResult.answer as? NSArray, array.count >= 1 else {
                                    print("intervention String is nil or empty.")
                                    dSymptomFocus.interventions = "none"
                                    break
                                }
                                let string = array.componentsJoined(by: ",") as String
                                dSymptomFocus.interventions = string
                            }
                            
//                            if questionResult.identifier == "symptom_triggers" {
//                                guard let array = questionResult.answer as? NSArray, array.count >= 1 else {
//                                    print("intervention String is nil or empty.")
//                                    dSymptomFocus.triggers = "none"
//                                    break
//                                }
//                                let string = array.componentsJoined(by: ",") as String
//                                dSymptomFocus.triggers = string
//                            }
                        }
                    }
                }
                
                //SAVE
                listDataManager.saveCareData()
                
                //Get an array of the rows in coredata to upload.
                let symptoms = listDataManager.findSymptomFocus(entityName: "DSymptomFocus") as [DSymptomFocus]
                if symptoms.count > 0 {
                    var archive:[[String]] = [[]]
                    let headerArray = ["participantID","dateString","taskRunUUID","name","intensity","metric","status", "interventions", "otherInterventions","interference","interferenceMetric","interference","interferenceMetric","timestampString","timestampEndString","dayString"]
                    
                    
                    //for index "index" and element "e" enumerate the elements of symptoms.
                    for (_, e) in symptoms.enumerated() {
                        let ar = [e.participantID, e.dateString, e.taskRunUUID, e.name, e.intensity, e.metric, e.status, e.interventions, e.otherInterventions,  e.timestampString, e.timestampEndString, e.dayString]
                        archive.append(ar as! [String])
                        //print("item: \(e.name)) \(index):\(e)")
                    }
                    
                    
                    archive.remove(at: 0)
                    archive.insert(headerArray, at: 0)
                    print(archive)
                    //upload array of arrays as a CSV file
                    let uploadSymptomFocus = UploadApi()
                    uploadSymptomFocus.writeAndUploadCSVToSharefile(forSymptomFocus: archive, "symptomFocus.csv")
                    
                }
            }
            //END SymtomFocus
            
            //START Appetite
            if taskViewController.result.identifier == "appetite" {
                let carePlanResult = sampleAssessment.buildResultForCarePlanEvent(event, taskResult: taskViewController.result)
                var dAppetite: DAppetite!
                dAppetite = listDataManager.createDAppetite(entityName: "DAppetite") as DAppetite
                
                let keychain = KeychainSwift()
                if let username = keychain.get("username_TRU-BLOOD") {
                    dAppetite.participantID =  username
                }
                dAppetite.taskRunUUID = String(describing: taskViewController.result.taskRunUUID as UUID)
                dAppetite.timestamp = taskViewController.result.startDate as NSDate?
                dAppetite.timestampString = formatter.string(from: taskViewController.result.startDate)
                dAppetite.timestampEnd = taskViewController.result.endDate as NSDate?
                dAppetite.timestampEndString = formatter.string(from: taskViewController.result.endDate)
                dAppetite.dayString = dayFormatter.string(from: date!)
                dAppetite.metric = "pct"
                dAppetite.appetiteTotal = carePlanResult.valueString
                
                let x = taskViewController.result
                print("x is \(x)")
                for stepResult: ORKStepResult in results {
                    print("##### appetite > \(carePlanResult.valueString) result start date and identifier \n")
                    //                    if let totalAppetite = stepResult.results?.first as? ORKChoiceQuestionResult {
                    //                        print("appetite \(totalAppetite)")
                    //                        let array = totalAppetite.answer as? Array<Any>
                    //                        dAppetite.appetiteTotal = array?[0] as? String
                    //                    }
                    
                    for result in stepResult.results! {
                        if let questionResult = result as? ORKChoiceQuestionResult {
                            
                            if questionResult.identifier == "breakfast_status" {
                                let response = questionResult.answer as? Array<Any>
                                //print("questionResult.answer to save \(String(describing: response))")
                                dAppetite.breakfast = response?[0] as? String
                            }
                            
                            if questionResult.identifier == "lunch_status" {
                                let response = questionResult.answer as? Array<Any>
                                //print("questionResult.answer to save \(String(describing: response))")
                                dAppetite.lunch = response?[0] as? String
                            }
                            
                            if questionResult.identifier == "dinner_status" {
                                let response = questionResult.answer as? Array<Any>
                                //print("questionResult.answer to save \(String(describing: response))")
                                dAppetite.dinner = response?[0] as? String
                            }
                            
                        }
                    }
                }
                
                //SAVE
                listDataManager.saveCareData()
                
                
                
                //Get an array of the rows in coredata to upload.
                let appetite = listDataManager.findAppetite(entityName: "DAppetite") as [DAppetite]
                if  appetite.count > 0 {
                    var archive:[[String]] = [[]]
                    let headerArray = ["participantID","taskRunUUID","timestampString","timestampEndString","breakfast","lunch","dinner","appetiteTotal","metric","dayString"]
                    //for index "index" and element "e" enumerate the elements of symptoms.
                    for (index, e) in appetite.enumerated() {
                        let ar = [e.participantID, e.taskRunUUID, e.timestampString, e.timestampEndString, e.breakfast, e.lunch, e.dinner, e.appetiteTotal, e.metric, e.dayString  ]
                        archive.append(ar as! [String])
                        print("item: \(e.appetiteTotal ?? "-999")) \(index):\(e)")
                    }
                    archive.remove(at: 0)
                    archive.insert(headerArray, at: 0)
                    print(archive)
                    //upload array of arrays as a CSV file
                    let uploadSymptomFocus = UploadApi()
                    uploadSymptomFocus.writeAndUploadCSVToSharefile(forSymptomFocus: archive, "appetite.csv")
                    
                }
                
            }
            //  END Appetite
            
            
            
            
            //START Pain General Health
            if taskViewController.result.identifier == "generalHealth" {
                var dGeneralHealth: DGeneralHealth!
                dGeneralHealth = listDataManager.createGeneralHealth(entityName: "DGeneralHealth") as DGeneralHealth
                
                let keychain = KeychainSwift()
                if let username = keychain.get("username_TRU-BLOOD") {
                    dGeneralHealth.participantID =  username
                }
                dGeneralHealth.taskRunUUID = String(describing: taskViewController.result.taskRunUUID as UUID)
                dGeneralHealth.timestamp = taskViewController.result.startDate as NSDate?
                dGeneralHealth.timestampString = formatter.string(from: taskViewController.result.startDate)
                dGeneralHealth.timestampEnd = taskViewController.result.endDate as NSDate?
                dGeneralHealth.timestampEndString = formatter.string(from: taskViewController.result.endDate)
                dGeneralHealth.metric = "outOf10"
                dGeneralHealth.dateString = formatter.string(from: date!)
                dGeneralHealth.dayString = dayFormatter.string(from: date!)
                
                for stepResult: ORKStepResult in results {
                    print("#####  > result start date and identifier \n")
                    for result in stepResult.results! {
                        if let questionResult = result as? ORKQuestionResult {
                            //                            if questionResult.identifier == "backPain" {
                            //                                let response = questionResult.answer as! NSNumber
                            //                                print("questionResult.answer to save \(response)")
                            //                                dGeneralHealth.pain = String(describing: response)
                            //                            }
                            if questionResult.identifier == "GeneralHealth" {
                                let response = questionResult.answer as! NSNumber
                                print("questionResult.answer to save \(response)")
                                dGeneralHealth.generalHealth = String(describing: response)
                            }
                            
//                            if questionResult.identifier == "mood" {
//                                let response = questionResult.answer as! NSNumber
//                                print("questionResult.answer to save \(response)")
//                                dGeneralHealth.mood = String(describing: response)
//                            }
                            
                            if questionResult.identifier == "StressItem" {
                                let response = questionResult.answer as! NSNumber
                                print("questionResult.answer to save \(response)")
                                dGeneralHealth.stress = String(describing: response)
                            }
                            if questionResult.identifier == "SleepItem" {
                                let response = questionResult.answer as! NSNumber
                                print("questionResult.answer to save \(response)")
                                dGeneralHealth.sleepHours = String(describing: response)
                            }
                            if questionResult.identifier == "SleepQualityItem" {
                                let response = questionResult.answer as! NSNumber
                                print("questionResult.answer to save \(response)")
                                dGeneralHealth.sleepQuality = String(describing: response)
                            }
                            if questionResult.identifier == "SymptomsInterference" {
                                let response = questionResult.answer as! NSNumber
                                print("questionResult.answer to save \(response)")
                                dGeneralHealth.symptomInterference = String(describing: response)
                            }
                            
                        }
                    }
                }
                
                //SAVE
                listDataManager.saveCareData()
                
                
                
                //Get an array of the rows in coredata to upload.
                let generalHealth = listDataManager.findGeneralHealth(entityName: "DGeneralHealth") as [DGeneralHealth]
                if generalHealth .count > 0 {
                    var archive:[[String]] = [[]]
                    let headerArray = ["participantID","dateString","taskRunUUID","generalHealth","stress","sleepHours","sleepQuality","symptomInterference","timestampString","timestampEndString","dayString"]
                    //for index "index" and element "e" enumerate the elements of symptoms.
                    for (index, e) in generalHealth.enumerated() {
                        let ar = [e.participantID, e.dateString, e.taskRunUUID, e.generalHealth, e.stress, e.sleepHours, e.sleepQuality, e.symptomInterference, e.timestampString, e.timestampEndString, e.dayString]
                        archive.append(ar as! [String])
                        print("item: \(e.sleepQuality ?? "-999") \(index):\(e)")
                    }
                    archive.remove(at: 0)
                    archive.insert(headerArray, at: 0)
                    print(archive)
                    //upload array of arrays as a CSV file
                    let uploadSymptomFocus = UploadApi()
                    uploadSymptomFocus.writeAndUploadCSVToSharefile(forSymptomFocus: archive, "generalHealth.csv")
                    
                }
                
            }
            //  END Pain General Health
            
            
            //  START Stool
            if taskViewController.result.identifier == "stoolConsistency" {
                var dStool: DStool!
                dStool = listDataManager.createDStool(entityName: "DStool") as DStool
                let keychain = KeychainSwift()
                if let username = keychain.get("username_TRU-BLOOD") {
                    dStool.participantID =  username
                }
                dStool.taskRunUUID = String(describing: taskViewController.result.taskRunUUID as UUID)
                dStool.timestamp = taskViewController.result.startDate as NSDate?
                dStool.timestampString = formatter.string(from: taskViewController.result.startDate)
                dStool.timestampEnd = taskViewController.result.endDate as NSDate?
                dStool.timestampEndString = formatter.string(from: taskViewController.result.endDate)
                dStool.dateString = formatter.string(from: date!)
                dStool.dayString = dayFormatter.string(from: date!)
                
                for stepResult: ORKStepResult in results {
                    for result in stepResult.results! {
                        if let questionResult = result as? ORKQuestionResult {
                            
                            //Stool type
                            if questionResult.identifier == "BStoolT1" {
                                if let response = questionResult.answer {
                                    print("stool type 01 questionResult.answer to save \(response)")
                                    dStool.type1 = String(describing: response)
                                } else {
                                    dStool.type1 = "0"
                                    print("zero")
                                }
                            }
                            if questionResult.identifier == "BStoolT2" {
                                if let response = questionResult.answer {
                                    print("stool type 02 questionResult.answer to save \(response)")
                                    dStool.type2 = String(describing: response)
                                } else {
                                    dStool.type2 = "0"
                                    print("zero")
                                }
                            }
                            if questionResult.identifier == "BStoolT3" {
                                if let response = questionResult.answer {
                                    print("stool type 03 questionResult.answer to save \(response)")
                                    dStool.type3 = String(describing: response)
                                } else {
                                    dStool.type3 = "0"
                                    print("zero")
                                }
                            }
                            if questionResult.identifier == "BStoolT4" {
                                if let response = questionResult.answer {
                                    print("stool type 04 questionResult.answer to save \(response)")
                                    dStool.type4 = String(describing: response)
                                } else {
                                    dStool.type4 = "0"
                                    print("zero")
                                }
                            }
                            if questionResult.identifier == "BStoolT5" {
                                if let response = questionResult.answer {
                                    print("stool type 05 questionResult.answer to save \(response)")
                                    dStool.type5 = String(describing: response)
                                } else {
                                    dStool.type5 = "0"
                                    print("zero")
                                }
                            }
                            if questionResult.identifier == "BStoolT6" {
                                if let response = questionResult.answer {
                                    print("stool type 06 questionResult.answer to save \(response)")
                                    dStool.type6 = String(describing: response)
                                } else {
                                    dStool.type6 = "0"
                                    print("zero")
                                }
                            }
                            if questionResult.identifier == "BStoolT7" {
                                if let response = questionResult.answer {
                                    print("stool type 07 questionResult.answer to save \(response)")
                                    dStool.type7 = String(describing: response)
                                } else {
                                    dStool.type7 = "0"
                                    print("zero")
                                }
                            }
                            
                            
                            /*
                            if questionResult.identifier == "BStoolT1" {
                                var response = 0
                                guard questionResult.answer != nil else {
                                    // Value requirements not met, keep response to 0 as assigned
                                    dStool.type1 = String(describing: response)
                                    return
                                }
                                
                                response = Int(questionResult.answer as! NSNumber)
                                print("questionResult.answer to save \(response)")
                                dStool.type1 = String(describing: response)
                            }
                            
                            if questionResult.identifier == "BStoolT2" {
                                var response = 0
                                guard questionResult.answer != nil else {
                                    dStool.type2 = String(describing: response)
                                    return
                                }
                                response = Int(questionResult.answer as! NSNumber)
                                print("questionResult.answer to save \(response)")
                                dStool.type2 = String(describing: response)
                            }
                            
                            if questionResult.identifier == "BStoolT3" {
                                var response = 0
                                guard questionResult.answer != nil else {
                                    dStool.type3 = String(describing: response)
                                    return
                                }
                                
                                response = Int(questionResult.answer as! NSNumber)
                                print("questionResult.answer to save \(response)")
                                dStool.type3 = String(describing: response)
                            }
                            
                            if questionResult.identifier == "BStoolT4" {
                                var response = 0
                                guard questionResult.answer != nil else {
                                    dStool.type4 = String(describing: response)
                                    return
                                }
                                
                                response = Int(questionResult.answer as! NSNumber)
                                print("questionResult.answer to save \(response)")
                                dStool.type4 = String(describing: response)
                            }
                            
                            if questionResult.identifier == "BStoolT5" {
                                let response = 0
                                guard questionResult.answer != nil else {
                                    dStool.type5 = String(describing: response)
                                    return
                                }
                                
                                dStool.type5 = String(describing: Int(questionResult.answer as! NSNumber))
                            }
                            
                            if questionResult.identifier == "BStoolT6" {
                                let response = 0
                                guard questionResult.answer != nil else {
                                    dStool.type6 = String(describing: response)
                                    return
                                }
                                
                                dStool.type6 = String(describing: Int(questionResult.answer as! NSNumber))
                            }
                            
                            if questionResult.identifier == "BStoolT7" {
                                let response = 0
                                guard questionResult.answer != nil else {
                                    dStool.type7 = String(describing: response)
                                    return
                                }
                                dStool.type7 = String(describing: Int(questionResult.answer as! NSNumber))
                            }*/
                        }
                    }
                }
                
                
                
                //NSManagedObjectContext.default().saveToPersistentStoreAndWait()
                listDataManager.saveCareData()
                
                //Get an array of the rows in coredata to upload.
                let stools = listDataManager.findDStool(entityName: "DStool")  as [DStool]
                if stools .count > 0 {
                    var archive:[[String]] = [[]]
                    let headerArray = ["participantID","dateString","taskRunUUID","Type1","Type2","Type3","Type4","Type5","Type6","Type7","timestampString","timestampEndString","dayString"]
                    //for index "index" and element "e" enumerate the elements of symptoms.
                    for (index, e) in stools.enumerated() {
                        let ar = [e.participantID, e.dateString!, e.taskRunUUID, e.type1, e.type2, e.type3, e.type4, e.type5, e.type6, e.type7, e.timestampString, e.timestampEndString, e.dayString]
                        archive.append(ar as! [String])
                        print("item: \(String(describing:e.dateString)) \(index):\(e)")
                    }
                    archive.remove(at: 0)
                    archive.insert(headerArray, at: 0)
                    print(archive)
                    //upload array of arrays as a CSV file
                    let uploadSymptomFocus = UploadApi()
                    uploadSymptomFocus.writeAndUploadCSVToSharefile(forSymptomFocus: archive, "stool.csv")
                    
                }
            }
            //  ENd Stool
            
            //  START Temperature
            if taskViewController.result.identifier == "temperature" {
                var dTemperature: DTemperature!
                dTemperature = listDataManager.createDTemperature(entityName: "DTemperature") as DTemperature
                
                let keychain = KeychainSwift()
                if let username = keychain.get("username_TRU-BLOOD") {
                    dTemperature.participantID =  username
                }
                dTemperature.taskRunUUID = String(describing: taskViewController.result.taskRunUUID as UUID)
                dTemperature.timestamp = taskViewController.result.startDate as NSDate?
                dTemperature.timestampString = formatter.string(from: taskViewController.result.startDate)
                dTemperature.timestampEnd = taskViewController.result.endDate as NSDate?
                dTemperature.timestampEndString = formatter.string(from: taskViewController.result.endDate)
                dTemperature.metric = "degF"
                dTemperature.method = "oral"
                dTemperature.name = "body temperature"
                dTemperature.dayString = dayFormatter.string(from: date!)
                
                for stepResult: ORKStepResult in results {
                    print("#####  > result start date and identifier \n")
                    for result in stepResult.results! {
                        if let questionResult = result as? ORKQuestionResult {
                            if questionResult.identifier == "temperature" {
                                let response = questionResult.answer as! NSNumber
                                print("questionResult.answer to save \(response)")
                                dTemperature.intensity = String(describing: response)
                            }
                            if questionResult.identifier == "temperature_eventTimeStamp" {
                                let date = questionResult.answer! as? NSDate
                                print("date. \(String(describing: date)) 0")
                                dTemperature.date = date
                                dTemperature.dateString = formatter.string(from: date as! Date)
                                //print("dateString. \(String(describing: dTemperature.dateString)) 0") //this the date the user reports as the event date and time.
                            }
                        }
                    }
                }
                
                //SAVE
                listDataManager.saveCareData()
                
                
                //Get an array of the rows in coredata to upload.
                let temperatures = listDataManager.findDTemperature(entityName: "DTemperature") as [DTemperature]
                if temperatures .count > 0 {
                    var archive:[[String]] = [[]]
                    let headerArray = ["participantID","dateString","taskRunUUID","assesmentName","value","metric","method","timestampString","timestampEndString","dayString"]
                    //for index "index" and element "e" enumerate the elements of symptoms.
                    for (index, e) in temperatures.enumerated() {
                        let ar = [e.participantID, e.dateString, e.taskRunUUID, e.name, e.intensity, e.metric, e.method, e.timestampString, e.timestampEndString, e.dayString]
                        archive.append(ar as! [String])
                        print("item: \(e.name ?? "-999") \(index):\(e)")
                    }
                    archive.remove(at: 0)
                    archive.insert(headerArray, at: 0)
                    print(archive)
                    //upload array of arrays as a CSV file
                    let uploadSymptomFocus = UploadApi()
                    uploadSymptomFocus.writeAndUploadCSVToSharefile(forSymptomFocus: archive, "temperature.csv")
                    
                }
            }
            //  END Temperature
            
            
            
            //START SCDPain
            if taskViewController.result.identifier == "scdPain" {
                var dscdPain: DscdPain!
                dscdPain = listDataManager.createDscdPain(entityName: "DscdPain") as DscdPain
                let keychain = KeychainSwift()
                if let username = keychain.get("username_TRU-BLOOD") {
                    dscdPain.participantID =  username
                }
                dscdPain.taskRunUUID = String(describing: taskViewController.result.taskRunUUID as UUID)
                dscdPain.timestamp = taskViewController.result.startDate as NSDate?
                dscdPain.timestampString = formatter.string(from: taskViewController.result.startDate)
                dscdPain.timestampEnd = taskViewController.result.endDate as NSDate?
                dscdPain.timestampEndString = formatter.string(from: taskViewController.result.endDate)
                dscdPain.metric = "outOf10"
                dscdPain.dateString = formatter.string(from: date!)
                dscdPain.dayString = dayFormatter.string(from: date!)
                
                for stepResult: ORKStepResult in results {
                    print("#####  > result start date and identifier \n")
                    for result in stepResult.results! {
                        if let questionResult = result as? ORKQuestionResult {
                            print("#####  > and identifier \n \(questionResult.identifier)")
                            if questionResult.identifier == "scdPain" {
                                let response = questionResult.answer as! Double
                                print("questionResult.answer to save \(response)")
                                dscdPain.scdPain = String(describing: response)
                            }
                            if questionResult.identifier == "scdPain_eventTimeStamp" {
                                print("date scdPain_eventTimeStamp")
                                //let date = questionResult.answer! as? NSDate
                                
                                
                                if let date = questionResult.answer! as? NSDate {
                                    
                                    //this is the today date but not necessarily the date for which this person is entering the data
                                    //we will will replace that date with the date the person is entering the data but keep the time that the perrson want to tenter the data for
                                    print("date. \(date) 0")
                                    dscdPain.date = date
                                    var aString:String = ""
                                    aString = formatter.string(from: date as Date)
                                    let mystring = aString.dropFirst(10)
                                    let realDateTimeString = newDateString+mystring
                                
                                    //print("date. \(date) 0")
                                    
                                    dscdPain.dateString = realDateTimeString
                                    //print("dateString. \(dscdPain.dateString) 0") //this the date the user reports as the event date and time.
                                    print("dateString for SCDPain. \(String(describing: dscdPain.dateString)) 0") //this the date the user reports as the event date and time.
                                } else {
                                    print("we did not enter a date so we could use the current date : \(Date())")
                                }
                                
                            }
                            
                            if questionResult.identifier == "scdPain_status" {
                                if let array = questionResult.answer as? NSArray {
                                    dscdPain.scdPainStatus = array.firstObject as? String
                                }
                            }
                            
                            if questionResult.identifier == "scdPain_affected_body_locations" {
                                let array = questionResult.answer as! NSArray
                                let string = array.componentsJoined(by: ",") as String
                                print("questionResult.answer array to save \(array)")
                                print("questionResult.answer.body  to save as string --> \(string)")
                                dscdPain.bodyLocations = string
                                
                            }
                            
                            if questionResult.identifier == "nonscdPain" {
                                if let array = questionResult.answer as? NSArray {
                                   // print("non scd result\(array.firstObject)")
                                    dscdPain.nonscdPain = String(describing:array.firstObject!)
                                }
                            }
                        }
                    }
                }
                
                listDataManager.saveCareData()
                
                //Get an array of the rows in coredata to upload.
                let scdPain = listDataManager.findDscdPain(entityName: "DscdPain") as [DscdPain]
                if scdPain.count > 0 {
                    var archive:[[String]] = [[]]
                    //TODO set a choice of header array
                    let defaults = Defaults.shared
                    let key = Key<String>("PainTYpe")
                    var headerArray = [String]()
                    if defaults.has(key) {
                        // Do your thing
                        if defaults.get(for: key) == "SurgicalPain" {
                            headerArray = ["participantID","dateString","taskRunUUID","surgicalPain","metric","painStatus","bodyLocations","nonSurgicalPain","timestampString","timestampEndString", "dayString"]
                        } else {
                            headerArray = ["participantID","dateString","taskRunUUID","scdPain","metric","scdPainStatus","bodyLocations","nonSCDpain","timestampString","timestampEndString", "dayString"]
                        }
                    } else {
                        headerArray = ["participantID","dateString","taskRunUUID","scdPain","metric","scdPainStatus","bodyLocations","nonSCDpain","timestampString","timestampEndString", "dayString"]
                    }
                    
                    //for index "index" and element "e" enumerate the elements of symptoms.
                    for (index, e) in scdPain.enumerated() {
                        //print("item: \(e.scdPain)) \(index):\(e)")
                        let ar = [e.participantID, e.dateString, e.taskRunUUID, e.scdPain, e.metric, e.scdPainStatus, e.bodyLocations, e.nonscdPain, e.timestampString, e.timestampEndString, e.dayString ]
                        archive.append(ar as! [String])
                        //                        print("item: \(e.scdPain)) \(index):\(e)")
                    }
                    archive.remove(at: 0)
                    archive.insert(headerArray, at: 0)
                    print(archive)
                    //upload array of arrays as a CSV file
                    let uploadSymptomFocus = UploadApi()
                    uploadSymptomFocus.writeAndUploadCSVToSharefile(forSymptomFocus: archive, "scdPain.csv")
                    
                }
                
            }
            //  END SCDPain
            
            
            
            
            //START DMenstruation
            
            if taskViewController.result.identifier == "menstruation" || taskViewController.result.identifier == "menstruationSCD" {
                var dMenstruation: DMenstruation!
                dMenstruation = listDataManager.createDMenstruation(entityName: "DMenstruation") as DMenstruation
                let keychain = KeychainSwift()
                if let username = keychain.get("username_TRU-BLOOD") {
                    dMenstruation.participantID =  username
                }
                dMenstruation.taskRunUUID = String(describing: taskViewController.result.taskRunUUID as UUID)
                dMenstruation.timestamp = taskViewController.result.startDate as NSDate?
                dMenstruation.timestampString = formatter.string(from: taskViewController.result.startDate)
                dMenstruation.timestampEnd = taskViewController.result.endDate as NSDate?
                dMenstruation.timestampEndString = formatter.string(from: taskViewController.result.endDate)
                dMenstruation.dayString = dayFormatter.string(from: date!)
                
                for stepResult: ORKStepResult in results {
                    print("#####  > result start date and identifier \n")
                    for result in stepResult.results! {
                        if let questionResult = result as? ORKQuestionResult {
                            print("#####  > and identifier \n \(questionResult.identifier)")
                            
                            if questionResult.identifier == "symptom_eventTimeStamp" {
                                print("date urineCollectionActualTime")
                                
                                let date = questionResult.answer! as? NSDate
                                //print("date. \(date) 0")
                                dMenstruation.date = date
                                dMenstruation.dateString = formatter.string(from: date as! Date)
                                //print("dateString. \(dMenstruation.dateString) 0") //this the date the user reports as the event date and time.
                            }
                            
                            if questionResult.identifier == "firstMorningUrine" {
                                if let array = questionResult.answer as? NSArray {
                                    dMenstruation.firstMorningUrine = array.firstObject as? String
                                }
                                
                            }
                            
                            if questionResult.identifier == "spotting" {
                                if let array = questionResult.answer as? NSArray {
                                    dMenstruation.spotting = array.firstObject as? String
                                }
                            }
                            if questionResult.identifier == "menstruating" {
                                if let array = questionResult.answer as? NSArray {
                                    //print("non scd result\(array.firstObject)")
                                    dMenstruation.menstruating = String(describing:array.firstObject!)
                                }
                            }
                            
                            if questionResult.identifier == "lowerAbdominalCramp" {
                                let response = questionResult.answer as! Double
                                print("questionResult.answer to save \(response)")
                                dMenstruation.lowerAbdominalCramp = String(describing: response)
                            }
                            
                            
                            if questionResult.identifier == "differentiatesPain" {
                                if let array = questionResult.answer as? NSArray {
                                    //print("non scd result\(array.firstObject)")
                                    dMenstruation.differentiatesPain = String(describing:array.firstObject!)
                                }
                            }
                            
                            if questionResult.identifier == "differentiatesSCDPainCharacter" {
                                if let array = questionResult.answer as? NSArray {
                                    //print("non scd result\(array.firstObject)")
                                    dMenstruation.differentiatesSCDPainCharacter = String(describing:array.firstObject!)
                                }
                            }
                            
                            
                            //PADS
                            if questionResult.identifier == "pad01" {
                                if let response = questionResult.answer {
                                    print("pad01 questionResult.answer to save \(response)")
                                    dMenstruation.pad01 = String(describing: response)
                                } else {
                                    dMenstruation.pad01 = "0"
                                    print("zero")
                                }
                            }
                            
                            if questionResult.identifier == "pad02" {
                                if let response = questionResult.answer {
                                    print("pad02 questionResult.answer to save \(response)")
                                    dMenstruation.pad02 = String(describing: response)
                                } else {
                                    dMenstruation.pad02 = "0"
                                    print("zero")
                                }
                            }
                            
                            if questionResult.identifier == "pad03" {
                                if let response = questionResult.answer {
                                    print("pad01 questionResult.answer to save \(response)")
                                    dMenstruation.pad03 = String(describing: response)
                                } else {
                                    dMenstruation.pad03 = "0"
                                    print("zero")
                                }
                            }
                            //TAMPONS
                            if questionResult.identifier == "tampon01" {
                                if let response = questionResult.answer {
                                    print("tampon01 questionResult.answer to save \(response)")
                                    dMenstruation.tampon01 = String(describing: response)
                                } else {
                                    dMenstruation.tampon01 = "0"
                                    print("zero")
                                }
                            }
                            
                            if questionResult.identifier == "tampon02" {
                                if let response = questionResult.answer {
                                    print("tampon02 questionResult.answer to save \(response)")
                                    dMenstruation.tampon02 = String(describing: response)
                                } else {
                                    dMenstruation.tampon02 = "0"
                                    print("zero")
                                }
                            }
                            
                            if questionResult.identifier == "tampon03" {
                                if let response = questionResult.answer {
                                    print("tampon03 questionResult.answer to save \(response)")
                                    dMenstruation.tampon03 = String(describing: response)
                                } else {
                                    dMenstruation.tampon03 = "0"
                                    print("zero")
                                }
                            }
                            
                            
                            
                        }
                    }
                }
                
                //SAVE
                listDataManager.saveCareData()
                
                //Get an array of the rows in coredata to upload.
                let menstruation = listDataManager.findDMenstruation(entityName: "DMenstruation") as [DMenstruation]
                if menstruation.count > 0 {
                    var archive:[[String]] = [[]]
                    let headerArray = ["participantID","dateString","taskRunUUID", "firstMorningUrine","spotting","menstruating","lowerAbdominalCramp","differentiatesPain","differentiatesSCDPainCharacter",
                                       "padSmallSoil","padMediumSoil","padLargeSoil","tamponSmallSoil", "tamponMediumSoil", "tamponLargeSoil","timestampString","timestampEndString","dayString"]
                    //for index "index" and element "e" enumerate the elements of symptoms.
                    for (index, e) in menstruation.enumerated() {
                        //print("item: \(e.menstruating)) \(index):\(e)")
//                        var differentiatesSCDPainCharacter: String?
//                        guard e.differentiatesSCDPainCharacter != nil else {
//                            differentiatesSCDPainCharacter = "-99"
//                            return
//                        }
                        
                        
                        let missingValue = "-99"
                        
                        let ar = [e.participantID, e.dateString, e.taskRunUUID, e.firstMorningUrine, e.spotting, e.menstruating, e.lowerAbdominalCramp, e.differentiatesPain, e.differentiatesSCDPainCharacter ?? missingValue,
                                  e.pad01,e.pad02, e.pad03, e.tampon01, e.tampon02, e.tampon03, e.timestampString, e.timestampEndString, e.dayString ]
                        archive.append(ar as! [String])
                        //                        print("item: \(e.scdPain)) \(index):\(e)")
                    }
                    archive.remove(at: 0)
                    archive.insert(headerArray, at: 0)
                    print(archive)
                    //upload array of arrays as a CSV file
                    let uploadSymptomFocus = UploadApi()
                    uploadSymptomFocus.writeAndUploadCSVToSharefile(forSymptomFocus: archive, "menstruation.csv")
                    
                }
            }
            //  END DMenstruation
            
        }
        
        
        
        // Determine the event that was completed and the `SampleAssessment` it represents.
        //        guard let event = symptomTrackerViewController.lastSelectedAssessmentEvent,
        //            let activityType = ActivityType(rawValue: event.activity.identifier),
        //            let sampleAssessment = sampleData.activityWithType(activityType) as? Assessment else { return }
        
        // Build an `OCKCarePlanEventResult` that can be saved into the `OCKCarePlanStore`.
        let carePlanResult = sampleAssessment.buildResultForCarePlanEvent(event, taskResult: taskViewController.result)
        
        //        let dataManager = DataManager(baseURL: API.AuthenticatedBaseURL)
        //        dataManager.dataFromTasksRVC(taskUUID: String(describing: taskViewController.result.taskRunUUID as UUID),
        //                                     timestamp: carePlanResult.creationDate, timestampString: formatter.string(from: taskViewController.result.startDate))
        
        print("carePlanResult.creationDate")
        print(carePlanResult.creationDate)
        print(event.date) //this is in date components
        print(event.debugDescription)
        print(event.activity.title)
        print(sampleAssessment.activityType)
        //        print(carePlanResult.valueString)
        
        
        //private var _dGeoData:DGeoData?
        let dGeoData = listDataManager.createGeoData(entityName: "DGeoData") as DGeoData
        let keychain = KeychainSwift()
        if let username = keychain.get("username_TRU-BLOOD") {
            dGeoData.participantID =  username
        }
        
        dGeoData.taskUUID = String(describing: taskViewController.result.taskRunUUID as UUID)
        dGeoData.timestamp = carePlanResult.creationDate as NSDate?
        dGeoData.timestampString = formatter.string(from: taskViewController.result.startDate)
        listDataManager.saveCareData()
        
        
        self.taskUUID = taskViewController.result.taskRunUUID as UUID
        //print("TASK ID \(self.taskUUID)")
        
        
        self.findCurrentLocation(taskID: String(describing:self.taskUUID))
        
        
        
        // Check assessment can be associated with a HealthKit sample.
        if let healthSampleBuilder = sampleAssessment as? HealthSampleBuilder {
            // Build the sample to save in the HealthKit store.
            print("Build the sample to save in the HealthKit store.")
            let sample = healthSampleBuilder.buildSampleWithTaskResult(taskViewController.result)
            let sampleTypes: Set<HKSampleType> = [sample.sampleType]
            
            // Requst authorization to store the HealthKit sample.
            let healthStore = HKHealthStore()
            healthStore.requestAuthorization(toShare: sampleTypes, read: sampleTypes, completion: { success, _ in
                // Check if authorization was granted.
                if !success {
                    /*
                     Fall back to saving the simple `OCKCarePlanEventResult`
                     in the `OCKCarePlanStore`.
                     */
                    self.completeEvent(event, inStore: self.storeManager.store, withResult: carePlanResult)
                    return
                }
                
                // Save the HealthKit sample in the HealthKit store.
                healthStore.save(sample, withCompletion: { success, _ in
                    if success {
                        /*
                         The sample was saved to the HealthKit store. Use it
                         to create an `OCKCarePlanEventResult` and save that
                         to the `OCKCarePlanStore`.
                         */
                        print("The sample was saved to the HealthKit store.")
                        let healthKitAssociatedResult = OCKCarePlanEventResult(
                            quantitySample: sample,
                            quantityStringFormatter: nil,
                            display: healthSampleBuilder.unit,
                            displayUnitStringKey: healthSampleBuilder.localizedUnitForSample(sample),
                            userInfo: nil
                        )
                        
                        self.completeEvent(event, inStore: self.storeManager.store, withResult: healthKitAssociatedResult)
                    }
                    else {
                        /*
                         Fall back to saving the simple `OCKCarePlanEventResult`
                         in the `OCKCarePlanStore`.
                         */
                        self.completeEvent(event, inStore: self.storeManager.store, withResult: carePlanResult)
                    }
                    
                })
            })
        }
        else {
            // Update the event with the result.
            completeEvent(event, inStore: storeManager.store, withResult: carePlanResult)
        }
        
    }
    
    // MARK: Convenience
    
    fileprivate func completeEvent(_ event: OCKCarePlanEvent, inStore store: OCKCarePlanStore, withResult result: OCKCarePlanEventResult) {
        store.update(event, with: result, state: .completed) { success, _, error in
            if !success {
                print(error?.localizedDescription as Any)
            }
        }
    }
}

// MARK: OCKConnectViewControllerDelegate
// MARK: CarePlanStoreManagerDelegate
extension RootViewController: CarePlanStoreManagerDelegate {
    /// Called when the `CarePlanStoreManager`'s insights are updated.
    func carePlanStoreManager(_ manager: CarePlanStoreManager, didUpdateInsights insights: [OCKInsightItem]) {
        // Update the insights view controller with the new insights.
        insightsViewController.items = insights
        
    }
    
}
extension RootViewController: OCKConnectViewControllerDelegate {
    
    /// Called when the user taps a contact in the `OCKConnectViewController`.
    func connectViewController(_ connectViewController: OCKConnectViewController, didSelectShareButtonFor contact: OCKContact, presentationSourceView sourceView: UIView?) {
        print("i am called here too")
        
        
        
        if let document = storeManager.generateDocument(comment: "Comments:") {
        
        document.createPDFData { (PDFData, errorOrNil) in
            if let error = errorOrNil {
                print("perform proper error checking here...")
                
                let alertController = UIAlertController(title: "Error!", message: "Document cold not be created", preferredStyle: .alert)
                
                
                let confirmAction = UIAlertAction(title: "Ok", style: .default) { (_) in}
                
                alertController.addAction(confirmAction)
                self.navigationController?.present(alertController, animated: true, completion: nil)
                fatalError(error.localizedDescription)
            }
            
            // Do something with the PDF data here...
            let documentViewController = DocumentsDisplayViewController()
            
            print("\(document.htmlContent)")
            
            documentViewController.documentObject = document
            
            let vc = UIStoryboard(name: "Main", bundle: nil)
            let viewController = vc.instantiateViewController(withIdentifier: "DataReportViewControllerSB")
            
            let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.coverVertical
            viewController.modalTransitionStyle = modalStyle
            viewController.title = NSLocalizedString("Media", comment: "")
           // self.present(viewController, animated: true, completion: nil)
            
            print("i am presented too")
//            let activityViewController = UIActivityViewController(activityItems: [PDFData], applicationActivities: nil)
//            activityViewController.popoverPresentationController?.sourceView = activityViewController.view
//            activityViewController.popoverPresentationController?.sourceRect = activityViewController.view.bounds
//            self.present(activityViewController, animated: true, completion: nil)
        }
            
        }
    }
}

/*
// MARK: - OCKConnectViewControllerDelegate

extension RootViewController: OCKConnectViewControllerDelegate {
    
    /// Called when the user taps a contact in the `OCKConnectViewController`.
    func connectViewController(_ connectViewController: OCKConnectViewController,
                               didSelectShareButtonFor contact: OCKContact,
                               presentationSourceView sourceView: UIView?) {
        let document = sampleData.generateDocumentWith(chart: insightChart)
        let activityViewController = UIActivityViewController(activityItems: [document.htmlContent],
                                                              applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }
}
*/




// MARK: - CLLocationManagerDelegate
extension RootViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("func locationManager(")
        guard let mostRecentLocation = locations.last else {
            print("CL locations returned")
            return
        }
        
        if (self.isFirstUpdate) {
            self.isFirstUpdate = false
            return
        }
        print("CL locations")
        
        let location:CLLocation = locations.last!
        if (location.horizontalAccuracy > 0) {
            let dataManager = DataManager(baseURL: API.AuthenticatedBaseURL)
            dataManager.weatherDataForLocation(taskUUID:self.taskUUID!, altitude: mostRecentLocation.altitude,latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { (response, error) in
                print(response ?? "-999")
                
            }
            //self.currentLocation = location
            print("find my current location: \(location)")
            locationManager.stopUpdatingLocation()
            
            if UIApplication.shared.applicationState == .active {
                //                mapView.showAnnotations(self.locations, animated: true)
                print("App is foregrounded. New location is %@", mostRecentLocation.timestamp)
                print("App is foregrounded. New location is %@", mostRecentLocation.altitude)
                print("App is foregrounded. New location is %@", mostRecentLocation.course)
                print("App is foregrounded. New location is %@", mostRecentLocation.speed)
                print("App is foregrounded. New location is %@", mostRecentLocation.verticalAccuracy)
                print("App is foregrounded. New location is %@", mostRecentLocation.distance(from: location))
                
            } else {
                print("App is backgrounded. New location is %@", mostRecentLocation)
            }
        }
        
    }
}
