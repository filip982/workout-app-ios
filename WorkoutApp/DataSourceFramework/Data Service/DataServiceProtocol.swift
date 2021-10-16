//
//  DataServiceProtocol.swift
//  WorkoutApp
//
//  Created by Filip Miladinovic 
//

import Foundation
import Promises

public protocol DataServiceProtocol {

    // Prefetching
    func containsAllExerciseDetails(_ exerciseDetails: [ExerciseDetails]) -> Bool 
    func fetchExerciseAssets(_ exerciseDetails: [ExerciseDetails], then handler: @escaping (Bool) -> Void)
    func getGifImageData(named gifName: String, gifHash: String) -> Data?
    func getSound(named soundName: String, soundHash: String) -> Data?
    func getSystemSound(_ name: String) -> Data?
    func getFilePath(forSystemSound name: String) -> String?
    func getFilePath(forSound soundName: String, soundHash: String) -> String?
    // Workouts
    func fetchWorkouts(then handler: @escaping (Swift.Result<[Workout], DataLayerError>) -> Void)
    func fetchExerciseDetailList(forIds ids: [Int], then handler: @escaping (Swift.Result<[ExerciseDetails], DataLayerError>) -> Void)
}

