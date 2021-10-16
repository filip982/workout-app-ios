//
//  CategoryViewController.swift
//  WorkoutsFramework
//
//  Created by Filip Miladinovic 
//

import UIKit
import SDWebImage
import DataSourceFramework

public class CategoryViewController : UIViewController, KeyboardHandling {
    
    enum ViewComponents {
        case searchBar
        case categoryBar
        case workoutList
        case searchResults
    }
    
    // Constants
    private typealias Category = CategoryViewPresenter.CategoryBarViewModel
    
    // MARK: Properties
    var searchBar = UISearchBar()
    let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .lightGray
        return cv
    }()
    var tableView = UITableView()
    var searchResultsContainerView = UIView()
    var topConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!
    // NOTE: bellow under are candidates to refeactor when Data Access Layer is refactored
    var defaultCategoryBarData = [CategoryViewPresenter.CategoryBarViewModel]()
    var defaultData = [WorkoutVM]()
    var categoryBarIndex = 1
    
    // MARK: Dependencies
    var dataSource: DataServiceProtocol!
    
    // MARK: Initialization
        
    public init(dataSource: DataServiceProtocol = DataService.shared) {
        self.dataSource = DataService.shared
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.dataSource = DataService.shared
        super.init(coder: coder)
    }
    
}


// MARK: View life cycle
extension CategoryViewController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupLayout(.searchBar)
        setupLayout(.categoryBar)
        setupLayout(.workoutList)
        setupLayout(.searchResults)
        activateConstraints()
        
        self.navigationController?.isNavigationBarHidden = false
    }
            
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
}


// MARK: - CollectionView DataSource & DelegateFlowLayout
extension CategoryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return defaultData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as! CategoryCell
        var category = defaultCategoryBarData[indexPath.row]
        cell.configure(with: category)
        cell.didSelectHandler = { button in
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.deselectPreviousCategory(on: collectionView, withDataSource: self.defaultCategoryBarData)
            category.selected = true
            cell.configure(with: category)
        }
        return cell
    }
}

// MARK: - TableView DataSource & Delegate
extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (defaultData[safe: categoryBarIndex] != nil) ? defaultData.count : 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutCell.reuseIdentifier, for: indexPath) as! WorkoutCell
        cell.configure(with: defaultData[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
                
        defaultData[indexPath.row].isNew = false
        // TODO: save clicked workout -> not new any more
        let workout = defaultData[indexPath.row]
        
        let workoutVC = WorkoutViewController(workout: workout)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(workoutVC, animated: true)
    }
}

// MARK: SearchBar Delegate
extension CategoryViewController: UISearchBarDelegate {
    
    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        view.layoutIfNeeded()
        self.topConstraint.constant = 0.0
        view.setNeedsUpdateConstraints()

        UIView.animate(withDuration: 0.2) {
            self.searchResultsContainerView.alpha = 1.0
            self.view.layoutIfNeeded()
        }
        return true
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        view.layoutIfNeeded()
        self.topConstraint.constant = self.view.bounds.height/3
        view.setNeedsUpdateConstraints()
        
        UIView.animate(withDuration: 0.2) {
            self.searchResultsContainerView.alpha = 0.0
            self.view.layoutIfNeeded()
        }
        searchBar.resignFirstResponder()
    }
}

// MARK: - Private methods
extension CategoryViewController {
    // UISearchController
    private func setupLayout(_ viewComponents: ViewComponents) {
        switch viewComponents {
        case .searchBar:
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            searchBar.placeholder = Localized.CategoryViewController.searchWorkouts
            searchBar.delegate = self
            searchBar.returnKeyType = .search
            searchBar.backgroundColor = UIColor.white
            searchBar.backgroundImage = UIImage()
            if #available(iOS 13, *) {
                searchBar.searchTextField.tintColor = Color.main
                searchBar.searchTextField.backgroundColor = UIColor(red: 236/255.0, green: 236/255.0, blue: 236/255.0, alpha: 1.0)
                searchBar.searchTextField.font = UIFont.preferredFont(forTextStyle: .headline, compatibleWith: self.traitCollection)
            }
            view.addSubview(searchBar)
        case .categoryBar:
            categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
            categoryCollectionView.dataSource = self
            categoryCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
            categoryCollectionView.backgroundColor = Color.whiteDefault
            categoryCollectionView.showsHorizontalScrollIndicator = false
            view.addSubview(categoryCollectionView)
        case .workoutList:
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(WorkoutCell.self, forCellReuseIdentifier: WorkoutCell.reuseIdentifier)
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
            tableView.rowHeight = UIScreen.main.bounds.height * AspectRatio.CategoryViewController.tableHeightRatio
            view.addSubview(tableView)
        case .searchResults:
            searchResultsContainerView.translatesAutoresizingMaskIntoConstraints = false
            searchResultsContainerView.backgroundColor = UIColor.orange
            searchResultsContainerView.alpha = 0.0
            view.addSubview(searchResultsContainerView)
            let categoryTagsVC = CategoryTagsViewController()
            add(categoryTagsVC, to: searchResultsContainerView)
        }
    }
    
    private func activateConstraints() {
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                self.searchBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                self.searchBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                self.searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                
                self.categoryCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                self.categoryCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                self.categoryCollectionView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor),
                self.categoryCollectionView.bottomAnchor.constraint(equalTo: self.tableView.topAnchor),
                self.categoryCollectionView.heightAnchor.constraint(equalToConstant: 50),
                
                self.tableView.topAnchor.constraint(equalTo: self.categoryCollectionView.bottomAnchor),
                self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                
                self.searchResultsContainerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                self.searchResultsContainerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                self.searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                self.searchBar.topAnchor.constraint(equalTo: self.view.topAnchor),
                
                self.categoryCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.categoryCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                self.categoryCollectionView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor),
                self.categoryCollectionView.bottomAnchor.constraint(equalTo: self.tableView.topAnchor),
                self.categoryCollectionView.heightAnchor.constraint(equalToConstant: 50),
                
                self.tableView.topAnchor.constraint(equalTo: self.categoryCollectionView.bottomAnchor),
                self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                
                self.searchResultsContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.searchResultsContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            ])
        }
        self.topConstraint = self.searchResultsContainerView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: self.view.bounds.height/3)
        self.topConstraint.isActive = true

        self.bottomConstraint = self.searchResultsContainerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        self.bottomConstraint.isActive = true
    }
    
    private func loadData() {
        dataSource.fetchWorkouts(then: { result in
            switch result {
            case .success(let workouts):
                self.defaultData = workouts.map({ return WorkoutVM(withWorkout: $0)})
                self.tableView.reloadData()
            case .failure(let error):
                print("🔴 There have been an error: \(String(describing: error.errorDescription))")
            }
        })
    }
    
    // TODO: refactor this and throw some errors
    private func deselectPreviousCategory(on collectionView: UICollectionView, withDataSource dataSource: [Category]) {
        guard let prevIndex = defaultCategoryBarData.firstIndex(where: { $0.selected }) else { return }
        
        defaultCategoryBarData[prevIndex].selected = false
        
        guard let cell = collectionView.cellForItem(at: IndexPath(item: prevIndex, section: 0)) else { return }
        
        for subview in cell.subviews {
            if subview.isKind(of: CategoryButton.self) {
                let button = subview as! CategoryButton
                button.isSelected = !button.isSelected
            }
        }
    }
}

