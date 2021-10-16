//
//  ExerciseFile.swift
//  DataSourceFramework
//
//  Created by Filip Miladinovic 
//

import Foundation


// MARK: - ExerciseFile
public class ExerciseFile: Codable {
    public var version: Int?
    public var exercises: [ExerciseDetails]?

    enum CodingKeys: String, CodingKey {
        case version = "version"
        case exercises = "data"
    }

    public init(version: Int?, exercises: [ExerciseDetails]?) {
        self.version = version
        self.exercises = exercises
    }
}

// MARK: ExerciseFile convenience initializers and mutators

public extension ExerciseFile {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(ExerciseFile.self, from: data)
        self.init(version: me.version, exercises: me.exercises)
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
        version: Int?? = nil,
        exercises: [ExerciseDetails]?? = nil
    ) -> ExerciseFile {
        return ExerciseFile(
            version: version ?? self.version,
            exercises: exercises ?? self.exercises
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
