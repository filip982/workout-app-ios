//
//  App.swift
//  DataSourceFramework
//
//  Created by Filip Miladinovic
//

import Foundation

// MARK: - App
public class App: Codable {
    public var reminderVersion: Int?
    public var name: String?
    public var faq: String?
    public var programVersion: Int?
    public var version: Int?
    public var quoteVersion: Int?
    public var dailyVersion: Int?
    public var type: String?
    public var helps: String?

    enum CodingKeys: String, CodingKey {
        case reminderVersion = "reminderVersion"
        case name = "name"
        case faq = "faq"
        case programVersion = "programVersion"
        case version = "version"
        case quoteVersion = "quoteVersion"
        case dailyVersion = "dailyVersion"
        case type = "type"
        case helps = "helps"
    }

    public init(reminderVersion: Int?, name: String?, faq: String?, programVersion: Int?, version: Int?, quoteVersion: Int?, dailyVersion: Int?, type: String?, helps: String?) {
        self.reminderVersion = reminderVersion
        self.name = name
        self.faq = faq
        self.programVersion = programVersion
        self.version = version
        self.quoteVersion = quoteVersion
        self.dailyVersion = dailyVersion
        self.type = type
        self.helps = helps
    }
}

// MARK: App convenience initializers and mutators

public extension App {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(App.self, from: data)
        self.init(reminderVersion: me.reminderVersion, name: me.name, faq: me.faq, programVersion: me.programVersion, version: me.version, quoteVersion: me.quoteVersion, dailyVersion: me.dailyVersion, type: me.type, helps: me.helps)
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
        reminderVersion: Int?? = nil,
        name: String?? = nil,
        faq: String?? = nil,
        programVersion: Int?? = nil,
        version: Int?? = nil,
        quoteVersion: Int?? = nil,
        dailyVersion: Int?? = nil,
        type: String?? = nil,
        helps: String?? = nil
    ) -> App {
        return App(
            reminderVersion: reminderVersion ?? self.reminderVersion,
            name: name ?? self.name,
            faq: faq ?? self.faq,
            programVersion: programVersion ?? self.programVersion,
            version: version ?? self.version,
            quoteVersion: quoteVersion ?? self.quoteVersion,
            dailyVersion: dailyVersion ?? self.dailyVersion,
            type: type ?? self.type,
            helps: helps ?? self.helps
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
