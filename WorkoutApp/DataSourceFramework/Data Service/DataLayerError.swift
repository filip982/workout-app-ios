//
//  DataLayerError.swift
//  DataSourceFramework
//
//  Created by Filip Miladinovic
//

import Foundation

public enum DataLayerError: Error {
    case unknown
    case firestoreError(Error)
    case workoutsNotFetched(Error)
    case exerciseNotFetched(Error)
    case parsingGoneWrong(Error?)
    case mandatoryPropertyNotPresent
    case workoutDontExist(Int)
    case addingUserDocumentFailed(Error)
    case notImplemented
}

extension DataLayerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .workoutsNotFetched(let error):
            return "🔴 Error getting workouts collection! Error: '\(error.localizedDescription)'"
        case .parsingGoneWrong(let error):
            return "🔴 Parsing gone wrong. Error: '\(error?.localizedDescription ?? "unknown")'"
        case .mandatoryPropertyNotPresent:
            return "🔴 Mandatory Property Not Present"
        case .workoutDontExist(let workoutId):
            return "🔴 Workout ID-'\(workoutId)' don't exist."
        case .notImplemented:
            return "🟠 The feature is not implemented yet!"
        default:
            return "🔴 An unknown error occoured!"
        }
    }
}

