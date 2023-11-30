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
    func delete(_ workoutElement: WorkoutElementObject)
    func refreshData()
}

class EditWorkoutViewController: UIViewController {

    var workout: Workout?
    
    var workoutTitle: String?
    var workoutElementsList: [WorkoutElementObject] = []
    
    @IBOutlet var titleTextField: UITextField! {
        didSet {
            titleTextField.delegate = self
            titleTextField.tintColor = Asset.Colors.green.color
        }
    }
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.allowsSelection = false
            tableView.register(UINib(nibName: AddWorkoutElementCell.identifier, bundle: nil), forCellReuseIdentifier: AddWorkoutElementCell.identifier)
            tableView.register(UINib(nibName: WorkoutExerciseCell.identifier, bundle: nil), forCellReuseIdentifier: WorkoutExerciseCell.identifier)
            tableView.register(UINib(nibName: WorkoutRestCell.identifier, bundle: nil), forCellReuseIdentifier: WorkoutRestCell.identifier)
            tableView.register(UINib(nibName: WorkoutSetCell.identifier, bundle: nil), forCellReuseIdentifier: WorkoutSetCell.identifier)
        }
    }
    @IBOutlet var deleteWorkoutButton: UIButton! {
        didSet {
            let btnConfiguration = UIImage.SymbolConfiguration(weight: .heavy)
            let deleteButtonImage = UIImage(systemName: "trash", withConfiguration: btnConfiguration)
            deleteWorkoutButton.setImage(deleteButtonImage?.withTintColor(Asset.Colors.gray1.color), for: .normal)
            deleteWorkoutButton.setAttributedTitle(NSAttributedString(string: "Supprimer", attributes: [.font : FontFamily.DMSans.regular.font(size: 20), .foregroundColor: Asset.Colors.gray1.color]), for: .normal)
            deleteWorkoutButton.tintColor = Asset.Colors.gray2.color
        }
    }
    

    override func viewDidLoad() {
        let btnConfiguration = UIImage.SymbolConfiguration(weight: .heavy)
        let backButtonImage = UIImage(systemName: "arrowshape.turn.up.left", withConfiguration: btnConfiguration)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backButtonImage, style: .done, target: self, action: #selector(tapBackButton))
        
        let validateButtonImage = UIImage(systemName: "checkmark", withConfiguration: btnConfiguration)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: validateButtonImage, style: .done, target: self, action: #selector(tapValidateButton))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        guard let workout = workout else { return }
        
        if !workout.title.isEmpty {
            titleTextField.text = workout.title
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        
        workoutElementsList = workout.elementsObjects
    }
    
    @objc private func tapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func tapValidateButton() {
        guard let workout = workout else { return }
        
        if let title = workoutTitle {
            WorkoutManager.shared.saveChanges {
                workout.title = title
            }
        }
        
        workoutElementsList.forEach { element in
            if let element = element as? Sets {
                element.saveElements()
            }
            workout.insert(element)
        }
        
        if let index = WorkoutManager.shared.workouts.firstIndex(where: {$0.id == workout.id}) {
            WorkoutManager.shared.workouts[index] = workout
        } else {
            WorkoutManager.shared.insert(workout)
        }
        tapBackButton()
    }
    
    @IBAction func tapDeleteButton() {
        guard let workout = workout else {
            tapBackButton()
            return
        }
        if let workoutToDelete = WorkoutManager.shared.workouts.first(where: {$0.id == workout.id}) {
            WorkoutManager.shared.remove(workoutToDelete)
        }
        tapBackButton()
    }
    
    @objc private func tapAddWorkoutElementCell() {
        if titleTextField.isEditing { return }
        openSheet(self, sheetElements: [Sets.self, Exercise.self, Rest.self])
    }

    @IBAction func dismissKeyboard(_ sender: Any) {
        titleTextField.resignFirstResponder()
    }
}

extension EditWorkoutViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let title = textField.text, !title.isEmpty else {
            workoutTitle = nil
            navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
        workoutTitle = title
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
}

extension EditWorkoutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        workoutElementsList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        guard workoutElementsList.count > indexPath.row else {
            cell = tableView.dequeueReusableCell(withIdentifier: AddWorkoutElementCell.identifier, for: indexPath) as! AddWorkoutElementCell
            (cell as! AddWorkoutElementCell).action = #selector(tapAddWorkoutElementCell)
            return cell
        }
        
        switch workoutElementsList[indexPath.row].self {
        case is Exercise: let exerciseCell = tableView.dequeueReusableCell(withIdentifier: WorkoutExerciseCell.identifier, for: indexPath) as! WorkoutExerciseCell
            let exercise = workoutElementsList[indexPath.row] as! Exercise
            exerciseCell.parentViewController = self
            exerciseCell.exercise = exercise
            exerciseCell.dataModifier = self
            cell = exerciseCell
        case is Rest: let restCell = tableView.dequeueReusableCell(withIdentifier: WorkoutRestCell.identifier, for: indexPath) as! WorkoutRestCell
            let rest = workoutElementsList[indexPath.row] as! Rest
            restCell.parentViewController = self
            restCell.rest = rest
            restCell.dataModifier = self
            cell = restCell
        case is Sets: let setsCell = tableView.dequeueReusableCell(withIdentifier: WorkoutSetCell.identifier, for: indexPath) as! WorkoutSetCell
            let set = workoutElementsList[indexPath.row] as! Sets
            setsCell.delegate = self
            WorkoutManager.shared.fetchElements(for: set)
            setsCell.set = set
            setsCell.dataModifier = self
            setsCell.parentViewController = self
            cell = setsCell
        default:
            break
        }
        
        return cell
    }
}

extension EditWorkoutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row < workoutElementsList.count, workoutElementsList[indexPath.row] is Sets else {
            return 105
        }
        guard let set = workoutElementsList[indexPath.row] as? Sets else {
            return 215
        }
        return CGFloat(110 + 105 * (set.editedElementsObjectsList.count + 1))
    }
}

extension EditWorkoutViewController: AddWorkoutElementDelegate {
    func addElement(_ element: WorkoutElementObject.Type) {
        switch element {
        case is Sets.Type:
            workoutElementsList.append(Sets())
        case is Exercise.Type:
            workoutElementsList.append(Exercise())
        case is Rest.Type:
            workoutElementsList.append(Rest())
        default:
            break
        }
        tableView.reloadData()
        closeSheet()
    }
}

extension EditWorkoutViewController: AddWorkoutElementSheetDelegate {
    func openSheet(_ addWorkoutElementDelegate: AddWorkoutElementDelegate, sheetElements: [WorkoutElementObject.Type]) {
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
    
    func delete(_ workoutElement: WorkoutElementObject) {
        workoutElementsList.removeAll(where: {$0 === workoutElement})
        workout?.remove(workoutElement)
        refreshData()
    }
}
