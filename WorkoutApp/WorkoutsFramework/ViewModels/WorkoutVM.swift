//
//  Workout.swift
//  WorkoutsFramework
//
//  Created by Filip Miladinovic
//

import Foundation
import DataSourceFramework

public struct WorkoutVM {
    public var id: Int
    public var name: String
    public var level: String
    public var brief: String
    public var order: Int
    public var time: Int
    public var calorie: Float
    public var phoneImageUrl: String
    public var phoneImageName: String
    public var isNew: Bool
    public var exercises: [ExerciseVM]
}

extension WorkoutVM {
    init(withWorkout w: Workout) {
        self.id = w.id ?? 0
        self.name = w.name ?? ""
        self.level = w.level ?? ""
        self.brief = w.brief ?? ""
        self.order = w.order ?? 0
        self.time = w.time ?? 0
        self.calorie = Float(w.calorie ?? 0)
        self.phoneImageUrl = w.phoneImageUrl ?? ""
        self.phoneImageName = w.phoneImageName ?? ""
        self.isNew = true
        self.exercises = w.exercises.map({ ExerciseVM(withExercise: $0) })
    }
}

extension WorkoutVM {
    var info: String {
        let str = "\(self.level) ∙ \(self.time) Mins ∙ \(Int(self.calorie)) Calories"
        return str
    }
}
