//
//  WorkoutSetCell+Extension.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 25/10/2023.
//

import Foundation

extension WorkoutSetCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        `set`.elementsObjects.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        guard `set`.elementsObjects.count > indexPath.row else {
            cell = tableView.dequeueReusableCell(withIdentifier: AddWorkoutElementCell.identifier, for: indexPath) as! AddWorkoutElementCell
            (cell as! AddWorkoutElementCell).action = #selector(tapAddWorkoutElementCell)
            return cell
        }
        
        switch `set`.elementsObjects[indexPath.row].self {
        case is Exercise: let exerciseCell = tableView.dequeueReusableCell(withIdentifier: WorkoutExerciseCell.identifier, for: indexPath) as! WorkoutExerciseCell
            let exercise = `set`.elementsObjects[indexPath.row] as! Exercise
            exerciseCell.parentViewController = self.parentViewController
            exerciseCell.exercise = exercise
            exerciseCell.dataModifier = self
            cell = exerciseCell
        case is Rest: let restCell = tableView.dequeueReusableCell(withIdentifier: WorkoutRestCell.identifier, for: indexPath) as! WorkoutRestCell
            let rest = `set`.elementsObjects[indexPath.row] as! Rest
            restCell.parentViewController = self.parentViewController
            restCell.rest = rest
            restCell.dataModifier = self
            cell = restCell
        default:
            break
        }
        return cell
    }
}

extension WorkoutSetCell: AddWorkoutElementDelegate {
    func addElement(_ element: WorkoutElementObject.Type) {
        switch element {
        case is Exercise.Type:
            `set`.insert(Exercise())
        case is Rest.Type:
            `set`.insert(Rest())
        default:
            break
        }
        tableView.reloadData()
        delegate?.closeSheet()
    }
}

extension WorkoutSetCell: EditWorkoutDataModifier {
    func delete(_ workoutElement: WorkoutElementObject) {
        `set`.remove(workoutElement)
        refreshData()
    }
    
    func refreshData() {
        tableView.reloadData()
        dataModifier.refreshData()
    }
    
    
}
