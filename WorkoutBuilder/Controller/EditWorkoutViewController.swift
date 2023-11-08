//
//  EditWorkoutViewController.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 13/10/2023.
//

import UIKit

protocol EditWorkoutDelegate {
    func edit(_ workout: Workout)
}

protocol EditWorkoutDataModifier {
    func delete(_ workoutElement: WorkoutElement)
    func refreshData()
}

class EditWorkoutViewController: UIViewController {

    var workout: Workout?
    
    @IBOutlet var titleTextField: UITextField! {
        didSet {
            titleTextField.delegate = self
            titleTextField.tintColor = Asset.green.color
        }
    }
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.allowsSelection = false
            tableView.register(UINib(nibName: AddWorkoutElementCell.identifier, bundle: nil), forCellReuseIdentifier: AddWorkoutElementCell.identifier)
            tableView.register(UINib(nibName: WorkoutExerciceCell.identifier, bundle: nil), forCellReuseIdentifier: WorkoutExerciceCell.identifier)
            tableView.register(UINib(nibName: WorkoutRestCell.identifier, bundle: nil), forCellReuseIdentifier: WorkoutRestCell.identifier)
            tableView.register(UINib(nibName: WorkoutSetCell.identifier, bundle: nil), forCellReuseIdentifier: WorkoutSetCell.identifier)
        }
    }
    

    override func viewDidLoad() {
        let btnConfiguration = UIImage.SymbolConfiguration(weight: .heavy)
        let backButtonImage = UIImage(systemName: "arrowshape.turn.up.left", withConfiguration: btnConfiguration)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backButtonImage, style: .done, target: self, action: #selector(tapBackButton))
        
        let validateButtonImage = UIImage(systemName: "checkmark", withConfiguration: btnConfiguration)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: validateButtonImage, style: .done, target: self, action: #selector(tapValidateButton))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        if workout != nil {
            titleTextField.text = workout?.title
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    @objc private func tapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func tapValidateButton() {
        guard let workout = workout else { return }
        
        if let index = WorkoutManager.workouts.firstIndex(of: workout) {
            WorkoutManager.workouts[index] = workout
        } else {
            WorkoutManager.workouts.append(workout)
        }
        tapBackButton()
    }
    
    @objc private func tapAddWorkoutElementCell() {
        if titleTextField.isEditing { return }
        openSheet(self, sheetElements: [Sets.self, Exercice.self, Rest.self])
    }

    @IBAction func dismissKeyboard(_ sender: Any) {
        titleTextField.resignFirstResponder()
    }
}

extension EditWorkoutViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let title = textField.text, !title.isEmpty else {
            navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
        workout?.title = title
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
}

extension EditWorkoutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (workout?.elements?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        guard (workout?.elements?.count ?? 0) > indexPath.row else {
            cell = tableView.dequeueReusableCell(withIdentifier: AddWorkoutElementCell.identifier, for: indexPath) as! AddWorkoutElementCell
            (cell as! AddWorkoutElementCell).action = #selector(tapAddWorkoutElementCell)
            return cell
        }
        
        switch workout?.elements?.asArray()[indexPath.row].self {
        case is Exercice: cell = tableView.dequeueReusableCell(withIdentifier: WorkoutExerciceCell.identifier, for: indexPath) as! WorkoutExerciceCell
        case is Rest: let restCell = tableView.dequeueReusableCell(withIdentifier: WorkoutRestCell.identifier, for: indexPath) as! WorkoutRestCell
            let rest = workout?.elements?.asArray()[indexPath.row] as! Rest
            restCell.parentViewController = self
            restCell.rest = rest
            restCell.dataModifier = self
            cell = restCell
        case is Sets: let setsCell = tableView.dequeueReusableCell(withIdentifier: WorkoutSetCell.identifier, for: indexPath) as! WorkoutSetCell
            setsCell.delegate = self
            setsCell.set = workout?.elements?.asArray()[indexPath.row] as! Sets
            cell = setsCell
        default:
            break
        }
        
        return cell
    }
}

extension EditWorkoutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row < workout?.elements?.count ?? 0, workout?.elements?.asArray()[indexPath.row] is Sets else {
            return 105
        }
        guard let set = workout?.elements?.asArray()[indexPath.row] as? Sets, let setElements = set.elements else {
            return 215
        }
        return CGFloat(110 + 105 * (setElements.count + 1))
    }
}

extension EditWorkoutViewController: AddWorkoutElementDelegate {
    func addElement(_ element: WorkoutElement.Type) {
        switch element {
        case is Sets.Type:
            workout?.elements?.insert(Sets())
        case is Exercice.Type:
            workout?.elements?.insert(Exercice())
        case is Rest.Type:
            workout?.elements?.insert(Rest())
        default:
            break
        }
        tableView.reloadData()
        closeSheet()
    }
}

extension EditWorkoutViewController: AddWorkoutElementSheetDelegate {
    func openSheet(_ addWorkoutElementDelegate: AddWorkoutElementDelegate, sheetElements: [WorkoutElement.Type]) {
        guard !(presentedViewController.self is AddWorkoutElementViewController) else {
            return
        }
        
        let addWorkoutElementViewController = AddWorkoutElementViewController(nibName: "AddWorkoutElementView", bundle: nil)
        guard let sheet = addWorkoutElementViewController.sheetPresentationController else {
            return
        }
        
        sheet.detents = [.medium()]
        sheet.largestUndimmedDetentIdentifier = .medium
        sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        sheet.prefersGrabberVisible = false
        sheet.preferredCornerRadius = 20
        
        addWorkoutElementViewController.delegate = addWorkoutElementDelegate
        present(addWorkoutElementViewController, animated: true)
        
        addWorkoutElementViewController.setSheetElements(sheetElements)
    }
    
    func closeSheet() {
        tableView.reloadData()
        presentedViewController?.dismiss(animated: true)
    }
}

extension EditWorkoutViewController: EditWorkoutDataModifier {
    func refreshData() {
        tableView.reloadData()
    }
    
    func delete(_ workoutElement: WorkoutElement) {
        workout?.elements?.remove(workoutElement)
        refreshData()
    }
}
