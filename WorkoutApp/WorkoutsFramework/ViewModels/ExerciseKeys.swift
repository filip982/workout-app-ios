//
//  ExerciseKeys.swift
//  WorkoutsFramework
//
//  Created by Filip Miladinovic 
//

import Foundation


enum ExerciseIndex {
    case first
    case mid(index: Int)
    case last
    case undefined
}


extension ExerciseVM {
    private var nextExerciseKey: String { "NEXT_EXERCISE_VM" }
    
    var nextExercise: ExerciseVM? {
        get {
            return userInfo[nextExerciseKey] as? ExerciseVM
        }
        set {
            userInfo[nextExerciseKey] = newValue
        }
    }
    
    private var indexKey: String { "EXERCISE_INDEX" }
    
    var index: Int {
        get {
            return userInfo[indexKey] as? Int ?? -1
        }
        set {
            userInfo[indexKey] = newValue
        }
    }
    
    private var indexTypeKey: String { "EXERCISE_INDEX_TYPE" }
    
    var indexType: ExerciseIndex {
        get {
            return userInfo[indexTypeKey] as? ExerciseIndex ?? ExerciseIndex.undefined
        }
        set {
            userInfo[indexTypeKey] = newValue
        }
    }

}
