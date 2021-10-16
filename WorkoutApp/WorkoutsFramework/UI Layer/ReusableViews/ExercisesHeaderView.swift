//
//  ExercisesHeaderView.swift
//  WorkoutsFramework
//
//  Created by Filip Miladinovic 
//

import UIKit


public class ExercisesHeaderView: UITableViewHeaderFooterView {
    
    static let reuseIdentifier = "ExercisesHeaderView"
    
    var contentStackView = UIStackView()
    var workoutTitleLabel = UILabel()
    var workoutInfoLabel = UILabel()
    var workoutBriefLabel = UILabel()
    var exercisesNumberLabel = UILabel()
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.spacing = .rl_grid(4)
        contentStackView.layoutMargins = UIEdgeInsets(top: .rl_grid(1), left: .rl_grid(1), bottom: .rl_grid(1), right: .rl_grid(1))
        contentStackView.axis = .vertical

        workoutBriefLabel.numberOfLines = 0
        
        contentStackView.addArrangedSubview(workoutTitleLabel)
        contentStackView.addArrangedSubview(workoutInfoLabel)
        contentStackView.addArrangedSubview(workoutBriefLabel)
        contentStackView.addArrangedSubview(exercisesNumberLabel)
        self.contentView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            self.contentStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.contentStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.contentStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.contentStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
    }
    
    func configure(with workout: WorkoutVM?) {
        guard let workout = workout else { return }
        
        workoutTitleLabel.text = workout.name.uppercased()
        workoutInfoLabel.text = workout.info.capitalized
        workoutBriefLabel.text = workout.brief
        exercisesNumberLabel.text = "\(workout.exercises.count) EXERCISES"
    }
    
}

