//
//  Errors.swift
//  WorkoutsFramework
//
//  Created by Filip Miladinovic
//

import Foundation

enum UILayerError: Error {
    case noWorkouts
    case mandatoryPropertyNotPresent
    case notImplemented
}

extension UILayerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noWorkouts:
            return "🔴 There is no workout at the moment. Please try again!"
        default:
            return "🔴 An unknown error occoured!"
        }
    }
}

