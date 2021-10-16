//
//  WorkoutsData.swift
//  DataSourceFramework
//
//  Created by Filip Miladinovic
//

import Foundation

// MARK: - WorkoutsData

public class WorkoutSceneFile: Codable {
    public var app: App?
    public var workouts: [Workout]?

    enum CodingKeys: String, CodingKey {
        case app = "app"
        case workouts = "workouts"
    }

    public init(app: App?, workouts: [Workout]?) {
        self.app = app
        self.workouts = workouts
    }
}

// MARK: WorkoutsData convenience initializers and mutators

public extension WorkoutSceneFile {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(WorkoutSceneFile.self, from: data)
        self.init(app: me.app, workouts: me.workouts)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        app: App?? = nil,
        workouts: [Workout]?? = nil
    ) -> WorkoutSceneFile {
        return WorkoutSceneFile(
            app: app ?? self.app,
            workouts: workouts ?? self.workouts
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

