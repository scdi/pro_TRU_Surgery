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

class InsightsBuilder {
    
    /// An array if `OCKInsightItem` to show on the Insights view.
    fileprivate(set) var insights = [OCKInsightItem.emptyInsightsMessage()]
    
    fileprivate let carePlanStore: OCKCarePlanStore
    
    fileprivate let updateOperationQueue = OperationQueue()
    
    required init(carePlanStore: OCKCarePlanStore) {
        self.carePlanStore = carePlanStore
    }
    
    /**
     Enqueues `NSOperation`s to query the `OCKCarePlanStore` and update the
     `insights` property.
     */
    func updateInsights(_ completion: ((Bool, [OCKInsightItem]?) -> Void)?) {
        // Cancel any in-progress operations.
        
    
        updateOperationQueue.cancelAllOperations()
        
        // Get the dates the current and previous weeks.
        let queryDateRange = calculateQueryDateRange()
        
        /*
         Create an operation to query for events for the previous week's
         `TakeMedication` activity.
         */
        ///////// MEDICATION IS SLEEP ////////////
        let medicationEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                                     activityIdentifier: ActivityType.takeSleep.rawValue,
                                                                     startDate: queryDateRange.start,
                                                                     endDate: queryDateRange.end)
        
        
        
        /*
         Create an operation to query for events for the previous week's
         `TakeMedication` activity.
         */
        ///////// MEDICATION IS SLEEP ////////////
        let sleepEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                                activityIdentifier: ActivityType.takeSleep.rawValue,
                                                                startDate: queryDateRange.start,
                                                                endDate: queryDateRange.end)
        
        
        
        /*
         Create an operation to query for events for the previous week's
         `TakeWalk` activity.
         */
        
        let walkEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                               activityIdentifier: ActivityType.OutdoorWalk.rawValue,
                                                               startDate: queryDateRange.start,
                                                               endDate: queryDateRange.end)
        
        
        
        
        /*
         Create an operation to query for events for the previous week's
         `EatBreakfast` activity.
         */
        
        let breakfastEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                                    activityIdentifier: ActivityType.eatBreakfast.rawValue,
                                                                    startDate: queryDateRange.start,
                                                                    endDate: queryDateRange.end)
        
        
        
        
        /*
         Create an operation to query for events for the previous week's
         `EaltLunch` activity.
         */
        
        let lunchEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                                activityIdentifier: ActivityType.eatLunch.rawValue,
                                                                startDate: queryDateRange.start,
                                                                endDate: queryDateRange.end)
        
        
        
        /*
         Create an operation to query for events for the previous week's
         `EatDinner` activity.
         */
        
        let dinnerEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                                 activityIdentifier: ActivityType.eatDinner.rawValue,
                                                                 startDate: queryDateRange.start,
                                                                 endDate: queryDateRange.end)
        
        
        
        /*
         Create an operation to query for events for the previous week's
         `EatSnaks` activity.
         */
        
        let snackEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                                activityIdentifier: ActivityType.eatSnack.rawValue,
                                                                startDate: queryDateRange.start,
                                                                endDate: queryDateRange.end)
        
        /*
         Create an operation to query for events for the previous week's
         `EatSnaks` activity.
         */
        
        ///MEDICSSTION IS SLEEP - Take medication is actual medication adherence
        let takeMedicationEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                                         activityIdentifier: ActivityType.takeMedication.rawValue,
                                                                         startDate: queryDateRange.start,
                                                                         endDate: queryDateRange.end)
        
        
        
        
        /*
         Create a `BuildInsightsOperation` to create insights from the data
         collected by query operations.
         */
        
        let generalHealthEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                                        activityIdentifier: ActivityType.generalHealth.rawValue,
                                                                        startDate: queryDateRange.start,
                                                                        endDate: queryDateRange.end)
        
        
        /*
         Create a `BuildInsightsOperation` to create insights from the data
         collected by query operations.
         */
        
        let rashEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                               activityIdentifier: ActivityType.rash.rawValue,
                                                               startDate: queryDateRange.start,
                                                               endDate: queryDateRange.end)
        
        /*
         Create a `BuildInsightsOperation` to create insights from the data
         collected by query operations.
         */
        
        let nauseaEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                                 activityIdentifier: ActivityType.nausea.rawValue,
                                                                 startDate: queryDateRange.start,
                                                                 endDate: queryDateRange.end)
        
        /*
         Create a `BuildInsightsOperation` to create insights from the data
         collected by query operations.
         */
        
        let vomitingEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                                   activityIdentifier: ActivityType.vomiting.rawValue,
                                                                   startDate: queryDateRange.start,
                                                                   endDate: queryDateRange.end)
        
        /*
         Create a `BuildInsightsOperation` to create insights from the data
         collected by query operations.
         */
        
        let stoolEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                                activityIdentifier: ActivityType.stool.rawValue,
                                                                startDate: queryDateRange.start,
                                                                endDate: queryDateRange.end)
        
        
        /*
         Create a `BuildInsightsOperation` to create insights from the data
         collected by query operations.
         */
        
        let diarrheaEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                                   activityIdentifier: ActivityType.diarrhea.rawValue,
                                                                   startDate: queryDateRange.start,
                                                                   endDate: queryDateRange.end)
        
        
        
        
        /*
         Create an operation to query for events for the previous week and
         current weeks' `BackPain` assessment.
         */
        
        
        
        
        let backPainEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                                   activityIdentifier: ActivityType.backPain.rawValue,
                                                                   startDate: queryDateRange.start,
                                                                   endDate: queryDateRange.end)
        
        
        
        /*
         Create an operation to query for events for the previous week and
         current weeks' `Mood` assessment.
         */
        
        
        
        
        let moodEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                               activityIdentifier: ActivityType.mood.rawValue,
                                                               startDate: queryDateRange.start,
                                                               endDate: queryDateRange.end)
        
        
        /*
         Create an operation to query for events for the previous week and
         current weeks' `Stress` assessment.
         */
        
        
        
        
        let stressEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                                 activityIdentifier: ActivityType.stress.rawValue,
                                                                 startDate: queryDateRange.start,
                                                                 endDate: queryDateRange.end)
        
        /*
         Create an operation to query for events for the previous week and
         current weeks' `usualSelf` assessment.
         */
        
        
        
        
        let usualSelfEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                                    activityIdentifier: ActivityType.usualSelf.rawValue,
                                                                    startDate: queryDateRange.start,
                                                                    endDate: queryDateRange.end)
        
        
        
        
        
        
        
        
        /*SCD Specific added for VOPAM*/
        
        /*
         Create an operation to query for events for the previous week and
         current weeks' `mentruating` assessment.
         */
        
        
        
        
        let menstruatingEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                                       activityIdentifier: ActivityType.menstruating.rawValue,
                                                                       startDate: queryDateRange.start,
                                                                       endDate: queryDateRange.end)
        
        
        
        /*
         Create an operation to query for events for the previous week and
         current weeks' `mentruating` assessment.
         */
        
        
        
        
        let spottingEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                                   activityIdentifier: ActivityType.spotting.rawValue,
                                                                   startDate: queryDateRange.start,
                                                                   endDate: queryDateRange.end)
        
        /*
         Create an operation to query for events for the previous week and
         current weeks' `mentruating` assessment.
         */
        
        
        
        
        let painDifferentiationEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                                              activityIdentifier: ActivityType.painDifferentiation.rawValue,
                                                                              startDate: queryDateRange.start,
                                                                              endDate: queryDateRange.end)
        
        /*
         Create an operation to query for events for the previous week and
         current weeks' `fatigue` assessment.
         */
        
        
        
        
        let fatigueEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                                  activityIdentifier: ActivityType.fatigue.rawValue,
                                                                  startDate: queryDateRange.start,
                                                                  endDate: queryDateRange.end)
        
        /*
         Create an operation to query for events for the previous week and
         current weeks' `fatigue` assessment.
         */
        
        
        
        
        let scdPainEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                                  activityIdentifier: ActivityType.scdPain.rawValue,
                                                                  startDate: queryDateRange.start,
                                                                  endDate: queryDateRange.end)
        
        /*
         Create an operation to query for events for the previous week and
         current weeks' `fatigue` assessment.
         */
        
        
        
        
        let abdominalCrampEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                                         activityIdentifier: ActivityType.abdominalCramp.rawValue,
                                                                         startDate: queryDateRange.start,
                                                                         endDate: queryDateRange.end)
        
        /*
         Create an operation to query for events for the previous week and
         current weeks' `fatigue` assessment.
         */
        
        
        
        
        let menstrualFlowEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                                        activityIdentifier: ActivityType.menstruation.rawValue,
                                                                        startDate: queryDateRange.start,
                                                                        endDate: queryDateRange.end)
        
        
        /*
         Create an operation to query for events for the previous week and
         current weeks' `fatigue` assessment.
         */
        
        
        
        
        let bodyLocationEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                                       activityIdentifier: ActivityType.bodyLocation.rawValue,
                                                                       startDate: queryDateRange.start,
                                                                       endDate: queryDateRange.end)
        
        
        /*
         Create an operation to query for events for the previous week and
         current weeks' `fatigue` assessment.
         */
        
        
        
        
        let urineCollectionEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                                          activityIdentifier: ActivityType.urineCollection.rawValue,
                                                                          startDate: queryDateRange.start,
                                                                          endDate: queryDateRange.end)
        
        
        
        
        
        /*
         Create a `BuildInsightsOperation` to create insights from the data
         collected by query operations.
         */
        let buildInsightsOperation = BuildInsightsOperation()
        
        /*
         Create an operation to aggregate the data from query operations into
         the `BuildInsightsOperation`.
         */
        let aggregateDataOperation = BlockOperation {
            // Copy the queried data from the query operations to the `BuildInsightsOperation`.
            //            buildInsightsOperation.medicationEvents = medicationEventsOperation.dailyEvents
            buildInsightsOperation.sleepEvents = sleepEventsOperation.dailyEvents
            
            //            buildInsightsOperation.breakfastEvents = breakfastEventsOperation.dailyEvents
            //            buildInsightsOperation.lunchEvents = lunchEventsOperation.dailyEvents
            buildInsightsOperation.dinnerEvents = dinnerEventsOperation.dailyEvents
            buildInsightsOperation.snackEvents = snackEventsOperation.dailyEvents
            buildInsightsOperation.walkEvents = walkEventsOperation.dailyEvents
            //            buildInsightsOperation.usualSelfEvents = usualSelfEventsOperation.dailyEvents
            //            buildInsightsOperation.takeMedicationEvents = takeMedicationEventsOperation.dailyEvents
            //
            //
            //            buildInsightsOperation.generalHealthEvents = generalHealthEventsOperation.dailyEvents
            //            buildInsightsOperation.rashEvents = rashEventsOperation.dailyEvents
            //            buildInsightsOperation.nauseaEvents = nauseaEventsOperation.dailyEvents
            //            buildInsightsOperation.vomitingEvents = vomitingEventsOperation.dailyEvents
            //            buildInsightsOperation.diarrheaEvents = diarrheaEventsOperation.dailyEvents
            //            buildInsightsOperation.stoolEvents = stoolEventsOperation.dailyEvents
            //            buildInsightsOperation.moodEvents = moodEventsOperation.dailyEvents
            //            buildInsightsOperation.stressEvents = stressEventsOperation.dailyEvents
            
            buildInsightsOperation.backPainEvents = backPainEventsOperation.dailyEvents
            //VOPAM
            //            buildInsightsOperation.menstruatingEvents = menstruatingEventsOperation.dailyEvents
            //            buildInsightsOperation.painDifferentiationEvents = painDifferentiationEventsOperation.dailyEvents
            //            buildInsightsOperation.fatigueEvents = fatigueEventsOperation.dailyEvents
            //            buildInsightsOperation.abdominalCrampEvents = abdominalCrampEventsOperation.dailyEvents
            //            buildInsightsOperation.scdPainEvents = scdPainEventsOperation.dailyEvents
            //            buildInsightsOperation.bodyLocationEvents = bodyLocationEventsOperation.dailyEvents
            //            buildInsightsOperation.menstrualFlowEvents = menstrualFlowEventsOperation.dailyEvents
            //            buildInsightsOperation.urineCollectionEvents = urineCollectionEventsOperation.dailyEvents
            //            buildInsightsOperation.spottingEvents = spottingEventsOperation.dailyEvents
            
            
        }
        
        /*
         Use the completion block of the `BuildInsightsOperation` to store the
         new insights and call the completion block passed to this method.
         */
        buildInsightsOperation.completionBlock = { [unowned buildInsightsOperation] in
            let completed = !buildInsightsOperation.isCancelled
            let newInsights = buildInsightsOperation.insights
            
            // Call the completion block on the main queue.
            OperationQueue.main.addOperation {
                if completed {
                    completion?(true, newInsights)
                }
                else {
                    completion?(false, nil)
                }
            }
        }
        
        // The aggregate operation is dependent on the query operations.
        aggregateDataOperation.addDependency(medicationEventsOperation)
        aggregateDataOperation.addDependency(backPainEventsOperation)
        
        // The `BuildInsightsOperation` is dependent on the aggregate operation.
        buildInsightsOperation.addDependency(aggregateDataOperation)
        
        // Add all the operations to the operation queue.
        updateOperationQueue.addOperations([
            medicationEventsOperation, //medication adherence
            sleepEventsOperation,
            walkEventsOperation,
            breakfastEventsOperation,
            lunchEventsOperation,
            dinnerEventsOperation,
            snackEventsOperation,
            takeMedicationEventsOperation,//actual prescription adherence
            generalHealthEventsOperation,
            rashEventsOperation,
            nauseaEventsOperation,
            vomitingEventsOperation,
            stoolEventsOperation,
            diarrheaEventsOperation,
            backPainEventsOperation,
            moodEventsOperation,
            stressEventsOperation,
            usualSelfEventsOperation,
            aggregateDataOperation,
            menstruatingEventsOperation,
            painDifferentiationEventsOperation,
            fatigueEventsOperation,
            scdPainEventsOperation,
            abdominalCrampEventsOperation,
            buildInsightsOperation,
            bodyLocationEventsOperation,
            menstrualFlowEventsOperation,
            urineCollectionEventsOperation,
            spottingEventsOperation
            ], waitUntilFinished: false)
    }
    
    fileprivate func calculateQueryDateRange() -> (start: DateComponents, end: DateComponents) {
        let calendar = Calendar.current
        let now = Date()
        
        let currentWeekRange = calendar.weekDatesForDate(now)
        let previousWeekRange = calendar.weekDatesForDate(currentWeekRange.start.addingTimeInterval(-1))
        
        let queryRangeStart = calendar.dateComponents([.year, .month, .day, .era], from: previousWeekRange.start)
        let queryRangeEnd = calendar.dateComponents([.year, .month, .day, .era], from: now)
        
        return (start: queryRangeStart, end: queryRangeEnd)
    }
}



protocol InsightsBuilderDelegate: class {
    func insightsBuilder(_ insightsBuilder: InsightsBuilder, didUpdateInsights insights: [OCKInsightItem])
}
