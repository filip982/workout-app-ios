//
//  AppCoordinator.swift
//  WorkoutApp
//
//  Created by Filip Miladinovic
//

import UIKit
import WorkoutsFramework
import DataSourceFramework

class AppCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        DataService.shared
        
        let vc = CategoryViewController()
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(vc, animated: false)
    }
}

// NOTE: Commented on purpose to discuss advanteges of Coordinators

//// MARK: - Authentication
//
//extension AppCoordinator: AuthCoordinatorDelegate {
//    func didAuthorize() {
//        let vc = CategoryViewController()
//        vc.delegate = self
//        navigationController.setViewControllers([vc], animated: true)
//    }
//}
//
//// MARK: - Category Screen
//
//extension AppCoordinator: CategoryViewDelegate {
//    func showProfileScreen() {
//        let vc = ProfileViewController()
//        vc.delegate = self
//        navigationController.pushViewController(vc, animated: true)
//    }
//}
//
//// MARK: - Profile Screen
//
//extension AppCoordinator: ProfileViewDelegate {
//    func showProvidersScreen() {
//        let vc = AuthProvidersViewController()
//        vc.delegate = self
//        vc.modalPresentationStyle = .formSheet
//        navigationController.present(vc, animated: true, completion: nil)
//    }
//
//    func didLogOut() {
//        navigationController.popToRootViewController(animated: false)
//        authCoordinator = AuthCoordinator(navigationController: self.navigationController)
//        authCoordinator?.delegate = self
//        authCoordinator?.start()
//    }
//}
//
//// MARK: - Linking Auth Providers
//
//extension AppCoordinator: AuthProvidersViewDelegate {
//    func didFirebaseSignedIn() {
//
//    }
//}
