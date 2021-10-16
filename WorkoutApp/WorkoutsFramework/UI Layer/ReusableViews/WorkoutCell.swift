//
//  ProgramCell.swift
//  WorkoutsFramework
//
//  Created by Filip Miladinovic
//

import UIKit


public class WorkoutCell: UITableViewCell {
    
    static let reuseIdentifier = "WorkoutCell"
    
    internal let imageStackView = UIStackView()
    internal let posterImageView = UIImageView()
    internal let titleLabel = UILabel()
    internal let subTitleLabel = UILabel()
    internal let newLabel = UILabel()
    internal let newLabelWrapper = UIView()
    
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
        self.posterImageView.contentMode = .scaleAspectFill
        self.posterImageView.layer.cornerRadius = 5.0
        self.posterImageView.layer.masksToBounds = true
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            self.titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle, compatibleWith: self.traitCollection).bold()
        } else {
            // Fallback on earlier versions
        }
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.titleLabel.textColor = Color.whiteText
        self.titleLabel.textAlignment = .center
        
        self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.subTitleLabel.font = UIFont.preferredFont(forTextStyle: .body, compatibleWith: self.traitCollection).withWeight(.light)
        self.subTitleLabel.adjustsFontSizeToFitWidth = true
        self.subTitleLabel.textColor = Color.whiteText
        self.subTitleLabel.textAlignment = .center
        
        self.newLabelWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.newLabelWrapper.backgroundColor = Color.pinkCerise
        self.newLabelWrapper.layer.cornerRadius = .rl_grid(1)
        self.newLabelWrapper.layer.masksToBounds = true
        self.newLabelWrapper.isHidden = true
        
        self.newLabel.translatesAutoresizingMaskIntoConstraints = false
        self.newLabel.text = Localized.Common.newText.uppercased()
        self.newLabel.font = UIFont.preferredFont(forTextStyle: .subheadline, compatibleWith: self.traitCollection)
        self.newLabel.textColor = Color.whiteText
        
        // root stack view
        self.imageStackView.translatesAutoresizingMaskIntoConstraints = false
        self.imageStackView.isLayoutMarginsRelativeArrangement = true
        self.imageStackView.layoutMargins = UIEdgeInsets(top: .rl_grid(1), left: .rl_grid(1), bottom: .rl_grid(1), right: .rl_grid(1))
        self.imageStackView.axis = .vertical
        
        // add subviews
        self.imageStackView.addArrangedSubview(self.posterImageView)
        
        self.contentView.addSubview(self.imageStackView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.subTitleLabel)
        self.contentView.addSubview(self.newLabelWrapper)
        self.newLabelWrapper.addSubview(newLabel)
        
        // setup constraints
        NSLayoutConstraint.activate([
            self.imageStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.imageStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.imageStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.imageStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            self.titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.contentView.leadingAnchor, constant: .rl_grid(4)),
            self.titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: self.contentView.trailingAnchor, constant: -.rl_grid(4)),
            
            self.subTitleLabel.topAnchor.constraint(greaterThanOrEqualTo: self.titleLabel.bottomAnchor, constant: .rl_grid(1)),
            self.subTitleLabel.centerXAnchor.constraint(equalTo: self.titleLabel.centerXAnchor),
            self.subTitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.contentView.leadingAnchor, constant: .rl_grid(4)),
            self.subTitleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: self.contentView.trailingAnchor, constant: -.rl_grid(4)),
            
            self.newLabelWrapper.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: .rl_grid(3)),
            self.newLabelWrapper.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -.rl_grid(3)),
            
            self.newLabel.leadingAnchor.constraint(equalTo: self.newLabelWrapper.leadingAnchor, constant: .rl_grid(2)),
            self.newLabel.trailingAnchor.constraint(equalTo: self.newLabelWrapper.trailingAnchor, constant: -.rl_grid(2)),
            self.newLabel.topAnchor.constraint(equalTo: self.newLabelWrapper.topAnchor, constant: .rl_grid(1)),
            self.newLabel.bottomAnchor.constraint(equalTo: self.newLabelWrapper.bottomAnchor, constant: -.rl_grid(1)),
        ])
    }
    
    func configure(with workout: WorkoutVM) {
        self.titleLabel.text = workout.name.uppercased()
        self.subTitleLabel.text = workout.info.capitalized
        
        // Load the image using SDWebImage
        self.posterImageView.sd_setImage(with: URL(string:workout.phoneImageUrl)!, placeholderImage: nil)
        
        if workout.isNew {
            self.newLabelWrapper.isHidden = !workout.isNew
        } 
    }
    
}
