//
//  Siri.swift
//  UpDown
//
//  Created by Team3 on 2022/10/20.
//

import Foundation

struct Siri {
    static let mySynthesizer : AVSpeechSynthesizer = AVSpeechSynthesizer()
    private init() {}
    
    static func speakText(voiceText: String) {
        let utterance : AVSpeechUtterance = AVSpeechUtterance(string: voiceText)
        mySynthesizer.speak(utterance)
    }
    
    /// siri 말하기 멈추기
    static func stopText() {
        mySynthesizer.stopSpeaking(at: .immediate)
    }
}
