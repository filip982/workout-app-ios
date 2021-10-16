//
//  CategoryCell.swift
//  WorkoutsFramework
//
//  Created by Filip Miladinovic
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    // MARK: Constants
    
    static let reuseIdentifier = "CategoryCell"
    
    // MARK: Properties
    
    var cellContentView = UIView()
    var button = CategoryButton(type: .system)
    var didSelectHandler: ((CategoryButton) -> Void)?
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    // MARK: Cell Life cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        button.isSelected = false
    }
    
    // MARK: Public methods
    
    func configure(with category: CategoryViewPresenter.CategoryBarViewModel) {
        self.button.isSelected = category.selected
        button.setTitle(category.name, for: UIControl.State.normal)
        button.setAttributedTitle(category.name.boldStyle(Color.blackText, textStyle: .subheadline), for: .normal)
        button.setAttributedTitle(category.name.boldStyle(Color.whiteText, textStyle: .subheadline), for: .selected)
    }
    
    // MARK: Private methods
        
    private func setupLayout() {
        cellContentView.translatesAutoresizingMaskIntoConstraints = false
        cellContentView.backgroundColor = UIColor.clear
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Color.pinkCerise
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 5.0
        button.contentEdgeInsets = UIEdgeInsets(top: .rl_grid(2), left: .rl_grid(4), bottom: .rl_grid(2), right: .rl_grid(4))
        button.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
        
        addSubview(cellContentView)
        cellContentView.addSubview(button)
        
        addConstraints([
            cellContentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellContentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellContentView.topAnchor.constraint(equalTo: topAnchor),
            cellContentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellContentView.heightAnchor.constraint(equalToConstant: 44.0),

            button.leadingAnchor.constraint(equalTo: cellContentView.leadingAnchor, constant: .rl_grid(2)),
            button.trailingAnchor.constraint(equalTo: cellContentView.trailingAnchor, constant: -.rl_grid(2)),
            button.topAnchor.constraint(equalTo: cellContentView.topAnchor, constant: .rl_grid(1)),
            button.bottomAnchor.constraint(equalTo: cellContentView.bottomAnchor, constant: -.rl_grid(1)),
        ])
    }
        
    @objc private func buttonDidTapped() {
        didSelectHandler?(self.button)
    }
}
