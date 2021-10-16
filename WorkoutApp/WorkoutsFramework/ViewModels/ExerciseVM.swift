//
//  ExerciseVM.swift
//  WorkoutsFramework
//
//  Created by Filip Miladinovic
//

import Foundation
import DataSourceFramework
import UIKit.UIDevice

public struct ExerciseVM {
    // Exercise from scenes/workoutsData
    public var id: Int
    public var videoLink: String
    public var imageName: String
    public var imageUrl: String
    public var name: String
    public var exerciseDescription: [String]
    public var timeSpan: Int
    public var getReady: Int
    public var switchSide: Bool
    // exercise from exerciseDetails - exercises/...
    public var sound: String?
    public var soundMd5: String?
    public var origin: String?
    public var bodyPart: String?
    public var picMd5: String?
    public var padGifMd5: String?
    public var sound2Md5: String?
    public var padGif: String?
    public var signedPic: String?
    public var pic: String?
    public var phoneGifMd5: String?
    public var sound2: String?
    public var phoneGif: String?
    public var custom: Bool?
    public var exerciseDetailsDescription: [String]?
    public var calorie: Double?
    var userInfo: [String: Any]
}



extension ExerciseVM {
    init(withExercise e: Exercise) {
        self.id = e.id ?? 0
        self.videoLink = e.videoLink ?? ""
        self.imageName = e.imageName ?? ""
        self.imageUrl = e.imageUrl ?? ""
        self.name = e.name ?? ""
        self.exerciseDescription = e.exerciseDescription ?? [""]
        self.timeSpan = e.timeSpan ?? 0
        self.getReady = e.getReady ?? 0
        self.switchSide = e.switchSide ?? false
        self.userInfo = [:]
    }
    
    public mutating func injectExerciseDetails(ed: ExerciseDetails) {
        self.sound = ed.sound
        self.soundMd5 = ed.soundMd5
        self.origin = ed.origin
        self.bodyPart = ed.bodyPart
        self.picMd5 = ed.picMd5
        self.padGifMd5 = ed.padGifMd5
        self.sound2Md5 = ed.sound2Md5
        self.padGif = ed.padGif
        self.signedPic = ed.signedPic
        self.pic = ed.pic
        self.phoneGifMd5 = ed.phoneGifMd5
        self.sound2 = ed.sound2
        self.phoneGif = ed.phoneGif
        self.custom = ed.custom
        self.exerciseDetailsDescription = ed.exerciseDetailsDescription
        self.calorie = ed.calorie
    }
    
    var isRest: Bool {
        get {
            return name == "REST" && id == 129
        }
    }
    
    var gif: String {
        get {
            return Platform.isIPhone ? (self.phoneGif ?? "") : (self.padGif ?? "")
        }
    }
    
    var gifHash: String {
        get {
            return Platform.isIPhone ? (self.phoneGifMd5 ?? "") : (self.padGifMd5 ?? "")
        }
    }

}
