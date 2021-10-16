//
//  MockWorkoutViewController.swift
//  WorkoutsFramework
//
//  Created by Filip Miladinovic
//

import UIKit
import SDWebImage
import DataSourceFramework


// MARK: - Mock Workout ViewController

public final class MockWorkoutViewController: WorkoutViewController {
    
    // MARK: Initialization
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init(workoutId: Int) {
        self.init()
        
        let dataSource = MockDataService.shared
        dataSource.fetchWorkout(withId: workoutId) { result in
            switch result {
            case .success(let workout):
                self.workout = WorkoutVM(withWorkout: workout)
                self.tableView.reloadData()
            case .failure(let error):
                print("🔴 There have been an error: \(String(describing: error.errorDescription))")
            }
        }
    }
}


// MARK: View Lifecycle

extension MockWorkoutViewController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // clear the image cache -> path will not change even if we change the image
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk(onCompletion: nil)
        tableView.register(MockExerciseCell.self, forCellReuseIdentifier: MockExerciseCell.reuseIdentifier)
    }
    
}


// MARK: TableView DataSource & Delegate

extension MockWorkoutViewController {
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MockExerciseCell.reuseIdentifier, for: indexPath) as! MockExerciseCell
        cell.configure(with: self.workout?.exercises[indexPath.row])
        return cell
    }
    
}


// MARK: - Mock Workout Cell

public final class MockExerciseCell: ExerciseCell {
    
    override func configure(with exercise: ExerciseVM?) {
        guard let exercise = exercise else { return }
        
        self.nameLabel.text = exercise.name
        
        // Load the image from local foder using SDWebImage
        let bundle = Bundle(for: type(of: self))
        let imageFileURL = bundle.url(forResource: exercise.imageName.fileName(), withExtension: "webp", subdirectory: "MockData/ExercisesAssets")
        self.picView.sd_setImage(with: imageFileURL, placeholderImage: nil)
    }
    
}
