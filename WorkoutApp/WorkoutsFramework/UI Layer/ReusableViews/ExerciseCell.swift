//
//  ExerciseCell.swift
//  WorkoutsFramework
//
//  Created by Filip Miladinovic 
//

import UIKit


public class ExerciseCell: UITableViewCell {
    
    static let reuseIdentifier = "ExerciseCell"
    
    let stackView = UIStackView()
    let picView = UIImageView()
    let nameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    private func setupLayout() {
        // format UI components
        // root stack view
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.isLayoutMarginsRelativeArrangement = true
        self.stackView.layoutMargins = UIEdgeInsets(top: .rl_grid(1), left: .rl_grid(1), bottom: .rl_grid(1), right: .rl_grid(1))
        self.stackView.axis = .horizontal
        
        self.picView.contentMode = .scaleAspectFill
        self.picView.layer.cornerRadius = 5.0
        self.picView.layer.masksToBounds = true
        
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.nameLabel.font = UIFont.preferredFont(forTextStyle: .body, compatibleWith: self.traitCollection)
        self.nameLabel.adjustsFontSizeToFitWidth = true
        self.nameLabel.textColor = Color.blackText
        self.nameLabel.text = "Label content - test prime"
        self.nameLabel.textAlignment = .left
        
        self.stackView.addArrangedSubview(self.picView)
        self.stackView.addArrangedSubview(self.nameLabel)
        
        self.contentView.addSubview(self.stackView)
        
        // setup constraints
        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            self.picView.widthAnchor.constraint(equalToConstant: 110.0),
            self.picView.heightAnchor.constraint(equalToConstant: 64),
        ])
    }
    
    func configure(with exercise: ExerciseVM?) {
        guard let exercise = exercise else { return }
        
        self.nameLabel.text = exercise.name
        
        // Load the image using SDWebImage
        if let url = URL(string:exercise.imageUrl) {
            self.picView.sd_setImage(with: url, placeholderImage: nil)
        } 
    }
    
}
