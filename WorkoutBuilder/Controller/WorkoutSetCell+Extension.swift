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
        
        switch set.elements?.asArray()[indexPath.row].self {
        case is Exercice: cell = tableView.dequeueReusableCell(withIdentifier: WorkoutExerciceCell.identifier, for: indexPath) as! WorkoutExerciceCell
        case is Rest: cell = tableView.dequeueReusableCell(withIdentifier: WorkoutRestCell.identifier, for: indexPath) as! WorkoutRestCell
        default:
            break
        }
        return cell
    }
}

extension WorkoutSetCell: AddWorkoutElementDelegate {
    func addElement(_ element: WorkoutElement.Type) {
        switch element {
        case is Exercice.Type:
            `set`.elements?.insert(Exercice())
        case is Rest.Type:
            `set`.elements?.insert(Rest())
        default:
            break
        }
        tableView.reloadData()
        delegate?.closeSheet()
    }
}
