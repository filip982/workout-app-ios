//
//  User.swift
//  DataSourceFramework
//
//  Created by Filip Miladinovic 
//

import Foundation


import Foundation

// MARK: - User
public class User: Codable {
    public var id: String?
    public var displayName: String?
    public var email: String?
    public var providerId: String?
    public var photoURL: URL?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case displayName = "displayName"
        case email = "email"
        case providerId = "providerID"
        case photoURL = "photoURL"
    }

    public init(id: String?, displayName: String?, email: String?, providerId: String?, photoURL: URL?) {
        self.id = id
        self.displayName = displayName
        self.email = email
        self.providerId = providerId
        self.photoURL = photoURL
    }
}

// MARK: User convenience initializers and mutators

public extension User {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(User.self, from: data)
        self.init(id: me.id, displayName: me.displayName, email: me.email, providerId: me.providerId, photoURL: me.photoURL)
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
        id: String?? = nil,
        displayName: String?? = nil,
        email: String?? = nil,
        providerId: String?? = nil,
        photoURL: URL?? = nil
    ) -> User {
        return User(
            id: id ?? self.id,
            displayName: displayName ?? self.displayName,
            email: email ?? self.email,
            providerId: providerId ?? self.providerId,
            photoURL: photoURL ?? self.photoURL
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
