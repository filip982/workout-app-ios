//
//  Constants.swift
//  WorkoutsFramework
//
//  Created by Filip Miladinovic
//

import UIKit

public struct Color {
    
    public static let main = UIColor(red: 239/255.0, green: 2/255.0, blue: 94/255.0, alpha: 1.0)
    public static let whiteDefault = UIColor.white
    public static let whiteText = UIColor.white
    public static let blackText = UIColor.black
    public static let pinkCerise = UIColor(red: 219/255, green: 48/255, blue: 96/255, alpha: 1.0)
}

public struct Layout {
    
    public struct Margin {
        
        public static let `default` = 16.0
        public static let generousInset = UIEdgeInsets(top: .rl_grid(6), left: .rl_grid(6), bottom: .rl_grid(6), right: .rl_grid(6))
    }
}

public struct Localized {
    
    public struct Common {
        
        public static let newText = NSLocalizedString("Common_newText", value: "new", comment: "")
    }
    public struct CategoryViewController {
        static let searchWorkouts = NSLocalizedString("CategoryViewController_searchWorkouts",
                                                      value: "Search workouts",
                                                      comment: "")
    }
}

public struct AspectRatio {
    
    public struct CategoryViewController {
        public static let tableHeightRatio: CGFloat = (false ? 0.25 : 0.18)
    }
    
}

public struct Platform {
    fileprivate static let device = UIDevice.current.userInterfaceIdiom
    
    public static var isIPhone: Bool {
        get {
            return Platform.device == .phone
        }
    }

    public static var isIPad: Bool {
        get {
            return Platform.device == .pad
        }
    }
}
