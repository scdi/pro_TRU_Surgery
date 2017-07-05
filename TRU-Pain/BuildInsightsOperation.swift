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

class BuildInsightsOperation: Operation {
    
    // MARK: Properties
    
    var medicationEvents: DailyEvents?
    
    var walkEvents: DailyEvents?
    var proteinsEvents: DailyEvents?
    var fruitsEvents: DailyEvents?
    var vegetablesEvents: DailyEvents?
    var dairyEvents: DailyEvents?
    var grainsEvents: DailyEvents?
    
    var sleepEvents: DailyEvents?
    
    var dinnerEvents: DailyEvents?
    
    var snackEvents: DailyEvents?
    
    
    var generalHealthEvents: DailyEvents?
    
    var archive:[[String]] = [[]]
    
    fileprivate(set) var insights = [OCKInsightItem.emptyInsightsMessage()]
    var dictionaryOfDailyEvents:[String:[String:String]] = [String: [String:String]]()
    
    // MARK: NSOperation
    
    override func main() {
        // Do nothing if the operation has been cancelled.
        guard !isCancelled else { return }
        
        // Create an array of insights.
        var newInsights = [OCKInsightItem]()
        
        //        if let insight = createMedicationAdherenceInsight() {
        //            newInsights.append(insight)
        //        }
        
        if let insight = createGeneralHealthInsight() {
            newInsights.append(insight)
        }
        
        if let insight = createWalkAdherenceInsight() {
            newInsights.append(insight)
        }
        
        if let insight = createProteinsAdherenceInsight() {
            newInsights.append(insight)
        }
        
        if let insight = createFruitsAdherenceInsight() {
            newInsights.append(insight)
        }
        
        if let insight = createVegetablesAdherenceInsight() {
            newInsights.append(insight)
        }
        
        if let insight = createDairyAdherenceInsight() {
            newInsights.append(insight)
        }
        
        if let insight = createGrainsAdherenceInsight() {
            newInsights.append(insight)
        }
        
        if let insight = createSleepAdherenceInsight() {
            newInsights.append(insight)
        }
        
        if let insight = createDinnerAdherenceInsight() {
            newInsights.append(insight)
        }
        
        if let insight = createSnackAdherenceInsight() {
            newInsights.append(insight)
        }
        
        
        
        // Store any new insights thate were created.
        if !newInsights.isEmpty {
            insights = newInsights
        }
    }
    
    //    // MARK: Convenience
    //    func createMedicationAdherenceInsight() -> OCKInsightItem? {
    //        // Make sure there are events to parse.
    //        guard let medicationEvents = medicationEvents else { return nil }
    //
    //        // Determine the start date for the previous week.
    //        let calendar = Calendar.current
    //        let now = Date()
    //
    //        var components = DateComponents()
    //        components.day = -30
    //        let startDate = calendar.weekDatesForDate(calendar.date(byAdding: components as DateComponents, to: now)!).start
    //
    //        var totalEventCount = 0
    //        var completedEventCount = 0
    //
    //        for offset in 0..<7 {
    //            components.day = offset
    //            let dayDate = calendar.date(byAdding: components as DateComponents, to: startDate)!
    //            let dayComponents = calendar.dateComponents([.year, .month, .day, .era], from: dayDate)
    //            let eventsForDay = medicationEvents[dayComponents]
    //
    //            totalEventCount += eventsForDay.count
    //
    //            for event in eventsForDay {
    //                if event.state == .completed {
    //                    completedEventCount += 1
    //                }
    //            }
    //        }
    //
    //        guard totalEventCount > 0 else { return nil }
    //
    //        // Calculate the percentage of completed events.
    //        let medicationAdherence = Float(completedEventCount) / Float(totalEventCount)
    //
    //        // Create an `OCKMessageItem` describing medical adherence.
    //        let percentageFormatter = NumberFormatter()
    //        percentageFormatter.numberStyle = .percent
    //        let formattedAdherence = percentageFormatter.string(from: NSNumber(value: medicationAdherence))!
    //
    //        let insight = OCKMessageItem(title: "MSleep", text: "Your sleep adherence was \(formattedAdherence) last week.", tintColor: Colors.pink.color, messageType: .tip)
    //
    //        return insight
    //    }
    
    
    
    
    // MARK: Walk
    func createWalkAdherenceInsight() -> OCKInsightItem? {
        // Make sure there are events to parse.
        guard let walkEvents = walkEvents else { return nil }
        print("print WalkEvents \(walkEvents.allEvents)")
        
        // Determine the start date for the previous week.
        let calendar = Calendar.current
        let now = Date()
        
        var components = DateComponents()
        components.day = -13
        let startDate = calendar.weekDatesForDate(calendar.date(byAdding: components as DateComponents, to: now)!).start
        
        var totalEventCount = 0
        var completedEventCount = 0
        
        for offset in (0...13).reversed() {
            components.day = offset
            let dayDate = calendar.date(byAdding: components as DateComponents, to: startDate)!
            let dayComponents = calendar.dateComponents([.year, .month, .day, .era], from: dayDate)
            let eventsForDay = walkEvents[dayComponents]
            print("Walk for offset in (0...13).reversed() \(dayComponents)")
            totalEventCount += eventsForDay.count
            
            for event in eventsForDay {
                if event.state == .completed {
                    completedEventCount += 1
                }
            }
        }
        
        guard totalEventCount > 0 else { return nil }
        
        // Calculate the percentage of completed events.
        let walkAdherence = Float(completedEventCount) / Float(totalEventCount)
        
        // Create an `OCKMessageItem` describing medical adherence.
        let percentageFormatter = NumberFormatter()
        percentageFormatter.numberStyle = .percent
        let formattedAdherence = percentageFormatter.string(from: NSNumber(value: walkAdherence))!
        
        let insight = OCKMessageItem(title: "Walk", text: "Your walk adherence was \(formattedAdherence).", tintColor: Colors.pink.color, messageType: .tip)
        
        return insight
    }
    
    // MARK: Proteins
    func createProteinsAdherenceInsight() -> OCKInsightItem? {
        // Make sure there are events to parse.
        guard let proteinsEvents = proteinsEvents else { return nil }
        print("print proteinsEvents \(proteinsEvents.allEvents)")
        
        // Determine the start date for the previous week.
        let calendar = Calendar.current
        let now = Date()
        
        var components = DateComponents()
        components.day = -13
        let startDate = calendar.weekDatesForDate(calendar.date(byAdding: components as DateComponents, to: now)!).start
        
        var totalEventCount = 0
        var completedEventCount = 0
        
        for offset in (0...13).reversed() {
            components.day = offset
            let dayDate = calendar.date(byAdding: components as DateComponents, to: startDate)!
            let dayComponents = calendar.dateComponents([.year, .month, .day, .era], from: dayDate)
            let eventsForDay = proteinsEvents[dayComponents]
            print("proteinsEvents for offset in (0...13).reversed() \(dayComponents)")
            totalEventCount += eventsForDay.count
            
            for event in eventsForDay {
                if event.state == .completed {
                    completedEventCount += 1
                }
            }
        }
        
        guard totalEventCount > 0 else { return nil }
        
        // Calculate the percentage of completed events.
        let proteinsAdherence = Float(completedEventCount) / Float(totalEventCount)
        
        // Create an `OCKMessageItem` describing medical adherence.
        let percentageFormatter = NumberFormatter()
        percentageFormatter.numberStyle = .percent
        let formattedAdherence = percentageFormatter.string(from: NSNumber(value: proteinsAdherence))!
        
        let insight = OCKMessageItem(title: "Proteins", text: "Your protein adherence was \(formattedAdherence) over the past 14 days.", tintColor: Colors.lightBlue.color, messageType: .tip)
        
        return insight
    }
    
    // MARK: FRUITS
    func createFruitsAdherenceInsight() -> OCKInsightItem? {
        // Make sure there are events to parse.
        guard let fruitsEvents = fruitsEvents else { return nil }
        print("print fruitsEvents \(fruitsEvents.allEvents)")
        
        // Determine the start date for the previous week.
        let calendar = Calendar.current
        let now = Date()
        
        var components = DateComponents()
        components.day = -13
        let startDate = calendar.weekDatesForDate(calendar.date(byAdding: components as DateComponents, to: now)!).start
        
        var totalEventCount = 0
        var completedEventCount = 0
        
        for offset in (0...13).reversed() {
            components.day = offset
            let dayDate = calendar.date(byAdding: components as DateComponents, to: startDate)!
            let dayComponents = calendar.dateComponents([.year, .month, .day, .era], from: dayDate)
            let eventsForDay = fruitsEvents[dayComponents]
            print("fruitsEvents for offset in (0...13).reversed() \(dayComponents)")
            totalEventCount += eventsForDay.count
            
            for event in eventsForDay {
                if event.state == .completed {
                    completedEventCount += 1
                }
            }
        }
        
        guard totalEventCount > 0 else { return nil }
        print("fruitsEvents guarded")
        // Calculate the percentage of completed events.
        let fruitsAdherence = Float(completedEventCount) / Float(totalEventCount)
        
        // Create an `OCKMessageItem` describing medical adherence.
        let percentageFormatter = NumberFormatter()
        percentageFormatter.numberStyle = .percent
        let formattedAdherence = percentageFormatter.string(from: NSNumber(value: fruitsAdherence))!
        
        let insight = OCKMessageItem(title: "Fruits", text: "Your fruit adherence was \(formattedAdherence) over the past 14 days.", tintColor: Colors.darkOrange.color, messageType: .tip)
        
        return insight
    }
    
    // MARK: VEGETABLES
    func createVegetablesAdherenceInsight() -> OCKInsightItem? {
        // Make sure there are events to parse.
        guard let vegetablesEvents = vegetablesEvents else { return nil }
        print("print vegetablesEvents \(vegetablesEvents.allEvents)")
        
        // Determine the start date for the previous week.
        let calendar = Calendar.current
        let now = Date()
        
        var components = DateComponents()
        components.day = -13
        let startDate = calendar.weekDatesForDate(calendar.date(byAdding: components as DateComponents, to: now)!).start
        
        var totalEventCount = 0
        var completedEventCount = 0
        
        for offset in (0...13).reversed() {
            components.day = offset
            let dayDate = calendar.date(byAdding: components as DateComponents, to: startDate)!
            let dayComponents = calendar.dateComponents([.year, .month, .day, .era], from: dayDate)
            let eventsForDay = vegetablesEvents[dayComponents]
            print("proteinsEvents for offset in (0...13).reversed() \(dayComponents)")
            totalEventCount += eventsForDay.count
            
            for event in eventsForDay {
                if event.state == .completed {
                    completedEventCount += 1
                }
            }
        }
        
        guard totalEventCount > 0 else { return nil }
        
        // Calculate the percentage of completed events.
        let vegetablesAdherence = Float(completedEventCount) / Float(totalEventCount)
        
        // Create an `OCKMessageItem` describing medical adherence.
        let percentageFormatter = NumberFormatter()
        percentageFormatter.numberStyle = .percent
        let formattedAdherence = percentageFormatter.string(from: NSNumber(value: vegetablesAdherence))!
        
        let insight = OCKMessageItem(title: "Vegetables", text: "Your vegetable adherence was \(formattedAdherence) over the past 14 days.", tintColor: Colors.darkOrange.color, messageType: .tip)
        
        return insight
    }
    
    
    
    
    // MARK: DAIRY
    func createDairyAdherenceInsight() -> OCKInsightItem? {
        // Make sure there are events to parse.
        guard let dairyEvents = dairyEvents else { return nil }
        print("print proteinsEvents \(dairyEvents.allEvents)")
        
        // Determine the start date for the previous week.
        let calendar = Calendar.current
        let now = Date()
        
        var components = DateComponents()
        components.day = -13
        let startDate = calendar.weekDatesForDate(calendar.date(byAdding: components as DateComponents, to: now)!).start
        
        var totalEventCount = 0
        var completedEventCount = 0
        
        for offset in (0...13).reversed() {
            components.day = offset
            let dayDate = calendar.date(byAdding: components as DateComponents, to: startDate)!
            let dayComponents = calendar.dateComponents([.year, .month, .day, .era], from: dayDate)
            let eventsForDay = dairyEvents[dayComponents]
            print("proteinsEvents for offset in (0...13).reversed() \(dayComponents)")
            totalEventCount += eventsForDay.count
            
            for event in eventsForDay {
                if event.state == .completed {
                    completedEventCount += 1
                }
            }
        }
        
        guard totalEventCount > 0 else { return nil }
        
        // Calculate the percentage of completed events.
        let dairyAdherence = Float(completedEventCount) / Float(totalEventCount)
        
        // Create an `OCKMessageItem` describing medical adherence.
        let percentageFormatter = NumberFormatter()
        percentageFormatter.numberStyle = .percent
        let formattedAdherence = percentageFormatter.string(from: NSNumber(value: dairyAdherence))!
        
        let insight = OCKMessageItem(title: "Dairy", text: "Your dairy adherence was \(formattedAdherence) over the past 14 days.", tintColor: Colors.darkOrange.color, messageType: .tip)
        
        return insight
    }
    
    // MARK: GRAINS
    func createGrainsAdherenceInsight() -> OCKInsightItem? {
        // Make sure there are events to parse.
        guard let grainsEvents = grainsEvents else { return nil }
        print("print grainsEvents \(grainsEvents.allEvents)")
        
        // Determine the start date for the previous week.
        let calendar = Calendar.current
        let now = Date()
        
        var components = DateComponents()
        components.day = -13
        let startDate = calendar.weekDatesForDate(calendar.date(byAdding: components as DateComponents, to: now)!).start
        
        var totalEventCount = 0
        var completedEventCount = 0
        
        for offset in (0...13).reversed() {
            components.day = offset
            let dayDate = calendar.date(byAdding: components as DateComponents, to: startDate)!
            let dayComponents = calendar.dateComponents([.year, .month, .day, .era], from: dayDate)
            let eventsForDay = grainsEvents[dayComponents]
            print("proteinsEvents for offset in (0...13).reversed() \(dayComponents)")
            totalEventCount += eventsForDay.count
            
            for event in eventsForDay {
                if event.state == .completed {
                    completedEventCount += 1
                }
            }
        }
        
        guard totalEventCount > 0 else { return nil }
        
        // Calculate the percentage of completed events.
        let grainsAdherence = Float(completedEventCount) / Float(totalEventCount)
        
        // Create an `OCKMessageItem` describing medical adherence.
        let percentageFormatter = NumberFormatter()
        percentageFormatter.numberStyle = .percent
        let formattedAdherence = percentageFormatter.string(from: NSNumber(value: grainsAdherence))!
        
        let insight = OCKMessageItem(title: "Grains", text: "Your grsin adherence was \(formattedAdherence) over the past 14 days.", tintColor: Colors.darkOrange.color, messageType: .tip)
        
        return insight
    }
    
    
    
    func createSleepAdherenceInsight() -> OCKInsightItem? {
        // Make sure there are events to parse.
        guard let sleepEvents = sleepEvents else { return nil }
        print("print sleepEvents \(sleepEvents.allEvents)")
        // Determine the start date for the previous week.
        let calendar = Calendar.current
        let now = Date()
        
        var components = DateComponents()
        components.day = -13
        let startDate = calendar.weekDatesForDate(calendar.date(byAdding: components as DateComponents, to: now)!).start
        
        var totalEventCount = 0
        var completedEventCount = 0
        
        for offset in (0...13).reversed() {
            components.day = offset
            let dayDate = calendar.date(byAdding: components as DateComponents, to: startDate)!
            let dayComponents = calendar.dateComponents([.year, .month, .day, .era], from: dayDate)
            let eventsForDay = sleepEvents[dayComponents]
            //: ## Creating dates from components
            
            print("Sleep for offset in (0...13).reversed() date: \(dayDate) : \(eventsForDay.count) : \(eventsForDay.description): \(dayComponents)")
            totalEventCount += eventsForDay.count
            
            for event in eventsForDay {
                print("Sleep for offset result: \(event)")
                if event.state == .completed {
                    completedEventCount += 1
                }
            }
        }
        
        guard totalEventCount > 0 else { return nil }
        
        // Calculate the percentage of completed events.
        let sleepAdherence = Float(completedEventCount) / Float(totalEventCount)
        
        // Create an `OCKMessageItem` describing medical adherence.
        let percentageFormatter = NumberFormatter()
        percentageFormatter.numberStyle = .percent
        let formattedAdherence = percentageFormatter.string(from: NSNumber(value: sleepAdherence))!
        
        let insight = OCKMessageItem(title: "Sleep", text: "Your sleep adherence was \(formattedAdherence) over the past 14 days.", tintColor: Colors.pink.color, messageType: .tip)
        
        return insight
    }
    
    
    //    // MARK: Dinner
    func createDinnerAdherenceInsight() -> OCKInsightItem? {
        // Make sure there are events to parse.
        guard let dinnerEvents = dinnerEvents else { return nil }
        
        // Determine the start date for the previous week.
        let calendar = Calendar.current
        let now = Date()
        
        var components = DateComponents()
        components.day = -13
        let startDate = calendar.weekDatesForDate(calendar.date(byAdding: components as DateComponents, to: now)!).start
        
        var totalEventCount = 0
        var completedEventCount = 0
        
        for offset in (0...13).reversed() {
            components.day = offset
            let dayDate = calendar.date(byAdding: components as DateComponents, to: startDate)!
            let dayComponents = calendar.dateComponents([.year, .month, .day, .era], from: dayDate)
            let eventsForDay = dinnerEvents[dayComponents]
            
            totalEventCount += eventsForDay.count
            
            for event in eventsForDay {
                if event.state == .completed {
                    completedEventCount += 1
                }
            }
        }
        
        guard totalEventCount > 0 else { return nil }
        
        // Calculate the percentage of completed events.
        let dinnerAdherence = Float(completedEventCount) / Float(totalEventCount)
        
        // Create an `OCKMessageItem` describing medical adherence.
        let percentageFormatter = NumberFormatter()
        percentageFormatter.numberStyle = .percent
        let formattedAdherence = percentageFormatter.string(from: NSNumber(value: dinnerAdherence))!
        
        let insight = OCKMessageItem(title: "Meals", text: "Your meal adherence was \(formattedAdherence) last month.", tintColor: Colors.pink.color, messageType: .tip)
        //            let insight = OCKMessageItem(title: "Meals", text: nil, tintColor: Colors.pink.color, messageType: .tip)
        
        return insight
    }
    
    //    // MARK: Snacks
    func createSnackAdherenceInsight() -> OCKInsightItem? {
        // Make sure there are events to parse.
        guard let snackEvents = snackEvents else { return nil }
        
        // Determine the start date for the previous week.
        let calendar = Calendar.current
        let now = Date()
        
        var components = DateComponents()
        components.day = -13
        let startDate = calendar.weekDatesForDate(calendar.date(byAdding: components as DateComponents, to: now)!).start
        
        var totalEventCount = 0
        var completedEventCount = 0
        
        for offset in (0...13).reversed() {
            components.day = offset
            let dayDate = calendar.date(byAdding: components as DateComponents, to: startDate)!
            let dayComponents = calendar.dateComponents([.year, .month, .day, .era], from: dayDate)
            let eventsForDay = snackEvents[dayComponents]
            
            totalEventCount += eventsForDay.count
            
            for event in eventsForDay {
                if event.state == .completed {
                    completedEventCount += 1
                }
            }
        }
        
        guard totalEventCount > 0 else { return nil }
        
        // Calculate the percentage of completed events.
        let snackAdherence = Float(completedEventCount) / Float(totalEventCount)
        
        // Create an `OCKMessageItem` describing medical adherence.
        let percentageFormatter = NumberFormatter()
        percentageFormatter.numberStyle = .percent
        let formattedAdherence = percentageFormatter.string(from: NSNumber(value: snackAdherence))!
        
        let insight = OCKMessageItem(title: "Snack", text: "Your snack adherence was \(formattedAdherence) last month", tintColor: Colors.yellow.color, messageType: .tip)
        //            let insight = OCKMessageItem(title: "Snack", text: nil, tintColor: Colors.yellow.color, messageType: .tip)
        
        return insight
    }
    
    
    func createGeneralHealthInsight() -> OCKInsightItem? {
        // Make sure there are events to parse.
        guard
            let walkEvents = walkEvents,
            let proteinsEvents = proteinsEvents,
            let fruitsEvents = fruitsEvents,
            let vegetablesEvents = vegetablesEvents,
            let dairyEvents = dairyEvents,
            let grainsEvents = grainsEvents,
            let sleepEvents = sleepEvents,
            let dinnerEvents = dinnerEvents, let snackEvents = snackEvents else { return nil }
        
        // Determine the date to start pain/medication comparisons from.
        let calendar = Calendar.current
        var components = DateComponents()
        components.day = -13
        
        let startDate = calendar.date(byAdding: components as DateComponents, to: Date())!
        
        // Create formatters for the data.
        let dayOfWeekFormatter = DateFormatter()
        dayOfWeekFormatter.dateFormat = "E"
        
        let shortDateFormatter = DateFormatter()
        shortDateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "Md", options: 0, locale: shortDateFormatter.locale)
        
        let percentageFormatter = NumberFormatter()
        percentageFormatter.numberStyle = .percent
        
        /*
         Loop through 7 days, collecting medication adherance and pain scores
         for each.
         */
        var walkValues = [Float]()
        var walkLabels = [String]()
        var proteinsValues = [Float]()
        var proteinsLabels = [String]()
        var fruitsValues = [Float]()
        var fruitsLabels = [String]()
        var vegetablesValues = [Float]()
        var vegetablesLabels = [String]()
        var dairyValues = [Float]()
        var dairyLabels = [String]()
        var grainsValues = [Float]()
        var grainsLabels = [String]()
        var sleepValues = [Float]()
        var sleepLabels = [String]()
        var dinnerValues = [Float]()
        var dinnerLabels = [String]()
        var snackValues = [Float]()
        var snackLabels = [String]()
        //        var painValues = [Int]()
        //        var painLabels = [String]()
        var axisTitles = [String]()
        var axisSubtitles = [String]()
        
       
        
        var someArrayDateStrings:[String] = []
        
        let keychain = KeychainSwift()
        var participant:String?
        if keychain.get("username_TRU-BLOOD") != nil {
            participant = keychain.get("username_TRU-BLOOD")
            //self.passwordTextField.text = keychain.get("password_TRU-BLOOD")//TEMP: remove
            
        } else {
            participant = "unknown"
        }
        
        for offset in (0...13).reversed() {
            // Determine the day to components.
            var someArray:[String] = []
            
            components.day = offset
            let dayDate = calendar.date(byAdding: components as DateComponents, to: startDate)!
            let dayComponents = calendar.dateComponents([.year, .month, .day, .era], from: dayDate)
            let userCalendar = Calendar.current
            let formatter = DateFormatter()
            
            
            formatter.dateFormat = "yyyy-MM-dd"
            
            
            let utcDateFormatter = DateFormatter()
            utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            let someDateTime = userCalendar.date(from: dayComponents as DateComponents!)
            let dateString = formatter.string(from: someDateTime!)
            someArray.append(dateString)
            //            // Store the pain result for the current day.
            //            if let result = generalHealthEvents[dayComponents].first?.result, let score = Int(result.valueString) , score > 0 {
            //                painValues.append(score)
            //                painLabels.append(result.valueString)
            //            }
            //            else {
            //                painValues.append(0)
            //                painLabels.append(NSLocalizedString("N/A", comment: ""))
            //            }
            
            // Store the walk adherance value for the current day.
            let walkEventsForDay = walkEvents[dayComponents]
            if let adherence = percentageEventsCompleted(walkEventsForDay) , adherence > 0.0 {
                // Scale the adherance to the same 0-10 scale as pain values.
                let scaledAdeherence = adherence * 10.0
                
                walkValues.append(scaledAdeherence)
                walkLabels.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
//                someDict.updateValue(percentageFormatter.string(from: NSNumber(value: adherence))!, forKey: "walk")
                someArray.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
                someArrayDateStrings.append(dateString)
            }
            else {
                walkValues.append(0.0)
                walkLabels.append(NSLocalizedString("N/A", comment: ""))
                someArray.append("-999")
                someArrayDateStrings.append(dateString)
            }
            
            print("dictionary someArray walkEventsForDay \(someArray) and \(someArrayDateStrings)")
            
            
            
            ///////////////  START PROTEINS
            let proteinsEventsForDay = proteinsEvents[dayComponents]
            if let adherence = percentageEventsCompleted(proteinsEventsForDay) , adherence > 0.0 {
                // Scale the adherance to the same 0-10 scale as pain values.
                let scaledAdeherence = adherence * 10.0
                
               proteinsValues.append(scaledAdeherence)
               proteinsLabels.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
                //                someDict.updateValue(percentageFormatter.string(from: NSNumber(value: adherence))!, forKey: "walk")
                someArray.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
                someArrayDateStrings.append(dateString)
            }
            else {
                proteinsValues.append(0.0)
                proteinsLabels.append(NSLocalizedString("N/A", comment: ""))
                someArray.append("-999")
                someArrayDateStrings.append(dateString)
            }
            
            print("dictionary someArray walkEventsForDay \(someArray) and \(someArrayDateStrings)")
            ///////////////  END PROTEINS
            
            
            
            ///////////////  START FRUITS
            let fruitsEventsForDay = fruitsEvents[dayComponents]
            if let adherence = percentageEventsCompleted(fruitsEventsForDay) , adherence > 0.0 {
                // Scale the adherance to the same 0-10 scale as pain values.
                let scaledAdeherence = adherence * 10.0
                
                fruitsValues.append(scaledAdeherence)
                fruitsLabels.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
                //                someDict.updateValue(percentageFormatter.string(from: NSNumber(value: adherence))!, forKey: "walk")
                someArray.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
                someArrayDateStrings.append(dateString)
            }
            else {
                fruitsValues.append(0.0)
                fruitsLabels.append(NSLocalizedString("N/A", comment: ""))
                someArray.append("-999")
                someArrayDateStrings.append(dateString)
            }
            
           // print("dictionary someArray walkEventsForDay \(someArray) and \(someArrayDateStrings)")
            ///////////////  END FRUITS
            
            
            ///////////////  START VEGETABLES
            let vegetablesEventsForDay = vegetablesEvents[dayComponents]
            if let adherence = percentageEventsCompleted(vegetablesEventsForDay) , adherence > 0.0 {
                // Scale the adherance to the same 0-10 scale as pain values.
                let scaledAdeherence = adherence * 10.0
                
                vegetablesValues.append(scaledAdeherence)
                vegetablesLabels.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
                //                someDict.updateValue(percentageFormatter.string(from: NSNumber(value: adherence))!, forKey: "walk")
                someArray.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
                someArrayDateStrings.append(dateString)
            }
            else {
                vegetablesValues.append(0.0)
                vegetablesLabels.append(NSLocalizedString("N/A", comment: ""))
                someArray.append("-999")
                someArrayDateStrings.append(dateString)
            }
            
           // print("dictionary someArray walkEventsForDay \(someArray) and \(someArrayDateStrings)")
            ///////////////  END VEGETABLES
            
            
            ///////////////  START DAIRY
            let dairyEventsForDay = dairyEvents[dayComponents]
            if let adherence = percentageEventsCompleted(dairyEventsForDay) , adherence > 0.0 {
                // Scale the adherance to the same 0-10 scale as pain values.
                let scaledAdeherence = adherence * 10.0
                
                dairyValues.append(scaledAdeherence)
                dairyLabels.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
                //                someDict.updateValue(percentageFormatter.string(from: NSNumber(value: adherence))!, forKey: "walk")
                someArray.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
                someArrayDateStrings.append(dateString)
            }
            else {
                dairyValues.append(0.0)
                dairyLabels.append(NSLocalizedString("N/A", comment: ""))
                someArray.append("-999")
                someArrayDateStrings.append(dateString)
            }
            
            print("dictionary someArray walkEventsForDay \(someArray) and \(someArrayDateStrings)")
            ///////////////  END DAIRY
            
            
            
            ///////////////  START GRAINS
            let grainsEventsForDay = grainsEvents[dayComponents]
            if let adherence = percentageEventsCompleted(grainsEventsForDay) , adherence > 0.0 {
                // Scale the adherance to the same 0-10 scale as pain values.
                let scaledAdeherence = adherence * 10.0
                
                grainsValues.append(scaledAdeherence)
                grainsLabels.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
                //                someDict.updateValue(percentageFormatter.string(from: NSNumber(value: adherence))!, forKey: "walk")
                someArray.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
                someArrayDateStrings.append(dateString)
            }
            else {
                grainsValues.append(0.0)
                grainsLabels.append(NSLocalizedString("N/A", comment: ""))
                someArray.append("-999")
                someArrayDateStrings.append(dateString)
            }
            
            print("dictionary someArray walkEventsForDay \(someArray) and \(someArrayDateStrings)")
            ///////////////  END GRAINS
            
            // Store the sleep adherance value for the current day.
            let sleepEventsForDay = sleepEvents[dayComponents]
            if let adherence = percentageEventsCompleted(sleepEventsForDay) , adherence > 0.0 {
                let scaledAdeherence = adherence * 10.0
                sleepValues.append(scaledAdeherence)
                sleepLabels.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
                someArray.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
            }
            else {
                sleepValues.append(0.0)
                sleepLabels.append(NSLocalizedString("N/A", comment: ""))
                someArray.append("-999")
            }
            
            
            
            
            
            let dinnerEventsForDay = dinnerEvents[dayComponents]
            if let adherence = percentageEventsCompleted(dinnerEventsForDay) , adherence > 0.0 {
                // Scale the adherance to the same 0-10 scale as pain values.
                let scaledAdeherence = adherence * 10.0
                
                dinnerValues.append(scaledAdeherence)
                dinnerLabels.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
//                someDict.updateValue(percentageFormatter.string(from: NSNumber(value: adherence))!, forKey: "meals")
                someArray.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
            }
            else {
                dinnerValues.append(0.0)
                dinnerLabels.append(NSLocalizedString("N/A", comment: ""))
                someArray.append("-999")
            }
            
            
            
            let snackEventsForDay = snackEvents[dayComponents]
            if let adherence = percentageEventsCompleted(snackEventsForDay) , adherence > 0.0 {
                // Scale the adherance to the same 0-10 scale as pain values.
                let scaledAdeherence = adherence * 10.0
                
                snackValues.append(scaledAdeherence)
                snackLabels.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
                //someDict.updateValue(percentageFormatter.string(from: NSNumber(value: adherence))!, forKey: "snacks")
                someArray.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
            }
            else {
                snackValues.append(0.0)
                snackLabels.append(NSLocalizedString("N/A", comment: ""))
                someArray.append("-999")
            }
            
            axisTitles.append(dayOfWeekFormatter.string(from: dayDate))
            axisSubtitles.append(shortDateFormatter.string(from: dayDate))
            
            print("dictionaryOfDailyEvents[dateString] = someDict \(someArray)" )

            let date = NSDate()
            let localDateString = utcDateFormatter.string(from: date as Date)
            someArray.append(localDateString)
            someArray.insert(participant!, at: 0)
            archive.append(someArray)
        }
        // Store the meal adherance value for the current day.
        
        
        let headerArray = ["participant","dayString","Walk","Proteins","Fruits","Vegetables","Dairy","Grains","Sleep","Meals","Snack","fileUploadedOn"]
        
        archive.remove(at: 0)
        archive.insert(headerArray, at: 0)
        print(archive)
        for var x in 0..<archive.count {
            var line = ""
            for var y in 0..<archive[x].count {
                line += String(archive[x][y])
                line += " "
            }
            print("My line starts here \(line)")
        }
        
        /*
        //upload array of arrays as a CSV file based on random number 0-10, only upload when number selected > 7
        let random = Int(arc4random_uniform(10))
        print("my random number: \(random)")
        
        if random > 7 {
            let uploadSymptomFocus = UploadApi()
            uploadSymptomFocus.writeAndUploadCSVToSharefile(forSymptomFocus: archive, "chartsData.csv")
            print("archive.append(someArray ) \(archive)")
        }*/
        
        //upload array of arrays as a CSV file each a seection is made from the health card screen
        let uploadSymptomFocus = UploadApi()
        uploadSymptomFocus.writeAndUploadCSVToSharefile(forSymptomFocus: archive, "chartsData.csv")
        print("archive.append(someArray ) \(archive)")
        
        // Create a `OCKBarSeries` for each set of data.
        //let painBarSeries = OCKBarSeries(title: "Pain", values: painValues as [NSNumber], valueLabels: painLabels, tintColor: Colors.lightBlue.color)
        let walkBarSeries = OCKBarSeries(title: "Walk", values: walkValues as [NSNumber], valueLabels: walkLabels, tintColor: Colors.blue.color)
        let proteinsBarSeries = OCKBarSeries(title: "Proteins", values: proteinsValues as [NSNumber], valueLabels: proteinsLabels, tintColor: Colors.redMeat.color)
        let fruitsBarSeries = OCKBarSeries(title: "Fruits", values: fruitsValues as [NSNumber], valueLabels: fruitsLabels, tintColor: Colors.orange.color)
        let vegetablesBarSeries = OCKBarSeries(title: "Vegetables", values: vegetablesValues as [NSNumber], valueLabels: vegetablesLabels, tintColor: Colors.green.color)
        let dairyBarSeries = OCKBarSeries(title: "Dairy", values: dairyValues as [NSNumber], valueLabels: dairyLabels, tintColor: Colors.lightBlue.color)
        let grainsBarSeries = OCKBarSeries(title: "Grains", values: grainsValues as [NSNumber], valueLabels: grainsLabels, tintColor: Colors.wheat.color)
        let sleepBarSeries = OCKBarSeries(title: "Sleep", values: sleepValues as [NSNumber], valueLabels: sleepLabels, tintColor: Colors.blue.color)
        let dinnerBarSeries = OCKBarSeries(title: "Meals", values: dinnerValues as [NSNumber], valueLabels: dinnerLabels, tintColor: Colors.green.color)
        let snackBarSeries = OCKBarSeries(title: "Snacks", values: snackValues as [NSNumber], valueLabels: snackLabels, tintColor: Colors.lightBlue.color)
        
        /*
         Add the series to a chart, specifing the scale to use for the chart
         rather than having CareKit scale the bars to fit.
        */
        
        //let string = archive
        let chart = OCKBarChart(title: nil,
                                text: "Care Plan Charts",
                                tintColor: Colors.red.color,
                                axisTitles: axisTitles,
                                axisSubtitles: axisSubtitles,
                                dataSeries: [walkBarSeries, proteinsBarSeries, fruitsBarSeries, vegetablesBarSeries, dairyBarSeries, grainsBarSeries],
                                minimumScaleRangeValue: 0,
                                maximumScaleRangeValue: 10)
        

        
//        print("printing sleepseries::::: \(sleepBarSeries.values) ")
//        print("printing walkseries::::: \(walkBarSeries.values) ")
//        print("printing snackseries::::: \(snackBarSeries.values) ")
//        print("printing dinnerseries::::: \(dinnerBarSeries.values)  ")
//        
//        print("printing sleepseries value labels::::: \(sleepBarSeries.valueLabels) ")
//        print("printing walkseries::::: \(walkBarSeries.values) ")
//        print("printing snackseries::::: \(snackBarSeries.values) ")
//        print("printing dinnerseries::::: \(dinnerBarSeries.values)  ")
        
        return chart
    }
    
    /**
     For a given array of `OCKCarePlanEvent`s, returns the percentage that are
     marked as completed.
     */
    fileprivate func percentageEventsCompleted(_ events: [OCKCarePlanEvent]) -> Float? {
        guard !events.isEmpty else { return nil }
        
        let completedCount = events.filter({ event in
            event.state == .completed
        }).count
        
        return Float(completedCount) / Float(events.count)
    }
}

/**
 An extension to `SequenceType` whose elements are `OCKCarePlanEvent`s. The
 extension adds a method to return the first element that matches the day
 specified by the supplied `NSDateComponents`.
 */
extension Sequence where Iterator.Element: OCKCarePlanEvent {
    
    func eventForDay(_ dayComponents: NSDateComponents) -> Iterator.Element? {
        for event in self where
            event.date.year == dayComponents.year &&
                event.date.month == dayComponents.month &&
                event.date.day == dayComponents.day {
                    return event
        }
        
        return nil
    }
}





































//import CareKit
//
//class BuildInsightsOperation: Operation {
//
//    // MARK: Properties
//
//    var medicationEvents: DailyEvents?
//    var generalHealthEvents: DailyEvents?
//    var walkEvents: DailyEvents?
//    var breakfastEvents: DailyEvents?
//    var lunchEvents: DailyEvents?
//    var dinnerEvents: DailyEvents?
//    var snackEvents: DailyEvents?
//
//
//    var takeMedicationEvents: DailyEvents?
//    var generalHealthEvents: DailyEvents?
//    var rashEvents: DailyEvents?
//    var nauseaEvents: DailyEvents?
//    var vomitingEvents: DailyEvents?
//    var diarrheaEvents: DailyEvents?
//    var stoolEvents: DailyEvents?
//    var moodEvents: DailyEvents?
//    var stressEvents: DailyEvents?
//    var usualSelfEvents: DailyEvents?
//
//    //VOPAM
//    var menstruatingEvents: DailyEvents?
//    var menstrualFlowEvents: DailyEvents?
//    var fatigueEvents: DailyEvents?
//    var scdPainEvents: DailyEvents?
//    var painDifferentiationEvents: DailyEvents?
//    var abdominalCrampEvents: DailyEvents?
//    var bodyLocationEvents: DailyEvents?
//    var urineCollectionEvents: DailyEvents?
//    var spottingEvents: DailyEvents?
//
//
//
//    fileprivate(set) var insights = [OCKInsightItem.emptyInsightsMessage()]
//
//    // MARK: NSOperation
//
//    override func main() {
//        // Do nothing if the operation has been cancelled.
//        guard !isCancelled else { return }
//
//        // Create an array of insights.
//        var newInsights = [OCKInsightItem]()
//
//        if let insight = createWalkAdherenceInsight() {
//            newInsights.append(insight)
//        }
//        if let insight = createMedicationAdherenceInsight() { //this is the sleep insight
//            newInsights.append(insight)
//        }
//
//
////        if let insight = createBreakfastAdherenceInsight() {
////            newInsights.append(insight)
////        }
////
////        if let insight = createLunchAdherenceInsight() {
////            newInsights.append(insight)
////        }
//
////        if let insight = createDinnerAdherenceInsight() {
////            newInsights.append(insight)
////        }
//
////        if let insight = createSnackAdherenceInsight() {
////            newInsights.append(insight)
////        }
//
//
//        if let insight = creategeneralHealthInsight() {
//            newInsights.append(insight)
//        }
//        //        //VOPAM
//        //        if let insight = createWalkAdherenceInsight() {
//        //            newInsights.append(insight)
//        //        }
//
//
//
//
//        // Store any new insights thate were created.
//        if !newInsights.isEmpty {
//            insights = newInsights
//        }
//    }
//
//    // MARK: Convenience
//    func createMedicationAdherenceInsight() -> OCKInsightItem? {
//        // Make sure there are events to parse.
//        guard let medicationEvents = medicationEvents else { return nil }
//
//        // Determine the start date for the previous week.
//        let calendar = Calendar.current
//        let now = Date()
//
//        var components = DateComponents()
//        components.day = -30
//        let startDate = calendar.weekDatesForDate(calendar.date(byAdding: components as DateComponents, to: now)!).start
//
//        var totalEventCount = 0
//        var completedEventCount = 0
//
//        for offset in 0..<30 {
//            components.day = offset
//            let dayDate = calendar.date(byAdding: components as DateComponents, to: startDate)!
//            let dayComponents = calendar.dateComponents([.year, .month, .day, .era], from: dayDate)
//            let eventsForDay = medicationEvents[dayComponents]
//
//            totalEventCount += eventsForDay.count
//
//            for event in eventsForDay {
//                if event.state == .completed {
//                    completedEventCount += 1
//                }
//            }
//        }
//
//        guard totalEventCount > 0 else { return nil }
//
//        // Calculate the percentage of completed events.
//        let medicationAdherence = Float(completedEventCount) / Float(totalEventCount)
//
//        // Create an `OCKMessageItem` describing medical adherence.
//        let percentageFormatter = NumberFormatter()
//        percentageFormatter.numberStyle = .percent
//        let formattedAdherence = percentageFormatter.string(from: NSNumber(value: medicationAdherence))!
//
//        let insight = OCKMessageItem(title: "Sleep", text: "Your reach \(formattedAdherence) of the goal this week.", tintColor: Colors.pink.color, messageType: .tip)
//
//        return insight
//    }
//
//    // MARK: Convenience
//    func createTakeMedicationAdherenceInsight() -> OCKInsightItem? {
//        // Make sure there are events to parse.
//        guard let takeMedicationEvents = takeMedicationEvents else { return nil }
//
//        // Determine the start date for the previous week.
//        let calendar = Calendar.current
//        let now = Date()
//
//        var components = DateComponents()
//        components.day = -30
//        let startDate = calendar.weekDatesForDate(calendar.date(byAdding: components as DateComponents, to: now)!).start
//
//        var totalEventCount = 0
//        var completedEventCount = 0
//
//        for offset in 0..<30 {
//            components.day = offset
//            let dayDate = calendar.date(byAdding: components as DateComponents, to: startDate)!
//            let dayComponents = calendar.dateComponents([.year, .month, .day, .era], from: dayDate)
//            let eventsForDay = takeMedicationEvents[dayComponents]
//
//            totalEventCount += eventsForDay.count
//
//            for event in eventsForDay {
//                if event.state == .completed {
//                    completedEventCount += 1
//                }
//            }
//        }
//
//        guard totalEventCount > 0 else { return nil }
//
//        // Calculate the percentage of completed events.
//        let takeMedicationAdherence = Float(completedEventCount) / Float(totalEventCount)
//
//        // Create an `OCKMessageItem` describing medical adherence.
//        let percentageFormatter = NumberFormatter()
//        percentageFormatter.numberStyle = .percent
//        let formattedAdherence = percentageFormatter.string(from: NSNumber(value: takeMedicationAdherence))!
//
//        let insight = OCKMessageItem(title: "Prescription", text: "Your reach \(formattedAdherence) of the goal last week.", tintColor: Colors.pink.color, messageType: .tip)
//
//        return insight
//    }
//
//
//    // MARK: Breakfast
//    func createWalkAdherenceInsight() -> OCKInsightItem? {
//        // Make sure there are events to parse.
//        guard let walkEvents = walkEvents else { return nil }
//
//        // Determine the start date for the previous week.
//        let calendar = Calendar.current
//        let now = Date()
//
//        var components = DateComponents()
//        components.day = -30
//        let startDate = calendar.weekDatesForDate(calendar.date(byAdding: components as DateComponents, to: now)!).start
//
//        var totalEventCount = 0
//        var completedEventCount = 0
//
//        for offset in 0..<30 {
//            components.day = offset
//            let dayDate = calendar.date(byAdding: components as DateComponents, to: startDate)!
//            let dayComponents = calendar.dateComponents([.year, .month, .day, .era], from: dayDate)
//            let eventsForDay = walkEvents[dayComponents]
//
//            totalEventCount += eventsForDay.count
//
//            for event in eventsForDay {
//                if event.state == .completed {
//                    completedEventCount += 1
//                }
//            }
//        }
//
//        guard totalEventCount > 0 else { return nil }
//
//        // Calculate the percentage of completed events.
//        let walkAdherence = Float(completedEventCount) / Float(totalEventCount)
//
//        // Create an `OCKMessageItem` describing medical adherence.
//        let percentageFormatter = NumberFormatter()
//        percentageFormatter.numberStyle = .percent
//        let formattedAdherence = percentageFormatter.string(from: NSNumber(value: walkAdherence))!
//
//        let insight = OCKMessageItem(title: "Walk", text: "Your walk adherence was \(formattedAdherence) of the goal last week.", tintColor: Colors.pink.color, messageType: .tip)
//
//        return insight
//    }
//
//    // MARK: Breakfast
//    func createBreakfastAdherenceInsight() -> OCKInsightItem? {
//        // Make sure there are events to parse.
//        guard let breakfastEvents = breakfastEvents else { return nil }
//
//        // Determine the start date for the previous week.
//        let calendar = Calendar.current
//        let now = Date()
//
//        var components = DateComponents()
//        components.day = -30
//        let startDate = calendar.weekDatesForDate(calendar.date(byAdding: components as DateComponents, to: now)!).start
//
//        var totalEventCount = 0
//        var completedEventCount = 0
//
//        for offset in 0..<30 {
//            components.day = offset
//            let dayDate = calendar.date(byAdding: components as DateComponents, to: startDate)!
//            let dayComponents = calendar.dateComponents([.year, .month, .day, .era], from: dayDate)
//            let eventsForDay = breakfastEvents[dayComponents]
//
//            totalEventCount += eventsForDay.count
//
//            for event in eventsForDay {
//                if event.state == .completed {
//                    completedEventCount += 1
//                }
//            }
//        }
//
//        guard totalEventCount > 0 else { return nil }
//
//        // Calculate the percentage of completed events.
//        let breakfastAdherence = Float(completedEventCount) / Float(totalEventCount)
//
//        // Create an `OCKMessageItem` describing medical adherence.
//        let percentageFormatter = NumberFormatter()
//        percentageFormatter.numberStyle = .percent
//        let formattedAdherence = percentageFormatter.string(from: NSNumber(value: breakfastAdherence))!
//
//        let insight = OCKMessageItem(title: "Breakfast", text: "Your breakfast adherence was \(formattedAdherence) last week.", tintColor: Colors.pink.color, messageType: .tip)
//
//        return insight
//    }
//
//    // MARK: Lunch
//    func createLunchAdherenceInsight() -> OCKInsightItem? {
//        // Make sure there are events to parse.
//        guard let lunchEvents = lunchEvents else { return nil }
//
//        // Determine the start date for the previous week.
//        let calendar = Calendar.current
//        let now = Date()
//
//        var components = DateComponents()
//        components.day = -30
//        let startDate = calendar.weekDatesForDate(calendar.date(byAdding: components as DateComponents, to: now)!).start
//
//        var totalEventCount = 0
//        var completedEventCount = 0
//
//        for offset in 0..<30 {
//            components.day = offset
//            let dayDate = calendar.date(byAdding: components as DateComponents, to: startDate)!
//            let dayComponents = calendar.dateComponents([.year, .month, .day, .era], from: dayDate)
//            let eventsForDay = lunchEvents[dayComponents]
//
//            totalEventCount += eventsForDay.count
//
//
//            for event in eventsForDay {
//                if event.state == .completed {
//                    completedEventCount += 1
//                }
//            }
//        }
//
//        guard totalEventCount > 0 else { return nil }
//
//        // Calculate the percentage of completed events.
//        let lunchAdherence = Float(completedEventCount) / Float(totalEventCount)
//
//        // Create an `OCKMessageItem` describing medical adherence.
//        let percentageFormatter = NumberFormatter()
//        percentageFormatter.numberStyle = .percent
//        let formattedAdherence = percentageFormatter.string(from: NSNumber(value:lunchAdherence))!
//
//        let insight = OCKMessageItem(title: "Lunch", text: "Your lunch adherence was \(formattedAdherence) last week.", tintColor: Colors.pink.color, messageType: .tip)
//
//        return insight
//    }
//
//    // MARK: Dinner
//    func createDinnerAdherenceInsight() -> OCKInsightItem? {
//        // Make sure there are events to parse.
//        guard let dinnerEvents = dinnerEvents else { return nil }
//
//        // Determine the start date for the previous week.
//        let calendar = Calendar.current
//        let now = Date()
//
//        var components = DateComponents()
//        components.day = -30
//        let startDate = calendar.weekDatesForDate(calendar.date(byAdding: components as DateComponents, to: now)!).start
//
//        var totalEventCount = 0
//        var completedEventCount = 0
//
//        for offset in 0..<30 {
//            components.day = offset
//            let dayDate = calendar.date(byAdding: components as DateComponents, to: startDate)!
//            let dayComponents = calendar.dateComponents([.year, .month, .day, .era], from: dayDate)
//            let eventsForDay = dinnerEvents[dayComponents]
//
//            totalEventCount += eventsForDay.count
//
//            for event in eventsForDay {
//                if event.state == .completed {
//                    completedEventCount += 1
//                }
//            }
//        }
//
//        guard totalEventCount > 0 else { return nil }
//
//        // Calculate the percentage of completed events.
//        let dinnerAdherence = Float(completedEventCount) / Float(totalEventCount)
//
//        // Create an `OCKMessageItem` describing medical adherence.
//        let percentageFormatter = NumberFormatter()
//        percentageFormatter.numberStyle = .percent
//        let formattedAdherence = percentageFormatter.string(from: NSNumber(value: dinnerAdherence))!
//
//        let insight = OCKMessageItem(title: "Dinner", text: "Your dinner adherence was \(formattedAdherence) last week.", tintColor: Colors.pink.color, messageType: .tip)
//
//        return insight
//    }
//
//    // MARK: Breakfast
//    func createSnackAdherenceInsight() -> OCKInsightItem? {
//        // Make sure there are events to parse.
//        guard let snackEvents = snackEvents else { return nil }
//
//        // Determine the start date for the previous week.
//        let calendar = Calendar.current
//        let now = Date()
//
//        var components = DateComponents()
//        components.day = -30
//        let startDate = calendar.weekDatesForDate(calendar.date(byAdding: components as DateComponents, to: now)!).start
//
//        var totalEventCount = 0
//        var completedEventCount = 0
//
//        for offset in 0..<30 {
//            components.day = offset
//            let dayDate = calendar.date(byAdding: components as DateComponents, to: startDate)!
//            let dayComponents = calendar.dateComponents([.year, .month, .day, .era], from: dayDate)
//            let eventsForDay = snackEvents[dayComponents]
//
//            totalEventCount += eventsForDay.count
//
//            for event in eventsForDay {
//                if event.state == .completed {
//                    completedEventCount += 1
//                }
//            }
//        }
//
//        guard totalEventCount > 0 else { return nil }
//
//        // Calculate the percentage of completed events.
//        let snackAdherence = Float(completedEventCount) / Float(totalEventCount)
//
//        // Create an `OCKMessageItem` describing medical adherence.
//        let percentageFormatter = NumberFormatter()
//        percentageFormatter.numberStyle = .percent
//        let formattedAdherence = percentageFormatter.string(from: NSNumber(value: snackAdherence))!
//
//        let insight = OCKMessageItem(title: "Snack", text: "Your snack adherence was \(formattedAdherence) last week.", tintColor: Colors.yellow.color, messageType: .tip)
//
//        return insight
//    }
//
//    func creategeneralHealthInsight() -> OCKInsightItem? {
//        print(" \n medicationEvents: \(medicationEvents)")
//        print(" \n breakfastEvents:  \(breakfastEvents)")
//        print(" \n lunchEvents: \(lunchEvents)")
//        print(" \n dinnerEvents: \(dinnerEvents)")
//        print(" \n snackEvents: \(snackEvents)")
//        print(" \n walkEvents: \(walkEvents)")
//        print(" \n generalHealthEvents: \(generalHealthEvents)")
//        print(" \n takeMedicationEvents: \(takeMedicationEvents)")
//        print(" \n moodEvents: \(moodEvents)")
//        print(" \n stressEvents: \(stressEvents)")
//        print(" \n generalHealthEvents: \(generalHealthEvents)")
//        print(" \n rashEvents \(rashEvents)")
//        print(" \n breakfastEvents:  \(nauseaEvents)")
//        print(" \n lunchEvents: \(vomitingEvents)")
//        print(" \n stoolEvents: \(stoolEvents)")
//        print(" \n diarrheaEvents: \(diarrheaEvents)")
//        print(" \n usualSelfEvents: \(usualSelfEvents)")
//        print(" \n menstruatingEvents: \(menstruatingEvents)")
//        print(" \n fatigueEvents: \(fatigueEvents)")
//        print(" \n scdPainEvents: \(scdPainEvents)")
//        print(" \n  painDifferentiationEvents: \( painDifferentiationEvents)")
//        print(" \n abdominalCrampEvents: \(abdominalCrampEvents)")
//
//        print(" \n bodyLocationEvents:  \(bodyLocationEvents)")
//        print(" \n urineCollectionEvents: \(urineCollectionEvents)")
//        print(" \n spottingEvents: \(spottingEvents)")
//
//
//        // Make sure there are events to parse.
//        guard let medicationEvents = medicationEvents,
////            let breakfastEvents = breakfastEvents,
////            let lunchEvents = lunchEvents,
//            let dinnerEvents = dinnerEvents,
//            let snackEvents = snackEvents,
//            let walkEvents = walkEvents,
////            let generalHealthEvents = generalHealthEvents,
////            let takeMedicationEvents = takeMedicationEvents,
//            let moodEvents = moodEvents,
//            let stressEvents = stressEvents,
//            let generalHealthEvents = generalHealthEvents,
////            let rashEvents = rashEvents,
////            let nauseaEvents = nauseaEvents,
////            let vomitingEvents = vomitingEvents,
////            let stoolEvents = stoolEvents,
////            let diarrheaEvents = diarrheaEvents,
//            let usualSelfEvents = usualSelfEvents,
//            let menstruatingEvents = menstruatingEvents,
//            let menstrualFlowEvents = menstrualFlowEvents,
//            let fatigueEvents = fatigueEvents,
//            let scdPainEvents = scdPainEvents,
////            let painDifferentiationEvents = painDifferentiationEvents,
//            let abdominalCrampEvents = abdominalCrampEvents,
//            let bodyLocationEvents = bodyLocationEvents,
//            let urineCollectionEvents = urineCollectionEvents,
//            let spottingEvents = spottingEvents
//
//
//
//            //VOPAM
//
//
//            else {
//                print("missing a data point")
//
//                return nil
//        }
//
//
//        print("Determine the date to start")
//        // Determine the date to start pain/medication comparisons from.
//        let calendar = Calendar.current
//        var components = DateComponents()
//        components.day = -30
//
//        let startDate = calendar.date(byAdding: components as DateComponents, to: Date())!
//
//        // Create formatters for the data.
//        let dayOfWeekFormatter = DateFormatter()
//        dayOfWeekFormatter.dateFormat = "E"
//
//        let shortDateFormatter = DateFormatter()
//        shortDateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "Md", options: 0, locale: shortDateFormatter.locale)
//
//        let percentageFormatter = NumberFormatter()
//        percentageFormatter.numberStyle = .percent
//
//        /*
//         Loop through 7 days, collecting medication adherance and pain scores
//         for each.
//         */
//
//        var axisTitles = [String]()
//        var axisSubtitles = [String]()
//
//
//        var medicationValues = [Float]()
//        var medicationLabels = [String]()
//
//        var breakfastValues = [Float]()
//        var breakfastLabels = [String]()
//        var lunchValues = [Float]()
//        var lunchLabels = [String]()
//        var dinnerValues = [Float]()
//        var dinnerLabels = [String]()
//        var snackValues = [Float]()
//        var snackLabels = [String]()
//        var walkValues = [Float]()
//        var walkLabels = [String]()
//        var painValues = [Int]()
//        var painLabels = [String]()
//        var moodValues = [Int]()
//        var moodLabels = [String]()
//        var stressValues = [Int]()
//        var stressLabels = [String]()
//        var generalHealthValues = [Int]()
//        var generalHealthLabels = [String]()
//        var rashValues = [Int]()
//        var rashLabels = [String]()
//        var nauseaValues = [Int]()
//        var nauseaLabels = [String]()
//        var vomitingValues = [Int]()
//        var vomitingLabels = [String]()
//        var stoolValues = [Int]()
//        var stoolLabels = [String]()
//        var diarrheaValues = [Int]()
//        var diarrheaLabels = [String]()
//        var usualSelfLabels = [String]()
//        var usualSelfValues = [Int]()
//        var takeMedicationLabels = [String]()
//        var takeMedicationValues = [Int]()
//
//        //VOPAM
//        var menstruatingValues = [Int]()
//        var menstruatingLabels = [String]()
//        var painDifferentiationValues = [Int]()
//        var painDifferentiationLabels = [String]()
//        var fatigueValues = [Int]()
//        var fatigueLabels = [String]()
//        var scdPainValues = [Int]()
//        var scdPainLabels = [String]()
//        var abdominalCrampValues = [Int]()
//        var abdominalCrampLabels = [String]()
//        var menstrualFlowValues = [Int]()
//        var menstrualFlowLabels = [String]()
//        var urineCollectionValues = [String]()
//        var urineCollectionLabels = [String]()
//        var spottingValues = [Int]()
//        var spottingLabels = [String]()
//
//        var bodyLocationValues = [String]()
//        var bodyLocationLabels = [String]()
//
//
//        var someDict:[String:String] = [
//            //"breakfast":"-99",
//            //"lunch":"-99",
//            "dinner":"-99",
//            "snack":"-99",
//            "walk":"-99",
//            "sleep":"-99",
//            "generalHealth":"-99",
////            "rash":"-99",
////            "nausea":"-99",
////            "vomiting":"-99",
////            "stool":"-99",
////            "diarrhea":"-99",
//            "usualSelf":"-99",
//            //"takeMedication":"-99",
//            "moodNRS":"-99",
//            "stressNRS":"-99",
//            "fatigueNRS":"-99",
//            //"painNRS":"-99",
//            "scdPainNRS":"-99",
//            "abdominalCrampNRS":"-99",
//            //"painDifferentiation":"-99",
//            "spotting":"-99",
//            "urineCollectionTime":"-99",
//            "menstruating":"-99",
//            "menstrualFlowNRS":"-99"]
//
//        var dictionaryOfDailyEvents:[String:[String:String]] = [String: [String:String]]()
//
//        for offset in 0..<30 {
//            print("Determine the day to components.")
//            // Determine the day to components.
//            components.day = offset
//            let dayDate = calendar.date(byAdding: components as DateComponents, to: startDate)!
//            let dayComponents = calendar.dateComponents([.year, .month, .day, .era], from: dayDate)
//
//            let userCalendar = Calendar.current
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd"
//
//            let someDateTime = userCalendar.date(from: dayComponents as DateComponents!)
//            let dateString = formatter.string(from: someDateTime!)
//
//            //let dateString =  (dayComponents.year?.description)!+(dayComponents.month?.description)!+(dayComponents.day?.description)!
//
//            // Store the generalHealth result for the current day.
//            if let result = generalHealthEvents[dayComponents].first?.result, let score = Int(result.valueString) , score >= 0 {
//                generalHealthValues.append(score)
//                generalHealthLabels.append(result.valueString)
//                print("generalHealth score \(score)")
//                someDict.updateValue(result.valueString, forKey: "generalHealth")
//            }
//            else {
//                generalHealthValues.append(0)
//                generalHealthLabels.append(NSLocalizedString("N/A", comment: ""))
//                someDict.updateValue("-99", forKey: "generalHealth")
//
//            }
//
//            print("fatigue first result \(fatigueEvents[dayComponents].first?.result?.valueString)")
//
//            // VOPAM: Store the Fatigue result for the current day.
//            if let result = fatigueEvents[dayComponents].first?.result, let score = Int(result.valueString) , score >= 0 {
//                fatigueValues.append(score)
//                fatigueLabels.append(result.valueString)
//                print("fatigue score \(score)")
//                someDict.updateValue(result.valueString, forKey: "fatigueNRS")
//            }
//            else {
//                fatigueValues.append(0)
//                fatigueLabels.append(NSLocalizedString("N/A", comment: ""))
//                someDict.updateValue("-99", forKey: "fatigueNRS")
//
//            }
//
//            // VOPAM: Store the Fatigue result for the current day.
//            if let result = scdPainEvents[dayComponents].first?.result, let score = Int(result.valueString) , score >= 0 {
//                scdPainValues.append(score)
//                scdPainLabels.append(result.valueString)
//                print("scdPainNRS score \(score)")
//                someDict.updateValue(result.valueString, forKey: "scdPainNRS")
//            }
//            else {
//                scdPainValues.append(0)
//                scdPainLabels.append(NSLocalizedString("N/A", comment: ""))
//                someDict.updateValue("-99", forKey: "scdPainNRS")
//
//            }
//
//
//            // VOPAM: Store the Fatigue result for the current day.
//            if let result = abdominalCrampEvents[dayComponents].first?.result, let score = Int(result.valueString) , score >= 0 {
//                abdominalCrampValues.append(score)
//                abdominalCrampLabels.append(result.valueString)
//                print("abdominalCrampNRS score \(score)")
//                someDict.updateValue(result.valueString, forKey: "abdominalCrampNRS")
//            }
//            else {
//                abdominalCrampValues.append(0)
//                abdominalCrampLabels.append(NSLocalizedString("N/A", comment: ""))
//                someDict.updateValue("-99", forKey: "abdominalCrampNRS")
//
//            }
//
//            // Store the rashEvents result for the current day.
////            if let result = rashEvents[dayComponents].first?.result, let score = Int(result.valueString) , score >= 0 {
////                rashValues.append(score)
////                rashLabels.append(result.valueString)
////                print("rash score \(score)")
////                someDict.updateValue(result.valueString, forKey: "rash")
////            }
////            else {
////                rashValues.append(0)
////                rashLabels.append(NSLocalizedString("N/A", comment: ""))
////
////            }
//
//            // Store the nausea result for the current day.
////            if let result = nauseaEvents[dayComponents].first?.result, let score = Int(result.valueString) , score >= 0 {
////                nauseaValues.append(score)
////                nauseaLabels.append(result.valueString)
////                print("nausea score \(score)")
////                someDict.updateValue(result.valueString, forKey: "nausea")
////            }
////            else {
////                nauseaValues.append(0)
////                nauseaLabels.append(NSLocalizedString("N/A", comment: ""))
////
////            }
//
//            // Store the vomiting result for the current day.
////            if let result = vomitingEvents[dayComponents].first?.result, let score = Int(result.valueString) , score >= 0 {
////                vomitingValues.append(score)
////                vomitingLabels.append(result.valueString)
////                print("vomiting score \(score)")
////                someDict.updateValue(result.valueString, forKey: "vomiting")
////            }
////            else {
////                vomitingValues.append(0)
////                vomitingLabels.append(NSLocalizedString("N/A", comment: ""))
////
////            }
////
//
//            // Store the stool result for the current day.
////            if let result = stoolEvents[dayComponents].first?.result, let score = Int(result.valueString) , score >= 0 {
////                stoolValues.append(score)
////                stoolLabels.append(result.valueString)
////                print("stool score \(score)")
////                someDict.updateValue(result.valueString, forKey: "stool")
////            }
////            else {
////                stoolValues.append(0)
////                stoolLabels.append(NSLocalizedString("N/A", comment: ""))
////
////            }
//
//            // Store the diarrhea result for the current day.
////            if let result = diarrheaEvents[dayComponents].first?.result, let score = Int(result.valueString) , score >= 0 {
////                diarrheaValues.append(score)
////                diarrheaLabels.append(result.valueString)
////                print("diarrhea score \(score)")
////                someDict.updateValue(result.valueString, forKey: "diarrhea")
////            }
////            else {
////                diarrheaValues.append(0)
////                diarrheaLabels.append(NSLocalizedString("N/A", comment: ""))
////
////            }
//
//            // Store the usualSelf result for the current day.
//            if let result = usualSelfEvents[dayComponents].first?.result, let score = Int(result.valueString) , score >= 0 {
//                usualSelfValues.append(score)
//                usualSelfLabels.append(result.valueString)
//                print("usualSelf score \(score)")
//                someDict.updateValue(result.valueString, forKey: "usualSelf")
//            }
//            else {
//                usualSelfValues.append(0)
//                usualSelfLabels.append(NSLocalizedString("N/A", comment: ""))
//
//            }
//
//
//            // Store the pain result for the current day.
////            if let result = generalHealthEvents[dayComponents].first?.result, let score = Int(result.valueString) , score >= 0 {
////                painValues.append(score)
////                painLabels.append(result.valueString)
////                print("pain score \(score)")
////                someDict.updateValue(result.valueString, forKey: "painNRS")
////            }
////            else {
////                painValues.append(0)
////                painLabels.append(NSLocalizedString("N/A", comment: ""))
////
////            }
//
//            // Store the mood result for the current day.
//            if let result = moodEvents[dayComponents].first?.result, let score = Int(result.valueString) , score >= 0 {
//                moodValues.append(score)
//                moodLabels.append(result.valueString)
//                print("Mood score \(score)")
//                someDict.updateValue(result.valueString, forKey: "moodNRS")
//            }
//            else {
//                moodValues.append(0)
//                moodLabels.append(NSLocalizedString("N/A", comment: ""))
//
//            }
//
//            // Store the stress result for the current day.
//                        if let result = stressEvents[dayComponents].first?.result, let score = Int(result.valueString) , score >= 0 {
//                            stressValues.append(score)
//                            stressLabels.append(result.valueString)
//                            print("Stress score \(score)")
//                            someDict.updateValue(result.valueString, forKey: "stressNRS")
//                        }
//                        else {
//                            stressValues.append(0)
//                            stressLabels.append(NSLocalizedString("N/A", comment: ""))
//
//                        }
//
//            if let result = urineCollectionEvents[dayComponents].first?.result, let score = result.valueString as String?, score != "" {
//                urineCollectionValues.append(String(score))
//                urineCollectionLabels.append(String(score))
//                print("Urine collection score \(score)")
//                someDict.updateValue(result.valueString, forKey: "urineCollectionTime")
//            }
//            else {
//                menstrualFlowValues.append(0)
//                menstrualFlowLabels.append(NSLocalizedString("N/A", comment: ""))
//                someDict.updateValue("-99", forKey: "urineCollectionTime")
//
//            }
//
//
//            // Store the menstrual flow result for the current day.
//            if let result = menstrualFlowEvents[dayComponents].first?.result, let score = Int(result.valueString) , score >= 0 {
//                menstrualFlowValues.append(score)
//                menstrualFlowLabels.append(result.valueString)
//                print("MenstrualFlow score \(score)")
//                someDict.updateValue(result.valueString, forKey: "menstrualFlowNRS")
//            }
//            else {
//                menstrualFlowValues.append(0)
//                menstrualFlowLabels.append(NSLocalizedString("N/A", comment: ""))
//
//            }
//
//            //VOPAM - Menstruating
//            print("Menstruating first result \(menstruatingEvents[dayComponents].first?.result?.valueString)")
//            var menstruatingScore:Int?
//            if menstruatingEvents[dayComponents].first?.result?.valueString == "No" {
//                menstruatingScore = 0
//            }
//            else if menstruatingEvents[dayComponents].first?.result != nil {
//                menstruatingScore = 1
//
//            }
//
//
//            if let result = menstruatingEvents[dayComponents].first?.result, let score = menstruatingScore , score >= 0 {
//                menstruatingValues.append(score)
//                menstruatingLabels.append(String(score))
//                print("Menstruating score \(score)")
//                someDict.updateValue(result.valueString, forKey: "menstruating")
//            }
//            else {
//                menstruatingValues.append(0)
//                menstruatingLabels.append(NSLocalizedString("N/A", comment: ""))
//                someDict.updateValue("-99", forKey: "menstruating")
//
//            }
//
//            //VOPAM - spotting
//            print("spotting first result \(spottingEvents[dayComponents].first?.result?.valueString)")
//            var spottingScore:Int?
//            if spottingEvents[dayComponents].first?.result?.valueString == "No" {
//                spottingScore = 0
//            }
//            else if spottingEvents[dayComponents].first?.result != nil {
//                spottingScore = 1
//
//            }
//
//
//            if let result = spottingEvents[dayComponents].first?.result, let score = spottingScore , score >= 0 {
//                spottingValues.append(score)
//                spottingLabels.append(String(score))
//                print("spotting score \(score)")
//                someDict.updateValue(result.valueString, forKey: "spotting")
//            }
//            else {
//                spottingValues.append(0)
//                spottingLabels.append(NSLocalizedString("N/A", comment: ""))
//                someDict.updateValue("-99", forKey: "spotting")
//
//            }
//
//
//            //VOPAM
////            print("painDifferentiation first result \(painDifferentiationEvents[dayComponents].first?.result?.valueString)")
////            //            // Store the painDiff result for the current day.
////            var painDifferentiationScore:Int?
////            if painDifferentiationEvents[dayComponents].first?.result?.valueString == "No" {
////                painDifferentiationScore = 0
////            }
////            else if painDifferentiationEvents[dayComponents].first?.result != nil {
////                painDifferentiationScore = 1
////
////            }
//
//
////            if let result = painDifferentiationEvents[dayComponents].first?.result, let score = painDifferentiationScore , score >= 0 {
////                painDifferentiationValues.append(score)
////                painDifferentiationLabels.append(String(score))
////                print("painDifferentiation score \(score)")
////                someDict.updateValue(result.valueString, forKey: "painDifferentiation")
////            }
////            else {
////                painDifferentiationValues.append(0)
////                painDifferentiationLabels.append(NSLocalizedString("N/A", comment: ""))
////                someDict.updateValue("-99", forKey: "painDifferentiation")
////
////            }
//
//
//            //VOPAM
////            print("painDifferentiation first result \(painDifferentiationEvents[dayComponents].first?.result?.valueString)")
//            //            // Store the mood result for the current day.
//
//
////            if let result = painDifferentiationEvents[dayComponents].first?.result, let score = painDifferentiationScore , score >= 0 {
////                painDifferentiationValues.append(score)
////                painDifferentiationLabels.append(String(score))
////                print("painDifferentiation score \(score)")
////                someDict.updateValue(result.valueString, forKey: "painDifferentiation")
////            }
////            else {
////                painDifferentiationValues.append(0)
////                painDifferentiationLabels.append(NSLocalizedString("N/A", comment: ""))
////                someDict.updateValue("-99", forKey: "painDifferentiation")
////
////            }
//
//
//
//            //VOPAM
//
//
//
//
//
//            if let result = bodyLocationEvents[dayComponents].first?.result {
//                someDict.updateValue(result.valueString, forKey: "bodyLocation")
//                print("dictionary after bodyLocation \(someDict)")
//            }
//            else {
////                bodyLocation.append(0)
////                bodyLocationLables.append(NSLocalizedString("N/A", comment: ""))
//                someDict.updateValue("-99", forKey: "bodyLocation")
//                print("dictionary after bodyLocation is empty \(someDict)")
//
//            }
//
//
//
//
//
//            // Store the SLEEP (this use the medication variable adherance value for the current day.
//            let medicationEventsForDay = medicationEvents[dayComponents]
//            if let adherence = percentageEventsCompleted(medicationEventsForDay) , adherence > 0.0 {
//                // Scale the adherance to the same 0-10 scale as pain values.
//                let scaledAdeherence = adherence * 10.0
//
//                medicationValues.append(scaledAdeherence)
//                medicationLabels.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
//                someDict.updateValue(percentageFormatter.string(from: NSNumber(value: adherence))!, forKey: "sleep")
//            }
//            else {
//                medicationValues.append(0.0)
//                medicationLabels.append(NSLocalizedString("N/A", comment: ""))
//            }
//
//
//            // Store the medication adherance value for the current day.
////            let takeMedicationEventsForDay = takeMedicationEvents[dayComponents]
////            if let adherence = percentageEventsCompleted(takeMedicationEventsForDay) , adherence > 0.0 {
////                // Scale the adherance to the same 0-10 scale as pain values.
////                let scaledAdeherence = adherence * 10.0
////
////                takeMedicationValues.append(Int(scaledAdeherence))
////                takeMedicationLabels.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
////                someDict.updateValue(percentageFormatter.string(from: NSNumber(value: adherence))!, forKey: "takeMedication")
////            }
////            else {
////                takeMedicationValues.append(Int(0.0))
////                takeMedicationLabels.append(NSLocalizedString("N/A", comment: ""))
////            }
//
//
//            // Store the medication adherance value for the current day.
////            let breakfastEventsForDay = breakfastEvents[dayComponents]
////            if let adherence = percentageEventsCompleted(breakfastEventsForDay) , adherence > 0.0 {
////                // Scale the adherance to the same 0-10 scale as pain values.
////                let scaledAdeherence = adherence * 10.0
////
////                breakfastValues.append(scaledAdeherence)
////                breakfastLabels.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
////                someDict.updateValue(percentageFormatter.string(from: NSNumber(value: adherence))!, forKey: "breakfast")
////            }
////            else {
////                breakfastValues.append(0.0)
////                breakfastLabels.append(NSLocalizedString("N/A", comment: ""))
////            }
////
////            // Store the luonch adherance value for the current day.
////            let lunchEventsForDay = lunchEvents[dayComponents]
////            if let adherence = percentageEventsCompleted(lunchEventsForDay) , adherence > 0.0 {
////                // Scale the adherance to the same 0-10 scale as pain values.
////                let scaledAdeherence = adherence * 10.0
////
////                lunchValues.append(scaledAdeherence)
////                lunchLabels.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
////                someDict.updateValue(percentageFormatter.string(from: NSNumber(value: adherence))!, forKey: "lunch")
////            }
////            else {
////                lunchValues.append(0.0)
////                lunchLabels.append(NSLocalizedString("N/A", comment: ""))
////            }
//
//
//            // Store the dinner adherance value for the current day.
//            let dinnerEventsForDay = dinnerEvents[dayComponents]
//            if let adherence = percentageEventsCompleted(dinnerEventsForDay) , adherence > 0.0 {
//                // Scale the adherance to the same 0-10 scale as pain values.
//                let scaledAdeherence = adherence * 10.0
//
//                dinnerValues.append(scaledAdeherence)
//                dinnerLabels.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
//                someDict.updateValue(percentageFormatter.string(from: NSNumber(value: adherence))!, forKey: "dinner")
//            }
//            else {
//                dinnerValues.append(0.0)
//                dinnerLabels.append(NSLocalizedString("N/A", comment: ""))
//            }
//
//
//            // Store the medication adherance value for the current day.
//            let snackEventsForDay = snackEvents[dayComponents]
//            if let adherence = percentageEventsCompleted(snackEventsForDay) , adherence > 0.0 {
//                // Scale the adherance to the same 0-10 scale as pain values.
//                let scaledAdeherence = adherence * 10.0
//
//                snackValues.append(scaledAdeherence)
//                snackLabels.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
//                someDict.updateValue(percentageFormatter.string(from: NSNumber(value: adherence))!, forKey: "snack")
//            }
//            else {
//                snackValues.append(0.0)
//                snackLabels.append(NSLocalizedString("N/A", comment: ""))
//            }
//
//
//            // Store the medication adherance value for the current day.
//            let walkEventsForDay = walkEvents[dayComponents]
//            if let adherence = percentageEventsCompleted(walkEventsForDay) , adherence > 0.0 {
//                // Scale the adherance to the same 0-10 scale as pain values.
//                let scaledAdeherence = adherence * 10.0
//
//                walkValues.append(scaledAdeherence)
//                walkLabels.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
//                someDict.updateValue(percentageFormatter.string(from: NSNumber(value: adherence))!, forKey: "walk")
//            }
//            else {
//                walkValues.append(0.0)
//                walkLabels.append(NSLocalizedString("N/A", comment: ""))
//            }
//
//
//            axisTitles.append(dayOfWeekFormatter.string(from: dayDate))
//            axisSubtitles.append(shortDateFormatter.string(from: dayDate))
//
//            dictionaryOfDailyEvents[dateString] = someDict
//        }
//
//        print("Printing dictionary for upload \(someDict)")
//        print(dictionaryOfDailyEvents)
//
///*
//        // Create a `OCKBarSeries` for each set of data.
//        //        let painBarSeries = OCKBarSeries(title: "Pain", values: painValues as [NSNumber], valueLabels: painLabels, tintColor: Colors.blue.color)
//
//        let walkBarSeries = OCKBarSeries(title: "Walk", values: walkValues as [NSNumber], valueLabels: walkLabels, tintColor: Colors.lightBlue.color)
//        let medicationBarSeries = OCKBarSeries(title: "Sleep", values: medicationValues as [NSNumber], valueLabels: medicationLabels, tintColor: Colors.lightBlue.color)
////        let breakfastBarSeries = OCKBarSeries(title: "Breakfast", values: breakfastValues as [NSNumber], valueLabels: breakfastLabels, tintColor: Colors.yellow.color)
////        let lunchBarSeries = OCKBarSeries(title: "Lunch", values: lunchValues as [NSNumber], valueLabels: lunchLabels, tintColor: Colors.yellow.color)
//        let dinnerBarSeries = OCKBarSeries(title: "Dinner", values: dinnerValues as [NSNumber], valueLabels: dinnerLabels, tintColor: Colors.yellow.color)
//        let snackBarSeries = OCKBarSeries(title: "Snack", values: snackValues as [NSNumber], valueLabels: snackLabels, tintColor: Colors.yellow.color)
////        let painBarSeries = OCKBarSeries(title: "Pain", values: painValues as [NSNumber], valueLabels: painLabels, tintColor: Colors.red.color)
//        let moodBarSeries = OCKBarSeries(title: "Mood", values: moodValues as [NSNumber], valueLabels: moodLabels, tintColor: Colors.blue.color)
//        let stressBarSeries = OCKBarSeries(title: "Stress", values: stressValues as [NSNumber], valueLabels: stressLabels, tintColor: Colors.crimsonRed.color)
//        let generalHealthBarSeries = OCKBarSeries(title: "Health", values: generalHealthValues as [NSNumber], valueLabels: generalHealthLabels, tintColor: Colors.purple.color)
////        let rashBarSeries = OCKBarSeries(title: "Rash", values: rashValues as [NSNumber], valueLabels: rashLabels, tintColor: Colors.blue.color)
//        let nauseaBarSeries = OCKBarSeries(title: "Nausea", values: nauseaValues as [NSNumber], valueLabels: nauseaLabels, tintColor: Colors.green.color)
////        let vomitingBarSeries = OCKBarSeries(title: "Vomiting", values: vomitingValues as [NSNumber], valueLabels: vomitingLabels, tintColor: Colors.blue.color)
////        let stoolBarSeries = OCKBarSeries(title: "Stool", values: stoolValues as [NSNumber], valueLabels: stoolLabels, tintColor: Colors.blue.color)
////        let diarrheaBarSeries = OCKBarSeries(title: "Diarrhea", values: diarrheaValues as [NSNumber], valueLabels: diarrheaLabels, tintColor: Colors.blue.color)
//        let usualSelfBarSeries = OCKBarSeries(title: "Usual", values: usualSelfValues as [NSNumber], valueLabels: usualSelfLabels, tintColor: Colors.purple.color)
////        let takeMedicationBarSeries = OCKBarSeries(title: "Prescription", values: takeMedicationValues as [NSNumber], valueLabels: takeMedicationLabels, tintColor: Colors.purple.color)
//        let menstruatingBarSeries = OCKBarSeries(title: "Menstruating", values: menstruatingValues as [NSNumber], valueLabels: menstruatingLabels, tintColor: Colors.red.color)
//        let menstrualFlowBarSeries = OCKBarSeries(title: "Menstrual flow", values: menstrualFlowValues as [NSNumber], valueLabels: menstrualFlowLabels, tintColor: Colors.red.color)
//        let fatigueBarSeries = OCKBarSeries(title: "Fatigue", values: fatigueValues as [NSNumber], valueLabels: fatigueLabels, tintColor: Colors.blue.color)
//        let scdPainBarSeries = OCKBarSeries(title: "SCD Pain", values: scdPainValues as [NSNumber], valueLabels: scdPainLabels, tintColor: Colors.red.color)
//        let abdominalCrampBarSeries = OCKBarSeries(title: "Abdominal Cramp", values: abdominalCrampValues as [NSNumber], valueLabels: abdominalCrampLabels, tintColor: Colors.red.color)
////        let painDifferentiationBarSeries = OCKBarSeries(title: "Pain differentiation", values: painDifferentiationValues as [NSNumber], valueLabels: painDifferentiationLabels, tintColor: Colors.red.color)
// */
//        /*
//         Add the series to a chart, specifing the scale to use for the chart
//         rather than having CareKit scale the bars to fit.
//         */
//        //let walkBarSeries = OCKBarSeries(title: "Walk", values: walkValues as [NSNumber], valueLabels: walkLabels, tintColor: Colors.lightBlue.color)
//        let abdominalCrampBarSeries = OCKBarSeries(title: "Abdominal Cramp", values: abdominalCrampValues as [NSNumber], valueLabels: abdominalCrampLabels, tintColor: Colors.purple.color)
//        let scdPainBarSeries = OCKBarSeries(title: "SCD Pain", values: scdPainValues as [NSNumber], valueLabels: scdPainLabels, tintColor: Colors.moderateCyan.color)
//        let chart = OCKBarChart(title: "Care Plan Charts",
//                                text: nil,
//                                tintColor: Colors.blue.color,
//                                axisTitles: axisTitles,
//                                axisSubtitles: axisSubtitles,
//                                dataSeries: [
////                                    breakfastBarSeries,
////                                    lunchBarSeries,
////                                    dinnerBarSeries,
////                                    snackBarSeries,
////                                    nauseaBarSeries,
////                                    menstruatingBarSeries,
////                                    menstrualFlowBarSeries,
////                                    //painDifferentiationBarSeries,
////                                    //rashBarSeries,
////                                    //vomitingBarSeries,
////                                    //stoolBarSeries,
////                                    //diarrheaBarSeries,
////                                    generalHealthBarSeries,
////                                    usualSelfBarSeries,
////                                    moodBarSeries,
////                                    stressBarSeries,
////                                    medicationBarSeries,//SLEEP
////                                    walkBarSeries
//////                                    takeMedicationBarSeries,
//////                                    painBarSeries,
//                                    abdominalCrampBarSeries,
//                                    scdPainBarSeries
//
////                                    fatigueBarSeries
//            ],
//                                minimumScaleRangeValue: 0,
//                                maximumScaleRangeValue: 10)
//
//        print("RETURN CHART")
//
//        let newApicall = UploadApi()
//        newApicall.uploadJSONDictionary(dictionaryOfDailyEvents)
//
//
//        return chart
//    }
//
//    /**
//     For a given array of `OCKCarePlanEvent`s, returns the percentage that are
//     marked as completed.
//     */
//    fileprivate func percentageEventsCompleted(_ events: [OCKCarePlanEvent]) -> Float? {
//        guard !events.isEmpty else { return nil }
//
//        let completedCount = events.filter({ event in
//            event.state == .completed
//        }).count
//
//        return Float(completedCount) / Float(events.count)
//    }
//}
//
///**
// An extension to `SequenceType` whose elements are `OCKCarePlanEvent`s. The
// extension adds a method to return the first element that matches the day
// specified by the supplied `NSDateComponents`.
// */
//extension Sequence where Iterator.Element: OCKCarePlanEvent {
//
//    func eventForDay(_ dayComponents: NSDateComponents) -> Iterator.Element? {
//        for event in self where
//            event.date.year == dayComponents.year &&
//                event.date.month == dayComponents.month &&
//                event.date.day == dayComponents.day {
//                    return event
//        }
//        
//        return nil
//    }
//}

