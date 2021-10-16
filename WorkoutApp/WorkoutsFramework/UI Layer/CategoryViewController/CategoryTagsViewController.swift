//
//  CategoriesTagsView.swift
//  WorkoutsFramework
//
//  Created by Filip Miladinovic
//

import UIKit


class SelfSizedCollectionView: UICollectionView {
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: CGSize {
        let s = self.collectionViewLayout.collectionViewContentSize
        return CGSize(width: max(s.width, 1), height: max(s.height,1))
    }

}


class TagCell: UICollectionViewCell {
    
    // MARK: Constants
    
    static let reuseIdentifier = "TagCell"
    
    // MARK: Properties
    
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
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//           setNeedsLayout()
//           layoutIfNeeded()
//           let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
//           var frame = layoutAttributes.frame
//           frame.size.height = ceil(size.height)
//           layoutAttributes.frame = frame
//           return layoutAttributes
//       }
    
    // MARK: Public methods
    
    func configure(with title: String) {
        button.setTitle(title, for: UIControl.State.normal)
        button.setAttributedTitle(title.boldStyle(Color.blackText, textStyle: .subheadline), for: .normal)
        button.setAttributedTitle(title.boldStyle(Color.whiteText, textStyle: .subheadline), for: .selected)
    }
    
    // MARK: Private methods
        
    private func setupLayout() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Color.pinkCerise
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 5.0
        button.contentEdgeInsets = UIEdgeInsets(top: .rl_grid(2), left: .rl_grid(4), bottom: .rl_grid(2), right: .rl_grid(4))
        button.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
        
        contentView.addSubview(button)
        
        addConstraints([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 44.0),

            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .rl_grid(2)),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.rl_grid(2)),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .rl_grid(1)),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.rl_grid(1)),
        ])
    }
        
    @objc private func buttonDidTapped() {
        didSelectHandler?(self.button)
    }
}




class CategoryTagsSectionCell: UITableViewCell {
    
    // MARK: Constants
    
    static let reuseIdentifier = "CategoryTagsSectionCell"
    
    // MARK: Properties
    
    let contentStackView = UIStackView()
    let titleLabel = UILabel()
    let tagsCollectionView: SelfSizedCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: 20, height: 20)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = SelfSizedCollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .lightGray
        return cv
    }()
    var verticalConstraint: NSLayoutConstraint!
    var tagsDataSource = [String]()
    
    // MARK: Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    // MARK: Cell Life cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: Public methods
    
    func configure(with category: CategoryViewPresenter.CategoryBarViewModel) {
        self.titleLabel.text = category.name
        self.tagsDataSource = category.tags
        
        self.tagsCollectionView.reloadData()
//        self.layoutSubviews()
//        self.tagsCollectionView.collectionViewLayout.invalidateLayout()
        self.contentView.layoutIfNeeded()
        
        print("🟡 \(self.tagsCollectionView.collectionViewLayout.collectionViewContentSize.height)")
        
        self.verticalConstraint.constant = self.tagsCollectionView.collectionViewLayout.collectionViewContentSize.height
        self.contentView.layoutIfNeeded()

    }
    
    // MARK: Private methods
    
    private func setupLayout() {
        self.contentStackView.translatesAutoresizingMaskIntoConstraints = false
        self.contentStackView.isLayoutMarginsRelativeArrangement = true
        self.contentStackView.layoutMargins = UIEdgeInsets(top: .rl_grid(1), left: .rl_grid(1), bottom: .rl_grid(1), right: .rl_grid(1))
        self.contentStackView.axis = .vertical
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .title3, compatibleWith: self.traitCollection).bold()
        self.titleLabel.textColor = Color.blackText
        self.titleLabel.textAlignment = .left
        contentStackView.addArrangedSubview(titleLabel)
        
        self.tagsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.tagsCollectionView.dataSource = self
        self.tagsCollectionView.delegate = self
        self.tagsCollectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.reuseIdentifier)
        self.tagsCollectionView.backgroundColor = Color.whiteDefault
        self.tagsCollectionView.showsHorizontalScrollIndicator = false
        self.tagsCollectionView.showsVerticalScrollIndicator = false
        self.tagsCollectionView.isScrollEnabled = false
        contentStackView.addArrangedSubview(tagsCollectionView)
        
        self.contentView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            self.contentStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.contentStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.contentStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.contentStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
//            self.tagsCollectionView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        verticalConstraint = self.tagsCollectionView.heightAnchor.constraint(equalToConstant: 200)
        verticalConstraint.priority = UILayoutPriority(999)
        verticalConstraint.isActive = true
    }
    
}


// MARK: - CollectionView DataSource & DelegateFlowLayout
extension CategoryTagsSectionCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagsDataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseIdentifier, for: indexPath) as! TagCell
        cell.configure(with: tagsDataSource[indexPath.row])
        cell.didSelectHandler = { button in
            cell.button.isSelected = !cell.button.isSelected
            // TODO: Dismiss view and pass on user selection
        }
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 125, height: 50)
//    }
}






public class CategoryTagsViewController: UIViewController {
    
    // MARK: Properties
    
    var tableView = UITableView()
    
    // MARK: View life cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        activateConstraints()
    }
    
}

// MARK: - TableView DataSource & Delegate
extension CategoryTagsViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: find appropriate properties in DataManager and models
        return 1 //CATEGORY_TAGS_SECTION.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTagsSectionCell.reuseIdentifier, for: indexPath) as! CategoryTagsSectionCell
        // TODO: find appropriate properties in DataManager and models
//        cell.configure(with: CATEGORY_TAGS_SECTION[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CategoryTagsViewController {
    
    private func setupLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoryTagsSectionCell.self, forCellReuseIdentifier: CategoryTagsSectionCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
    }
    
    private func activateConstraints() {
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
                self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
                self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            ])
        }
    }
    
    private func loadData() {
        // TODO: needs to be implemented
    }
    
}
