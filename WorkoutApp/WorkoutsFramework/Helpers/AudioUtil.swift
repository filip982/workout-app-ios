//
//  AudioUtil.swift
//  WorkoutsFramework
//
//  Created by Filip Miladinovic
//

import Foundation
import AVFoundation

class AudioUtil {
    
    public static func audioFileDuration(at filePath: String) -> Int {
        let asset = AVURLAsset(url: URL(fileURLWithPath: filePath), options: nil)
        let audioDuration = CMTimeGetSeconds(asset.duration).rounded()
        return Int(audioDuration)
    }

}

 
