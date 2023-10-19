//
//  WorkoutListViewController.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 11/10/2023.
//

import UIKit

class WorkoutListViewController: UIViewController {

    @IBOutlet weak var workoutsTableView: UITableView! {
        didSet {
            workoutsTableView.delegate = self
            workoutsTableView.dataSource = self
            workoutsTableView.register(HostingCell<WorkoutCardRectangle>.self, forCellReuseIdentifier: "WorkoutCell")
            workoutsTableView.showsVerticalScrollIndicator = false
            workoutsTableView.showsHorizontalScrollIndicator = false
            workoutsTableView.separatorStyle = .none
        }
    }
    @IBOutlet weak var addWorkoutButton: UIButton! {
        didSet {
            let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 48, weight: .heavy)
            addWorkoutButton.setImage(UIImage(systemName: "plus.app", withConfiguration: symbolConfiguration), for: .normal)
            addWorkoutButton.setTitle("", for: .normal)
            addWorkoutButton.imageView?.tintColor = Asset.green.color
        }
    }
}

extension WorkoutListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell", for: indexPath) as! HostingCell<WorkoutCardRectangle>
        cell.set(rootView: WorkoutCardRectangle(title: "Title", numberOfExercises: 4), parentController: self)
        cell.backgroundColor = .clear
        return cell
    }
    
}

extension WorkoutListViewController: UITableViewDelegate {
    
}
