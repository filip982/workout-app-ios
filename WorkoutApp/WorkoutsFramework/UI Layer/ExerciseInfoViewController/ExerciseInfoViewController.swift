//
//  ExerciseInfoViewController.swift
//  WorkoutsFramework
//
//  Created by Filip Miladinovic 
//

import UIKit
import YoutubePlayer_in_WKWebView

public class ExerciseInfoViewController: UIViewController {
    
    // MARK: UI Elements
    
    var rootStackView = UIStackView()
    var titleLabel = UILabel()
    var ytPlayer = WKYTPlayerView()
    
    // MARK: Variables
    
    var exercise: ExerciseVM?
    
    // MARK: Initialization
    
    internal init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init(exercise: ExerciseVM) {
        self.init()
        self.exercise = exercise
    }
    
    // MARK: View Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: Private methods
    
    private func setupLayout() {
        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        rootStackView.isLayoutMarginsRelativeArrangement = true
        rootStackView.spacing = .rl_grid(4)
        rootStackView.layoutMargins = UIEdgeInsets(top: .rl_grid(1), left: .rl_grid(1), bottom: .rl_grid(1), right: .rl_grid(1))
        rootStackView.axis = .vertical
        
        rootStackView.addArrangedSubview(titleLabel)
        rootStackView.addArrangedSubview(ytPlayer)
        self.view.addSubview(rootStackView)
        
        NSLayoutConstraint.activate([
            self.rootStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.rootStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.rootStackView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.rootStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        if let exercise = exercise {
            titleLabel.text = exercise.name.uppercased()
            loadViewById(videoId: exercise.videoLink)
            ytPlayer.backgroundColor = .black
            
            for (index, info) in exercise.exerciseDescription.enumerated() {
                let label = UILabel()
                label.text = "\(index + 1) - \(info)"
                label.numberOfLines = 0
                rootStackView.addArrangedSubview(label)
            }
        }
    }
    
    func loadViewById(videoId: String) {
        let playerVars = [
            "controls":1,
            "playsinline":1,
            "autohide":1,
            "showinfo":1,
            "modestbranding":1,
            "rel":1,
            "cc_load_policy":1,
            "start":0
            ] as [String:Any]
        
        ytPlayer.load(withVideoId: videoId.youtubeID!, playerVars: playerVars)
        
    }
    
    
}


extension String {
    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }
        return (self as NSString).substring(with: result.range) as String
    }
}
