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
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "OpenEditWorkoutSegue" else {
            return
        }
        
        if let workout = sender as? Workout {
            (segue.destination as! EditWorkoutViewController).workout = workout
        } else {
            (segue.destination as! EditWorkoutViewController).workout = Workout()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        workoutsTableView.reloadData()
    }
}

extension WorkoutListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WorkoutManager.workouts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell", for: indexPath) as! HostingCell<WorkoutCardRectangle>
        let workout = WorkoutManager.workouts[indexPath.row]
        cell.set(rootView: WorkoutCardRectangle(workout: workout, editDelegate: self), parentController: self)
        cell.backgroundColor = .clear
        return cell
    }

}

extension WorkoutListViewController: UITableViewDelegate {
    
}

extension WorkoutListViewController: EditWorkoutDelegate {
    func edit(_ workout: Workout) {
        performSegue(withIdentifier: "OpenEditWorkoutSegue", sender: workout)
    }
}
