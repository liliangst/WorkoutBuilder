//
//  HomeViewController.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 21/08/2023.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let homeView = HomeView(delegate: self)
        let hostingHomeView = UIHostingController(rootView: homeView)
        
        addChild(hostingHomeView)
        view.addSubview(hostingHomeView.view)
        hostingHomeView.didMove(toParent: self)
        
        hostingHomeView.view.backgroundColor = nil
        
        hostingHomeView.view.translatesAutoresizingMaskIntoConstraints = false
        hostingHomeView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        hostingHomeView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        hostingHomeView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        hostingHomeView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension HomeViewController: EditWorkoutDelegate {
    func edit(_ workout: Workout) {
        performSegue(withIdentifier: "OpenEditWorkoutSegue", sender: workout)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "OpenEditWorkoutSegue" else {
            return
        }
        
        if let workout = sender as? Workout {
            (segue.destination as! EditWorkoutViewController).workout = workout
            WorkoutManager.shared.fetchElements(for: workout)
        } else {
            (segue.destination as! EditWorkoutViewController).workout = Workout()
        }
    }
}
