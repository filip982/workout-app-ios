//
//  Optional+Unwrap.swift
//  WorkoutsFramework
//
//  Created by Filip Miladinovic
//

import Foundation

extension Optional {
    
    func unwrapOrThrow(_ errorExpression: @autoclosure () -> Error) throws -> Wrapped {
        guard let value = self else {
            throw errorExpression()
        }
        return value
    }
    
}
