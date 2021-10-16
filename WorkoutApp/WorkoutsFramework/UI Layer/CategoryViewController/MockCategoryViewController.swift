//
//  MockCategoryViewController.swift
//  WorkoutsFramework
//
//  Created by Filip Miladinovic
//

import UIKit
import SDWebImage
import DataSourceFramework

// MARK: - Mock Category ViewController
public final class MockCategoryViewController : CategoryViewController {
    
    public init() {
        super.init(dataSource: MockDataService.shared)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.dataSource = MockDataService.shared
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // clear the image cache -> path will not change even if we change the image
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk(onCompletion: nil)
        tableView.register(MockWorkoutCell.self, forCellReuseIdentifier: MockWorkoutCell.reuseIdentifier)
    }

    // MARK: TableView DataSource & Delegate
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MockWorkoutCell.reuseIdentifier, for: indexPath) as! MockWorkoutCell
        cell.configure(with: defaultData[indexPath.row])
        return cell
    }
}

// MARK: - Mock Workout Cell
public final class MockWorkoutCell: WorkoutCell {
    
    override func configure(with workout: WorkoutVM) {
        self.titleLabel.text = workout.name.uppercased()
        self.subTitleLabel.text = workout.info.capitalized
        
        // Load the image from local foder using SDWebImage
        let bundle = Bundle(for: type(of: self))
        let imageFileURL = bundle.url(forResource: workout.phoneImageName.fileName(), withExtension: "webp", subdirectory: "MockData/WorkoutsAssets")
        self.posterImageView.sd_setImage(with: imageFileURL, placeholderImage: nil)
        
        if workout.isNew {
            self.newLabelWrapper.isHidden = !workout.isNew
        }
    }
}
