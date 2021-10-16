//
//  StyleFormatter.swift
//  WorkoutsFramework
//
//  Created by Filip Miladinovic
//

import UIKit

extension String {
    
    func boldStyle(_ color: UIColor, textStyle: UIFont.TextStyle) -> NSAttributedString {
        let textRange = NSRange(location: 0, length: self.count)
        
        let attrString = NSMutableAttributedString(string: self)
        attrString.addAttribute(.font,
                                value: UIFont.preferredFont(forTextStyle: textStyle).bold(),
                                range: textRange)
        attrString.addAttribute(.foregroundColor,
                                value: color,
                                range: textRange)
        return NSAttributedString(attributedString: attrString)
    }
    
}
