//
//  CategoryViewPresenter.swift
//  WorkoutsFramework
//
//  Created by Filip Miladinovic
//

import Foundation

struct CategoryViewPresenter {
    
    struct CategoryBarViewModel {
        var name: String
        var selected: Bool
        var tags = [String]()
        
        init(name: String, selected: Bool, tags: [String]? = nil) {
            self.name = name
            self.selected = selected
            if let tags = tags {
                self.tags = tags
            }
        }
    }
    
}
