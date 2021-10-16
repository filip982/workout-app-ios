//
//  String+FileComponents.swift
//  WorkoutsFramework
//
//  Created by Filip Miladinovic 
//

import Foundation

extension String {

    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }

    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
}
