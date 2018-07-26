//
//  SoundPlay.swift
//  SamplePeripheral
//
//  Created by Erica Awada on 2018/07/26.
//  Copyright © 2018年 Erica Awada. All rights reserved.
//

import AudioToolbox


func playSound() {
    let url =  Bundle.main.url(forResource: "decision", withExtension: "mp3")!
    var soundId: SystemSoundID = 0
    AudioServicesCreateSystemSoundID(url as CFURL, &soundId)
    AudioServicesAddSystemSoundCompletion(soundId, nil, nil, {(soundId, _) in AudioServicesDisposeSystemSoundID(soundId)}, nil)
    AudioServicesPlaySystemSound(soundId)
    print("なった？")
}

