//
//  FirebaseStore.swift
//  DataSourceFramework
//
//  Created by Filip Miladinovic 
//

import Foundation
import Firebase
import SwiftyJSON
import Promises

internal class FirebaseStore {
    
    internal static func configure() {
        FirebaseApp.configure()
        print("🟡 FirebaseApp - configured ")
    }
    
    // MARK: - Workouts
    
    internal static func fetchWorkouts(then handler: @escaping (Swift.Result<[Workout], DataLayerError>) -> Void) {
        Firestore.firestore().collection("scenes").document("workoutsData").getDocument { (document, error) in
            if let error = error {
                debugPrint("🔴 Getting workoutsData document: \(error.localizedDescription)")
                handler(.failure(DataLayerError.workoutsNotFetched(error)))
                return
            }
            
            guard let document = document, document.exists else {
                debugPrint("🟣 Document does not exist")
                handler(.failure(DataLayerError.mandatoryPropertyNotPresent))
                return
            }
            
            do {
                let json = JSON(document.data() as Any)
                let data = try WorkoutSceneFile(data: try json.rawData())
                if let workouts = data.workouts {
                    debugPrint("🟢 Document Workouts fetched properly")
                    handler(.success(workouts))
                } else {
                    debugPrint("🔴 Mandatory property 'workouts' is not present")
                    handler(.failure(DataLayerError.mandatoryPropertyNotPresent))
                }
                
            } catch let error {
                debugPrint("🔴 Parsing data gone wrong \(error.localizedDescription)")
                handler(.failure(DataLayerError.parsingGoneWrong(error)))
            }
        }
    }
    
    internal static func fetchWorkout(withId id: Int, then handler: @escaping (Swift.Result<Workout, DataLayerError>) -> Void) {
        handler(.failure(DataLayerError.notImplemented))
    }
    
    internal static func fetchExercise(withId id: Int, then handler: @escaping (Swift.Result<Exercise, DataLayerError>) -> Void) {
        handler(.failure(DataLayerError.notImplemented))
    }
    
    // MARK: - Exercise Details
    
    internal static func fetchExerciseDetailList(forIds ids: [Int], then handler: @escaping (Swift.Result<[ExerciseDetails], DataLayerError>) -> Void) {
        Firestore.firestore().collection("exercises").getDocuments { (snapshot, error) in
            if let error = error {
                debugPrint("🔴 Getting all exercises error: \(error.localizedDescription)")
                handler(.failure(DataLayerError.workoutsNotFetched(error)))
                return
            }
            guard let documents = snapshot?.documents, documents.count > 0 else {
                debugPrint("🟣 There is no list of documents. Empty list.")
                handler(.failure(DataLayerError.mandatoryPropertyNotPresent))
                return
            }
            do {
                var allExercises = [ExerciseDetails]()
                for doc in documents {
                    let json = JSON(doc.data() as Any)
                    let rawData = try json.rawData()
                    let exercise = try ExerciseDetails(data: rawData)
                    allExercises.append(exercise)
                }
                let exercises = allExercises.filter({ ids.contains($0.id) })
                
                debugPrint("🟢 Document Exercise fetched properly")
                handler(.success(exercises))
            } catch let error {
                debugPrint("🔴 Parsing data gone wrong \(error.localizedDescription)")
                handler(.failure(DataLayerError.parsingGoneWrong(error)))
            }
        }
    }
    
    internal static func fetchExerciseDetail(withId id: Int, then handler: @escaping (Swift.Result<ExerciseDetails, DataLayerError>) -> Void) {
        Firestore.firestore().collection("exercises").document("exercise_\(id)").getDocument { (snapshot, error) in
            if let error = error {
                debugPrint("🔴 Getting exercise error: \(error.localizedDescription)")
                handler(.failure(DataLayerError.exerciseNotFetched(error)))
                return
            }
            guard let doc = snapshot, doc.exists else {
                debugPrint("🟣 There is no exercise document. Empty exercise.")
                handler(.failure(DataLayerError.mandatoryPropertyNotPresent))
                return
            }
            do {
                let json = JSON(doc.data() as Any)
                let exercise = try ExerciseDetails(data: try json.rawData())
                
                debugPrint("🟢 Document Exercise fetched properly")
                handler(.success(exercise))
            } catch let error {
                debugPrint("🔴 Parsing data gone wrong \(error.localizedDescription)")
                handler(.failure(DataLayerError.parsingGoneWrong(error)))
            }
        }
    }
    
    // MARK: - Users
    
    internal static func getUser(withId userId: String) -> Promise<(QueryDocumentSnapshot,User)> {
        return Promise(on: .global(qos: .userInteractive)) { (fulfill, reject) in
            Firestore.firestore().collection("users").whereField("id", isEqualTo: userId).getDocuments { (querySnapshot, error) in
                if let error = error {
                    debugPrint("🔴 Getting user error: \(error.localizedDescription)")
                    reject(DataLayerError.firestoreError(error))
                    return
                }
                guard let docs = querySnapshot?.documents, let doc = docs.first, doc.exists else {
                    debugPrint("🟣 There is no exercise document. Empty exercise.")
                    reject(DataLayerError.mandatoryPropertyNotPresent)
                    return
                }
                do {
                    let json = JSON(doc.data() as Any)
                    let user = try User(data: try json.rawData())
                    
                    debugPrint("🟢 Document User fetched properly")
                    fulfill((doc,user))
                } catch let error {
                    debugPrint("🔴 Parsing data gone wrong \(error.localizedDescription)")
                    reject(DataLayerError.parsingGoneWrong(error))
                }
            }
        }
    }
    
    internal static func addUser(_ user: User) -> Promise<Void> {
        return Promise(on: .global(qos: .userInteractive)) { (fulfill, reject) in
            do {
                let jsonData = try user.jsonData()
                guard let json = try JSON(data: jsonData).dictionaryObject else {
                    reject(DataLayerError.parsingGoneWrong(nil))
                    return
                }
                Firestore.firestore().collection("users").addDocument(data: json) { (error) in
                    if let error = error {
                        reject(DataLayerError.addingUserDocumentFailed(error))
                    }
                    
                    debugPrint("🟢 Adding User Document Success")
                    fulfill(())
                }
            } catch let error {
                reject(DataLayerError.parsingGoneWrong(error))
            }
        }
    }
    
    internal static func updateUser(_ user: User, withDocument document: QueryDocumentSnapshot) -> Promise<Void> {
        return Promise(on: .global(qos: .userInteractive)) { (fulfill, reject) in
            document.reference.updateData([
                "displayName": user.displayName ?? "",
                "email": user.email ?? "",
                "providerId": user.providerId ?? "",
                "photoURL": user.photoURL?.absoluteString ?? "",
            ]) { error in
                if let error = error {
                    reject(error)
                } else {
                    fulfill(())
                }
            }
        }
    }
    
    internal static func updateUser(withOnboardingData data: [String : String], withDocument document: QueryDocumentSnapshot) -> Promise<Void> {
        return Promise(on: .global(qos: .userInteractive)) { (fulfill, reject) in
            document.reference.updateData([
                "answer_1": data["answer_1"] ?? "",
                "answer_2": data["answer_2"] ?? "",
                "answer_3": data["answer_3"] ?? "",
            ]) { error in
                if let error = error {
                    reject(error)
                } else {
                    fulfill(())
                }
            }
        }
    }
    
    internal static func getUserData(withId userId: String) -> Promise<[String: Any]> {
        return Promise(on: .global(qos: .userInteractive)) { (fulfill, reject) in
            Firestore.firestore().collection("users").whereField("id", isEqualTo: userId).getDocuments { (querySnapshot, error) in
                if let error = error {
                    debugPrint("🔴 Getting user error: \(error.localizedDescription)")
                    reject(DataLayerError.firestoreError(error))
                    return
                }
                guard let docs = querySnapshot?.documents, let doc = docs.first, doc.exists else {
                    debugPrint("🟣 There is no exercise document. Empty exercise.")
                    reject(DataLayerError.mandatoryPropertyNotPresent)
                    return
                }
                debugPrint("🟢 Document User fetched properly")
                
                let json = JSON(doc.data() as Any)
                fulfill(json.dictionaryObject ?? [:])
            }
        }
    }
    
}
