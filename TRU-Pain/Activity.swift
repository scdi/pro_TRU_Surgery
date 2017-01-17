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

/**
 Protocol that defines the properties and methods for sample activities.
 */
protocol Activity {
    var activityType: ActivityType { get }
    
    func carePlanActivity() -> OCKCarePlanActivity
}


/**
 Enumeration of strings used as identifiers for the `SampleActivity`s used in
 the app.
 */
enum ActivityType: String {
    case OutdoorWalk
    //case hamstringStretch //VOPAM:
    
    
    case symptomTracker
    case appetite
    case takeMedication
    case eatBreakfast
    case eatLunch
    case eatDinner
    case eatSnack
    case takeSleep
    case backPain
    case mood
    case bloodGlucose
    case weight
    
    case stool
    case diarrhea
    case nausea
    case vomiting
    
    case rash
    case usualSelf
    case generalHealth
    case spotting
    case scdPain
    case painDifferentiation
    
    case abdominalCramp
    case urineCollection
    case menstruation
    case menstruating
    case fatigue
    case bodyLocation
    case stress
    case sickleCellPain
    
    case symptomFocus
    case temperature
    
    
}
