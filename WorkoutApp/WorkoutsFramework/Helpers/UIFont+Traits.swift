//
//  UIFont+Traits.swift
//  WorkoutsFramework
//
//  Created by Filip Miladinovic
//

import UIKit.UIFont

extension UIFont {
    func withTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }

    func bold() -> UIFont {
        return withTraits(.traitBold)
    }

    func italic() -> UIFont {
        return withTraits(.traitItalic)
    }
    
    // Values of UIFont.Weight could be: ultraLight, thin, light, regular, medium, semibold, bold, heavy, black
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        let descriptor = fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: weight]])
        return UIFont(descriptor: descriptor, size: 0) //size 0 means keep the size as it is
    }
    
}
