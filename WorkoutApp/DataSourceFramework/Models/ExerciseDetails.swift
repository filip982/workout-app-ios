//
//  ExerciseData.swift
//  DataSourceFramework
//
//  Created by Filip Miladinovic
//
import Foundation

// MARK: - ExerciseDetails
public class ExerciseDetails: Codable {
    public var id: Int
    public var name: String?
    public var sound: String?
    public var soundMd5: String?
    public var origin: String?
    public var bodyPart: String?
    public var picMd5: String?
    public var padGifMd5: String?
    public var sound2Md5: String?
    public var padGif: String?
    public var signedPic: String?
    public var pic: String?
    public var phoneGifMd5: String?
    public var sound2: String?
    public var phoneGif: String?
    public var custom: Bool?
    public var exerciseDetailsDescription: [String]?
    public var calorie: Double?
    public var videoLink: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case sound = "sound"
        case soundMd5 = "soundMd5"
        case origin = "origin"
        case bodyPart = "bodyPart"
        case picMd5 = "picMd5"
        case padGifMd5 = "padGifMd5"
        case sound2Md5 = "sound2Md5"
        case padGif = "padGif"
        case signedPic = "signedPic"
        case pic = "pic"
        case phoneGifMd5 = "phoneGifMd5"
        case sound2 = "sound2"
        case phoneGif = "phoneGif"
        case custom = "custom"
        case exerciseDetailsDescription = "description"
        case calorie = "calorie"
        case videoLink = "videoLink"
    }

    public init(id: Int, name: String?, sound: String?, soundMd5: String?, origin: String?, bodyPart: String?, picMd5: String?, padGifMd5: String?, sound2Md5: String?, padGif: String?, signedPic: String?, pic: String?, phoneGifMd5: String?, sound2: String?, phoneGif: String?, custom: Bool?, exerciseDetailsDescription: [String]?, calorie: Double?, videoLink: String?) {
        self.id = id
        self.name = name
        self.sound = sound
        self.soundMd5 = soundMd5
        self.origin = origin
        self.bodyPart = bodyPart
        self.picMd5 = picMd5
        self.padGifMd5 = padGifMd5
        self.sound2Md5 = sound2Md5
        self.padGif = padGif
        self.signedPic = signedPic
        self.pic = pic
        self.phoneGifMd5 = phoneGifMd5
        self.sound2 = sound2
        self.phoneGif = phoneGif
        self.custom = custom
        self.exerciseDetailsDescription = exerciseDetailsDescription
        self.calorie = calorie
        self.videoLink = videoLink
    }
}

// MARK: ExerciseDetails convenience initializers and mutators

public extension ExerciseDetails {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(ExerciseDetails.self, from: data)
        self.init(id: me.id, name: me.name, sound: me.sound, soundMd5: me.soundMd5, origin: me.origin, bodyPart: me.bodyPart, picMd5: me.picMd5, padGifMd5: me.padGifMd5, sound2Md5: me.sound2Md5, padGif: me.padGif, signedPic: me.signedPic, pic: me.pic, phoneGifMd5: me.phoneGifMd5, sound2: me.sound2, phoneGif: me.phoneGif, custom: me.custom, exerciseDetailsDescription: me.exerciseDetailsDescription, calorie: me.calorie, videoLink: me.videoLink)
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
        id: Int = 0,
        name: String?? = nil,
        sound: String?? = nil,
        soundMd5: String?? = nil,
        origin: String?? = nil,
        bodyPart: String?? = nil,
        picMd5: String?? = nil,
        padGifMd5: String?? = nil,
        sound2Md5: String?? = nil,
        padGif: String?? = nil,
        signedPic: String?? = nil,
        pic: String?? = nil,
        phoneGifMd5: String?? = nil,
        sound2: String?? = nil,
        phoneGif: String?? = nil,
        custom: Bool?? = nil,
        exerciseDetailsDescription: [String]?? = nil,
        calorie: Double?? = nil,
        videoLink: String?? = nil
    ) -> ExerciseDetails {
        return ExerciseDetails(
            id: id,
            name: name ?? self.name,
            sound: sound ?? self.sound,
            soundMd5: soundMd5 ?? self.soundMd5,
            origin: origin ?? self.origin,
            bodyPart: bodyPart ?? self.bodyPart,
            picMd5: picMd5 ?? self.picMd5,
            padGifMd5: padGifMd5 ?? self.padGifMd5,
            sound2Md5: sound2Md5 ?? self.sound2Md5,
            padGif: padGif ?? self.padGif,
            signedPic: signedPic ?? self.signedPic,
            pic: pic ?? self.pic,
            phoneGifMd5: phoneGifMd5 ?? self.phoneGifMd5,
            sound2: sound2 ?? self.sound2,
            phoneGif: phoneGif ?? self.phoneGif,
            custom: custom ?? self.custom,
            exerciseDetailsDescription: exerciseDetailsDescription ?? self.exerciseDetailsDescription,
            calorie: calorie ?? self.calorie,
            videoLink: videoLink ?? self.videoLink
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
