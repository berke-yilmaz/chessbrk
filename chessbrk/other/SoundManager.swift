//
//  SoundManager.swift
//  chessbrk
//
//  Created by berke on 28.08.2024.
//

import AudioToolbox
import Foundation

public class SoundManager {

    // Static method to play a sound by name
    public static func playSystemSound(named soundName: String, withExtension ext: String = "mp3") {
        if let soundURL = Bundle.main.url(forResource: soundName, withExtension: ext) {
            var soundID: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID)
            AudioServicesPlaySystemSound(soundID)
        } else {
            print("Error: Sound file \(soundName).\(ext) not found.")
        }
    }
}
