//
//  WorkoutSetCell+Extension.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 25/10/2023.
//

import Foundation

extension WorkoutSetCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (set.elements?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        guard (`set`.elements?.count ?? 0) > indexPath.row else {
            cell = tableView.dequeueReusableCell(withIdentifier: AddWorkoutElementCell.identifier, for: indexPath) as! AddWorkoutElementCell
            (cell as! AddWorkoutElementCell).action = #selector(tapAddWorkoutElementCell)
            return cell
        }
        
        switch `set`.elements?.asArray()[indexPath.row].self {
        case is Exercise: let exerciseCell = tableView.dequeueReusableCell(withIdentifier: WorkoutExerciseCell.identifier, for: indexPath) as! WorkoutExerciseCell
            let exercise = `set`.elements?.asArray()[indexPath.row] as! Exercise
            exerciseCell.parentViewController = self.parentViewController
            exerciseCell.exercise = exercise
            exerciseCell.dataModifier = self
            cell = exerciseCell
        case is Rest: let restCell = tableView.dequeueReusableCell(withIdentifier: WorkoutRestCell.identifier, for: indexPath) as! WorkoutRestCell
            let rest = `set`.elements?.asArray()[indexPath.row] as! Rest
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
    func addElement(_ element: WorkoutElement.Type) {
        switch element {
        case is Exercise.Type:
            `set`.elements?.insert(Exercise())
        case is Rest.Type:
            `set`.elements?.insert(Rest())
        default:
            break
        }
        tableView.reloadData()
        delegate?.closeSheet()
    }
}

extension WorkoutSetCell: EditWorkoutDataModifier {
    func delete(_ workoutElement: WorkoutElement) {
        `set`.elements?.remove(workoutElement)
        refreshData()
    }
    
    func refreshData() {
        tableView.reloadData()
        dataModifier.refreshData()
    }
    
    
}
