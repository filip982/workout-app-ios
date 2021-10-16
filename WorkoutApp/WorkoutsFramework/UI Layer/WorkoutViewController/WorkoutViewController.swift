//
//  WorkoutViewController.swift
//  WorkoutsFramework
//
//  Created by Filip Miladinovic
//

import UIKit
import DataSourceFramework


public class WorkoutViewController: UIViewController {
    
    // MARK: Constants
    
    private let STRETCH_HEADER_HEIGHT: CGFloat = 200.0
    
    // MARK: UI Elements
    
    var stretchImageView = UIImageView()
    var tableView = UITableView(frame: .zero, style: .grouped)
    var cHeightStretchImageView: NSLayoutConstraint!
    var startWorkoutButton = UIButton(type: .system)
    
    // MARK: Variables
    
    var workout: WorkoutVM?
    
    // MARK: Initialization
    
    internal init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init(workout: WorkoutVM) {
        self.init()
        self.workout = workout
    }
    
    // MARK: View Lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ExerciseCell.self, forCellReuseIdentifier: ExerciseCell.reuseIdentifier)
        tableView.register(ExercisesHeaderView.self, forHeaderFooterViewReuseIdentifier: ExercisesHeaderView.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 70.0
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: STRETCH_HEADER_HEIGHT, left: 0, bottom: 0, right: 0)
        
        stretchImageView.translatesAutoresizingMaskIntoConstraints = false
        stretchImageView.contentMode = .scaleAspectFill
        stretchImageView.clipsToBounds = true
        
        startWorkoutButton.translatesAutoresizingMaskIntoConstraints = false
        startWorkoutButton.setTitle("START", for: .normal)
        startWorkoutButton.setTitleColor(.black, for: .normal)
        startWorkoutButton.addTarget(self, action: #selector(startDownloadMaterials), for: .touchUpInside)
        
        view.addSubview(tableView)
        view.addSubview(stretchImageView)
        view.addSubview(startWorkoutButton)
        
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                self.stretchImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                self.stretchImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                self.stretchImageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                
                self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                self.tableView.bottomAnchor.constraint(equalTo: self.startWorkoutButton.topAnchor),
                self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                
                self.startWorkoutButton.heightAnchor.constraint(equalToConstant: 60),
                self.startWorkoutButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                self.startWorkoutButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                self.startWorkoutButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),

            ])
            self.cHeightStretchImageView = self.stretchImageView.heightAnchor.constraint(equalToConstant: STRETCH_HEADER_HEIGHT)
            self.cHeightStretchImageView.isActive = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let workout = workout {
            self.stretchImageView.sd_setImage(with: URL(string:workout.phoneImageUrl)!, placeholderImage: nil)
        }
    }
    
}


extension WorkoutViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout?.exercises.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseCell.reuseIdentifier, for: indexPath) as! ExerciseCell
        cell.accessoryType = .disclosureIndicator
        cell.configure(with: self.workout?.exercises[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200.0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ExercisesHeaderView.reuseIdentifier) as! ExercisesHeaderView
        header.configure(with: self.workout)
        return header
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let exercise = self.workout?.exercises[indexPath.row] {
            let workoutVC = ExerciseInfoViewController(exercise: exercise)
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.pushViewController(workoutVC, animated: true)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = STRETCH_HEADER_HEIGHT - (scrollView.contentOffset.y + STRETCH_HEADER_HEIGHT)
        let height = min(max(y, 0), 2 * STRETCH_HEADER_HEIGHT)
        self.cHeightStretchImageView.constant = height
    }
    
}


// MARK: Private methods

extension WorkoutViewController {
    
    @objc func startDownloadMaterials() {
        guard let workout = self.workout else { return }
        
        let ids = workout.exercises.compactMap({ $0.id })
        
        DataService.shared.fetchExerciseDetailList(forIds: ids) { result in
            switch result {
            case .success(let exerciseDetailsList):
                for (index, var exercise) in workout.exercises.enumerated() {
                    if let ed = exerciseDetailsList.first(where: { $0.id == exercise.id }) {
                        exercise.injectExerciseDetails(ed: ed)
                        self.workout?.exercises[index] = exercise
                    }
                }
                
                if DataService.shared.containsAllExerciseDetails(exerciseDetailsList) {
                    self.showStartActionSheet()
                } else {
                    DataService.shared.fetchExerciseAssets(exerciseDetailsList) { _ in
                        print("✅ Downloaded all needed exercises")
                        self.showStartActionSheet()
                    }
                }
                
                
            case .failure(let error):
                print("🔴 Error getting Exercise Details list: \(String(describing: error.errorDescription))")
            }
        }
    }
    
    private func showStartActionSheet() {
        let actionSheet = UIAlertController(title: "Get Ready", message: "Be prepared Turn on the music and get pumped. It's time to start your workout.", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "I'm ready!", style: .default, handler: { _ in
            guard let workout = self.workout else { return }
            
            // TODO: Not Implemented
        }))
        actionSheet.addAction(UIAlertAction(title: "Need more time", style: .default, handler: { _ in
            print("⚪️ Need more time")
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
}
