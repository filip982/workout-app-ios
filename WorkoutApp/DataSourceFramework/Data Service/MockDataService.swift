//
//  MockDataService.swift
//  WorkoutApp
//
//  Created by Filip Miladinovic 
//

import Foundation
import SwiftyJSON
import Promises

// MARK: - Mock Files

typealias mockFileInfo = (file: String, folder: String)

struct MockFile {
    static let workoutScene: mockFileInfo = ("workoutScene.json", "FirestoreMock")
    static let exercise: mockFileInfo = ("exercise.json", "DataStructure")
    
}

// MARK: - MockDataService

public class MockDataService: DataServiceProtocol {
        
    // MARK: - Initialization
    
    public static let shared = MockDataService()
    
    public init() {
        // custom init
    }
    
    // MARK: - Variables
    
    private var exerciseDetailsData = [ExerciseDetails]()
    private var workoutsData = [Workout]()

    // MARK: - Workouts
    
    public func fetchWorkouts(then handler: @escaping (Result<[Workout], DataLayerError>) -> Void) {
        do {
            let jsonData = try loadMockFile(MockFile.workoutScene)
            let json = try JSON(data: jsonData)
            let workoutsData = try WorkoutSceneFile(data: try json.rawData())
            if let workouts = workoutsData.workouts {
                debugPrint("✅ WorkoutsData from '\(MockFile.workoutScene.file)' parsed.")
                self.workoutsData = workouts
                handler(.success(workouts))
            } else {
                debugPrint("🔴 Mandatory property 'workouts' is not present")
                handler(.failure(DataLayerError.mandatoryPropertyNotPresent))
            }
        } catch (let error) {
            handler(.failure(DataLayerError.parsingGoneWrong(error)))
        }
    }
    
    public func fetchWorkout(withId id: Int, then handler: @escaping (Result<Workout, DataLayerError>) -> Void) {
        if workoutsData.count == 0 {
            self.fetchWorkouts { result in
                switch result {
                case .success(let workouts):
                    self.workoutsData = workouts
                case .failure(let error):
                    handler(.failure(DataLayerError.workoutsNotFetched(error)))
                    return
                }
            }
        }
        
        if let workout = workoutsData.first(where: { $0.id == id }) {
            handler(.success(workout))
        } else {
            handler(.failure(DataLayerError.workoutDontExist(id)))
        }
    }
    
    public func fetchExercise(withId id: Int, then handler: @escaping (Result<Exercise, DataLayerError>) -> Void) {
        if workoutsData.count == 0 {
            self.fetchWorkouts { result in
                switch result {
                case .success(let workouts):
                    self.workoutsData = workouts
                case .failure(let error):
                    handler(.failure(DataLayerError.workoutsNotFetched(error)))
                    return
                }
            }
        }
        
        let exercises = workoutsData.flatMap({ $0.exercises })
        
        if let exer = exercises.first(where: { $0.id == id }) {
            handler(.success(exer))
        } else {
            handler(.failure(DataLayerError.workoutDontExist(id)))
        }
    }
    
    // MARK: - Exercise Details
    
    public func fetchExerciseDetailList(forIds ids: [Int], then handler: @escaping (Result<[ExerciseDetails], DataLayerError>) -> Void) {
        do {
            let allExercises = try getAllExerciseDetails()
            self.exerciseDetailsData = allExercises
            debugPrint("✅ Exercises from '\(MockFile.exercise.file)' parsed.")
            
            let exercises = allExercises.filter({ ids.contains($0.id) })
            handler(.success(exercises))
        } catch (let error) {
            handler(.failure(DataLayerError.parsingGoneWrong(error)))
        }
    }
    
    public func fetchExerciseDetail(withId id: Int, then handler: @escaping (Result<ExerciseDetails, DataLayerError>) -> Void) {
        if exerciseDetailsData.count == 0 {
            do {
                self.exerciseDetailsData = try getAllExerciseDetails()
            } catch (let error) {
                handler(.failure(DataLayerError.parsingGoneWrong(error)))
            }
        }
        
        if let exercise = exerciseDetailsData.first(where: { $0.id == id }) {
            handler(.success(exercise))
        } else {
            handler(.failure(DataLayerError.workoutDontExist(id)))
        }
    }
    
}


// MARK: - Private methods

extension MockDataService {
    
    private func loadMockFile(_ mockFile: mockFileInfo) throws -> Data {
        let bundle = Bundle(for: type(of: self))
        guard let fileUrl = bundle.url(forResource: mockFile.file.fileName(),
                                       withExtension: mockFile.file.fileExtension(),
                                       subdirectory: "MockData/" + mockFile.folder) else {
                                        fatalError("‼️ '\(mockFile.file)' not found")
        }
        debugPrint("✅ '\(mockFile.file)' fetched properly from local folder")
        return try Data(contentsOf: fileUrl, options: [.alwaysMapped, .uncached])
    }
    
    private func getAllExerciseDetails() throws -> [ExerciseDetails] {
        let jsonData = try loadMockFile(MockFile.exercise)
        let json = try JSON(data: jsonData)
        let exerciseFile = try ExerciseFile(data: try json.rawData())
        
        if let allExercises = exerciseFile.exercises {
            return allExercises
        } else {
            throw DataLayerError.mandatoryPropertyNotPresent
        }
    }
    
    // MARK: - Prefetch
    
    public func prefetchSystemSounds() {
        
    }
    
    public func containsAllExerciseDetails(_ exerciseDetails: [ExerciseDetails]) -> Bool {
        return false
    }
    
    public func fetchExerciseAssets(_ exerciseDetails: [ExerciseDetails], then handler: @escaping (Bool) -> Void) {
        handler(true)
    }
    
    public func getGifImageData(named gifName: String, gifHash: String) -> Data? {
        return nil
    }
    
    public func getSound(named soundName: String, soundHash: String) -> Data? {
        let bundle = Bundle(for: type(of: self))
        guard let fileUrl = bundle.url(forResource: soundName.fileName(),
                                       withExtension: soundName.fileExtension(),
                                       subdirectory: "MockData/ExercisesAssets") else {
                                        fatalError("‼️ '\(soundName)' not found")
        }
        debugPrint("✅ '\(soundName)' fetched properly from local folder")
        return try? Data(contentsOf: fileUrl, options: [.alwaysMapped, .uncached])
    }
        
    public func getSystemSound(_ name: String) -> Data? {
        let bundle = Bundle(for: type(of: self))
        guard let fileUrl = bundle.url(forResource: name.fileName(),
                                       withExtension: name.fileExtension(),
                                       subdirectory: "MockData/SoundsAssets") else {
                                        fatalError("‼️ '\(name)' not found")
        }
        debugPrint("✅ '\(name)' fetched properly from local folder")
        return try? Data(contentsOf: fileUrl, options: [.alwaysMapped, .uncached])
    }
    
    public func getFilePath(forSystemSound name: String) -> String? {
        return nil
    }
    
    public func getFilePath(forSound soundName: String, soundHash: String) -> String? {
        return nil
    }
    
    public func authSignOut() {
        
    }
    
    public func userSignedIn() -> Bool {
        return false
    }
    
    public func authAppleID(with idToken: String, nonce: String, then: @escaping () -> Void) {
        
    }
    
}
