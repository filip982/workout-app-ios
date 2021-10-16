//
//  AVAudioPlayer+Tag.swift
//  WorkoutsFramework
//
//  Created by Filip Miladinovic
//

import Foundation
import AVFoundation

extension AVAudioPlayer {
    private struct AssociatedKey {
        static var identifier: Int = 0
    }
    
    public var tag: Int {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKey.identifier) as? Int)!
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.identifier, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
}
