//
//  Workout.swift
//  DataSourceFramework
//
//  Created by Filip Miladinovic 
//

import Foundation

// MARK: - Workout
public class Workout: Codable {
    public var id: Int?
    public var name: String?
    public var order: Int?
    public var phoneImageUrl: String?
    public var phoneImageName: String?
    public var padImageUrl: String?
    public var padImageName: String?
    public var level: String?
    public var brief: String?
    public var time: Int?
    public var calorie: Int?
    public var exercises: [Exercise]

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case order = "order"
        case phoneImageUrl = "phoneImageUrl"
        case phoneImageName = "phoneImageName"
        case padImageUrl = "padImageUrl"
        case padImageName = "padImageName"
        case level = "level"
        case brief = "brief"
        case time = "time"
        case calorie = "calorie"
        case exercises = "exercises"
    }

    public init(id: Int?, name: String?, order: Int?, phoneImageUrl: String?, phoneImageName: String?, padImageUrl: String?, padImageName: String?, level: String?, brief: String?, time: Int?, calorie: Int?, exercises: [Exercise]) {
        self.id = id
        self.name = name
        self.order = order
        self.phoneImageUrl = phoneImageUrl
        self.phoneImageName = phoneImageName
        self.padImageUrl = padImageUrl
        self.padImageName = padImageName
        self.level = level
        self.brief = brief
        self.time = time
        self.calorie = calorie
        self.exercises = exercises
    }
}

// MARK: Workout convenience initializers and mutators

public extension Workout {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Workout.self, from: data)
        self.init(id: me.id, name: me.name, order: me.order, phoneImageUrl: me.phoneImageUrl, phoneImageName: me.phoneImageName, padImageUrl: me.padImageUrl, padImageName: me.padImageName, level: me.level, brief: me.brief, time: me.time, calorie: me.calorie, exercises: me.exercises)
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
        id: Int?? = nil,
        name: String?? = nil,
        order: Int?? = nil,
        phoneImage: String?? = nil,
        padImage: String?? = nil,
        level: String?? = nil,
        brief: String?? = nil,
        time: Int?? = nil,
        calorie: Int?? = nil,
        exercises: [Exercise]?? = nil
    ) -> Workout {
        return Workout(
            id: id ?? self.id,
            name: name ?? self.name,
            order: order ?? self.order,
            phoneImageUrl: phoneImageUrl ?? self.phoneImageUrl,
            phoneImageName: phoneImageName ?? self.phoneImageName,
            padImageUrl: padImageUrl ?? self.padImageUrl,
            padImageName: padImageName ?? self.padImageName,
            level: level ?? self.level,
            brief: brief ?? self.brief,
            time: time ?? self.time,
            calorie: calorie ?? self.calorie,
            exercises: exercises!!
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
