//
//  AuthProviders.swift
//  DataSourceFramework
//
//  Created by Filip Miladinovic
//

import Foundation

public enum AuthProviders {
    case apple
    case facebook
    case email
    case guest
}

public enum AuthProviderError: Error {
    case apple(Error)
}
