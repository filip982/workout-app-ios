//
//  Exercise.swift
//  DataSourceFramework
//
//  Created by Filip Miladinovic 
//

import Foundation

// MARK: - Exercise
public class Exercise: Codable {
    public var id: Int?
    public var videoLink: String?
    public var imageName: String?
    public var imageUrl: String?
    public var name: String?
    public var exerciseDescription: [String]?
    public var timeSpan: Int?
    public var getReady: Int?
    public var switchSide: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case videoLink = "videoLink"
        case imageName = "imageName"
        case imageUrl = "imageUrl"
        case name = "name"
        case exerciseDescription = "description"
        case timeSpan = "timeSpan"
        case getReady = "getReady"
        case switchSide = "switchSide"
    }

    public init(id: Int?, videoLink: String?, imageName: String?, imageUrl: String?, name: String?, exerciseDescription: [String]?, timeSpan: Int?, getReady: Int?, switchSide: Bool?) {
        self.id = id
        self.videoLink = videoLink
        self.imageName = imageName
        self.imageUrl = imageUrl
        self.name = name
        self.exerciseDescription = exerciseDescription
        self.timeSpan = timeSpan
        self.getReady = getReady
        self.switchSide = switchSide
    }
}

// MARK: Exercise convenience initializers and mutators

public extension Exercise {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Exercise.self, from: data)
        self.init(id: me.id, videoLink: me.videoLink, imageName: me.imageName, imageUrl: me.imageUrl, name: me.name, exerciseDescription: me.exerciseDescription, timeSpan: me.timeSpan, getReady: me.getReady, switchSide: me.switchSide)
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
        videoLink: String?? = nil,
        imageName: String?? = nil,
        imageUrl: String?? = nil,
        name: String?? = nil,
        exerciseDescription: [String]?? = nil,
        timeSpan: Int?? = nil,
        getReady: Int?? = nil,
        switchSide: Bool?? = nil
    ) -> Exercise {
        return Exercise(
            id: id ?? self.id,
            videoLink: videoLink ?? self.videoLink,
            imageName: imageName ?? self.imageName,
            imageUrl: imageUrl ?? self.imageUrl,
            name: name ?? self.name,
            exerciseDescription: exerciseDescription ?? self.exerciseDescription,
            timeSpan: timeSpan ?? self.timeSpan,
            getReady: getReady ?? self.getReady,
            switchSide: switchSide ?? self.switchSide
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
 
