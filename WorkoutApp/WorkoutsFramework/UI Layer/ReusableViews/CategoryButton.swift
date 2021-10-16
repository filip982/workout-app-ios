//
//  CategoryButton.swift
//  WorkoutsFramework
//
//  Created by Filip Miladinovic 
//

import UIKit

class CategoryButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitleColor(Color.blackText, for: .normal)
        self.setTitleColor(Color.whiteText, for: .selected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.layer.borderColor = Color.pinkCerise.cgColor
                self.backgroundColor = Color.pinkCerise
            } else {
                self.layer.borderColor = UIColor.lightGray.cgColor
                self.backgroundColor = Color.whiteDefault
            }
        }
    }
    
}
