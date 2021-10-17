//
//  DataService.swift
//  WorkoutApp
//
//  Created by Filip Miladinovic
//

import Foundation
import Firebase
import SwiftyJSON
import Cache
import Promises


public class DataService: DataServiceProtocol {
    
    // MARK: - Initialization
    
    public static let shared = MockDataService()
    private var cacheStorage: HybridStorage<Data>!
    
    private init() {
        let memory = MemoryStorage<Data>(config: MemoryConfig())
        let diskConfig = DiskConfig(name: "WorkoutApp", expiry: .date(Date().addingTimeInterval(60 * 60 * 24 * 30)))
        let disk = try! DiskStorage(config: diskConfig, transformer: TransformerFactory.forData())
        cacheStorage = HybridStorage(memoryStorage: memory, diskStorage: disk)
        print("🟡 Cache - DiskStorage path: \(disk.path)")
        FirebaseStore.configure()
    }
    
    // MARK: - Workouts
    
    public func fetchWorkouts(then handler: @escaping (Swift.Result<[Workout], DataLayerError>) -> Void) {
        FirebaseStore.fetchWorkouts(then: handler)
    }

    public func fetchExerciseDetailList(forIds ids: [Int], then handler: @escaping (Swift.Result<[ExerciseDetails], DataLayerError>) -> Void) {
        FirebaseStore.fetchExerciseDetailList(forIds: ids, then: handler)
    }
    

    // MARK: - Prefetch Exercise Details
    
    public func containsAllExerciseDetails(_ exerciseDetails: [ExerciseDetails]) -> Bool {
        let memory = MemoryStorage<Data>(config: MemoryConfig())
        let diskConfig = DiskConfig(name: "WorkoutApp", expiry: .date(Date().addingTimeInterval(60 * 60 * 24 * 30)))
        let disk = try! DiskStorage(config: diskConfig, transformer: TransformerFactory.forData())
        let cacheStorage = HybridStorage(memoryStorage: memory, diskStorage: disk)
        
        var counter = exerciseDetails.count * 3
        
        for e in exerciseDetails {
            if let phoneGif = e.phoneGif, let phoneGifMd5 = e.phoneGifMd5 {
                let picKey = "\(phoneGif.fileName())_\(phoneGifMd5).\(phoneGif.fileExtension())"
                if try! cacheStorage.existsObject(forKey: picKey) {
                    counter = counter - 1
                }
            }
            if let sound = e.sound, let soundMd5 = e.soundMd5 {
                let picKey = "\(sound.fileName())_\(soundMd5).\(sound.fileExtension())"
                if try! cacheStorage.existsObject(forKey: picKey) {
                    counter = counter - 1
                }
            }
            if let sound2 = e.sound2, let sound2Md5 = e.sound2Md5 {
                let picKey = "\(sound2.fileName())_\(sound2Md5).\(sound2.fileExtension())"
                if try! cacheStorage.existsObject(forKey: picKey) {
                    counter = counter - 1
                }
            }
        }
        
        if counter == 0 {
            return true
        }
        
        return false
    }
    
    public func fetchExerciseAssets(_ exerciseDetails: [ExerciseDetails], then handler: @escaping (Bool) -> Void) {
        let memory = MemoryStorage<Data>(config: MemoryConfig())
        let diskConfig = DiskConfig(name: "WorkoutApp", expiry: .date(Date().addingTimeInterval(60 * 60 * 24 * 30)))
        let disk = try! DiskStorage(config: diskConfig, transformer: TransformerFactory.forData())
        let cacheStorage = HybridStorage(memoryStorage: memory, diskStorage: disk)
        
        let storageRef = Storage.storage().reference()
        
        var counter = exerciseDetails.count * 3
        
        
        for e in exerciseDetails {
            if let phoneGif = e.phoneGif, let phoneGifMd5 = e.phoneGifMd5 {
                _ = storageRef.child("WorkoutApp/Exercises/\(phoneGif)").getData(maxSize: 3 * 1024 * 1024) { (data, error) in
                    if let error = error {
                        print("🔴 FIR Storage getting data, Error: \(error.localizedDescription)")
                        counter = counter - 1
                        return
                    }
                    guard let data = data else { return }
                    
                    let picKey = "\(phoneGif.fileName())_\(phoneGifMd5).\(phoneGif.fileExtension())"
                    
                    print("🟢 FIR Storage getting data, Success for image: \(picKey)")
                    counter = counter - 1
                    
                    try! cacheStorage.setObject(data, forKey: picKey)
                    
                    if counter == 0 {
                        handler(true)
                    }
                }
            }
            
            if let sound = e.sound, let soundMd5 = e.soundMd5 {
                _ = storageRef.child("WorkoutApp/Exercises/\(sound)").getData(maxSize: 3 * 1024 * 1024) { (data, error) in
                    if let error = error {
                        print("🔴 FIR Storage getting data, Error: \(error.localizedDescription)")
                        counter = counter - 1
                        return
                    }
                    guard let data = data else { return }
                    
                    let picKey = "\(sound.fileName())_\(soundMd5).\(sound.fileExtension())"
                    
                    print("🟢 FIR Storage getting data, Success for image: \(picKey)")
                    counter = counter - 1
                    
                    try! cacheStorage.setObject(data, forKey: picKey)
                    
                    if counter == 0 {
                        handler(true)
                    }
                }
            }
            
            if let sound2 = e.sound2, let sound2Md5 = e.sound2Md5 {
                _ = storageRef.child("WorkoutApp/Exercises/\(sound2)").getData(maxSize: 3 * 1024 * 1024) { (data, error) in
                    if let error = error {
                        print("🔴 FIR Storage getting data, Error: \(error.localizedDescription)")
                        counter = counter - 1
                        return
                    }
                    guard let data = data else { return }
                    
                    let picKey = "\(sound2.fileName())_\(sound2Md5).\(sound2.fileExtension())"
                    
                    print("🟢 FIR Storage getting data, Success for image: \(picKey)")
                    counter = counter - 1
                    
                    try! cacheStorage.setObject(data, forKey: picKey)
                    
                    if counter == 0 {
                        handler(true)
                    }
                }
            }
            
        }
    }
    
    public func getGifImageData(named gifName: String, gifHash: String) -> Data? {
        let picKey = "\(gifName.fileName())_\(gifHash).\(gifName.fileExtension())"
        let data = try? cacheStorage.object(forKey: picKey)
        return data
    }
    
    public func getSound(named soundName: String, soundHash: String) -> Data? {
        let key = "\(soundName.fileName())_\(soundHash).\(soundName.fileExtension())"
        let data = try? cacheStorage.object(forKey: key)
        return data
    }
    
    public func getSystemSound(_ name: String) -> Data? {
        let data = try? cacheStorage.object(forKey: name)
        return data
    }
    
    public func getFilePath(forSystemSound name: String) -> String? {
        let entry = try? cacheStorage.diskStorage.entry(forKey: name)
        return entry?.filePath
    }

    public func getFilePath(forSound soundName: String, soundHash: String) -> String? {
        let key = "\(soundName.fileName())_\(soundHash).\(soundName.fileExtension())"
        let entry = try? cacheStorage.diskStorage.entry(forKey: key)
        return entry?.filePath
    }
}
