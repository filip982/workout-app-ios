//
//  MockExerciseInfoViewController.swift
//  WorkoutsFramework
//
//  Created by Filip Miladinovic
//

import UIKit
import DataSourceFramework

public final class MockExerciseInfoViewController: ExerciseInfoViewController {
    
    // MARK: Initialization
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init(exerciseId: Int) {
        self.init()
        
        let dataSource = MockDataService.shared
        dataSource.fetchExercise(withId: exerciseId) { (result) in
            switch result {
            case .success(let exercise):
                self.exercise = ExerciseVM(withExercise: exercise)
            case .failure(let error):
                print("🔴 There have been an error: \(String(describing: error.errorDescription))")
            }
        }
    }
}
