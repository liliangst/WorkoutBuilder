//
//  EditExerciseViewController.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 06/11/2023.
//

import UIKit

class EditExerciseViewController: UIViewController {

    var exercise: Exercise
    var dataModifier: EditWorkoutDataModifier!
    
    private let secondes = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55]
    private let minutes = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    private let reps = 1...50
    
    private var exerciseTitle: String?
    private var numberOfReps: Int?
    private var weight: Int?
    private var duration: TimeInterval?
    
    private enum ExerciseType: Int {
        case withReps = 0
        case withTime = 1
    }
    
    @IBOutlet var backgroundView: UIView! {
        didSet {
            backgroundView.backgroundColor = Asset.darkGray.color.withAlphaComponent(0.4)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            backgroundView.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBOutlet var cardBackgroundView: UIView! {
        didSet {
            cardBackgroundView.layer.cornerRadius = 10
            cardBackgroundView.backgroundColor = Asset.gray3.color
        }
    }
    
    @IBOutlet var backButton: UIButton! {
        didSet {
            let btnConfiguration = UIImage.SymbolConfiguration(weight: .heavy)
            let backButtonImage = UIImage(systemName: "xmark", withConfiguration: btnConfiguration)
            backButton.setImage(backButtonImage, for: .normal)
            backButton.setTitle("", for: .normal)
            backButton.tintColor = Asset.green.color
        }
    }
    
    @IBOutlet var validateButton: UIButton! {
        didSet {
            let btnConfiguration = UIImage.SymbolConfiguration(weight: .heavy)
            let validateButtonImage = UIImage(systemName: "checkmark", withConfiguration: btnConfiguration)
            validateButton.setImage(validateButtonImage, for: .normal)
            validateButton.setTitle("", for: .normal)
            validateButton.tintColor = Asset.green.color
        }
    }
    
    @IBOutlet var deleteButton: UIButton! {
        didSet {
            let btnConfiguration = UIImage.SymbolConfiguration(weight: .heavy)
            let deleteButtonImage = UIImage(systemName: "trash", withConfiguration: btnConfiguration)
            deleteButton.setImage(deleteButtonImage?.withTintColor(Asset.gray1.color), for: .normal)
            deleteButton.setAttributedTitle(NSAttributedString(string: "Supprimer l'élement", attributes: [.font : FontFamily.DMSans.regular.font(size: 20), .foregroundColor: Asset.gray1.color]), for: .normal)
            deleteButton.tintColor = Asset.gray2.color
        }
    }
    
    @IBOutlet var label: UILabel! {
        didSet {
            label.text = "Exercice"
            label.font = FontFamily.PoppinsExtraBold.regular.font(size: 20)
            label.textColor = Asset.gray1.color
        }
    }
    
    @IBOutlet var exerciseLabel: UILabel! {
        didSet {
            exerciseLabel.text = "Titre de l'exercice:"
            exerciseLabel.font = FontFamily.DMSans.regular.font(size: 18)
            exerciseLabel.textColor = Asset.gray1.color
            exerciseLabel.numberOfLines = 2
        }
    }
    @IBOutlet var exerciseTitleTextField: UITextField! {
        didSet {
            exerciseTitleTextField.delegate = self
            exerciseTitleTextField.tintColor = Asset.green.color
            exerciseTitleTextField.backgroundColor = Asset.gray2.color
            exerciseTitleTextField.text = exercise.title
            exerciseTitleTextField.returnKeyType = .done
        }
    }
    
    @IBOutlet var exerciseSegmentedControl: UISegmentedControl! {
        didSet {
            exerciseSegmentedControl.setTitle("Répétitions", forSegmentAt: ExerciseType.withReps.rawValue)
            exerciseSegmentedControl.setTitle("Temps", forSegmentAt: ExerciseType.withTime.rawValue)
            exerciseSegmentedControl.setTitleTextAttributes([.foregroundColor: Asset.gray1.color, .font: FontFamily.PoppinsExtraBold.regular.font(size: 14)], for: .normal)
            exerciseSegmentedControl.setTitleTextAttributes([.foregroundColor: Asset.gray3.color], for: .selected)
            exerciseSegmentedControl.backgroundColor = Asset.gray2.color
            exerciseSegmentedControl.selectedSegmentIndex = ExerciseType.withReps.rawValue
            exerciseSegmentedControl.selectedSegmentTintColor = Asset.green.color
        }
    }
    
    @IBOutlet var repLabel: UILabel! {
        didSet {
            repLabel.font = FontFamily.DMSans.regular.font(size: 18)
            repLabel.textColor = Asset.gray1.color
        }
    }
    @IBOutlet var picker: UIPickerView! {
        didSet {
            picker.delegate = self
            picker.dataSource = self
        }
    }
    
    @IBOutlet var weightLabel: UILabel! {
        didSet {
            weightLabel.font = FontFamily.DMSans.regular.font(size: 18)
            weightLabel.textColor = Asset.gray1.color
            weightLabel.text = "Poids:"
        }
    }
    @IBOutlet var weightTextField: UITextField! {
        didSet {
            weightTextField.delegate = self
            weightTextField.tintColor = Asset.green.color
            weightTextField.backgroundColor = Asset.gray2.color
            weightTextField.keyboardType = .numberPad
            weightTextField.placeholder = "10 (Optionnel)"
        }
    }
    
    
    init(exercise: Exercise, dataModifier: EditWorkoutDataModifier) {
        self.exercise = exercise
        self.dataModifier = dataModifier
        super.init(nibName: "EditExerciseViewController", bundle: Bundle(for: Self.self))
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dismissKeyboard() {
        if weightTextField.isFirstResponder {
            weightTextField.resignFirstResponder()
        }
        if exerciseTitleTextField.isFirstResponder {
            exerciseTitleTextField.resignFirstResponder()
        }
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case ExerciseType.withReps.rawValue:
            weightLabel.isHidden = false
            weightTextField.isHidden = false
            
            repLabel.text = "Nombre de répétitions:"
            
            duration = nil
            
            picker.reloadAllComponents()
            
            if let weight = exercise.weight, let numberOfReps = exercise.numberOfReps  {
                self.weight = weight
                self.numberOfReps = numberOfReps
                
                weightTextField.text = "\(weight)"
                setUpPickerValues(from: numberOfReps)
            } else {
                picker.selectRow(0, inComponent: 0, animated: true)
            }
        case ExerciseType.withTime.rawValue:
            weightLabel.isHidden = true
            weightTextField.isHidden = true
            
            repLabel.text = "Temps d'éxécution:"
            
            numberOfReps = nil
            weight = nil
            
            picker.reloadAllComponents()
            
            if let duration = exercise.duration {
                self.duration = duration
                
                setUpPickerValues(from: duration)
            } else {
                picker.selectRow(0, inComponent: 0, animated: true)
                picker.selectRow(0, inComponent: 1, animated: true)
            }
        default:
            break
        }
    }
    
    @IBAction func tapBackButton() {
        dismiss(animated: true)
    }
    
    @IBAction func tapValidateButton() {
        if let exerciseTitle = exerciseTitle {
            exercise.title = exerciseTitle
        }
        
        exercise.numberOfReps = numberOfReps
        exercise.weight = weight
        exercise.duration = duration
        
        dataModifier.refreshData()
        dismiss(animated: true)
    }
    
    @IBAction func tapDeleteButton() {
        dataModifier.delete(exercise)
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if exercise.title.isEmpty {
            validateButton.isEnabled = false
        }

        if let numberOfReps = exercise.numberOfReps{
            self.numberOfReps = numberOfReps
            exerciseSegmentedControl.selectedSegmentIndex = ExerciseType.withReps.rawValue
            segmentedControlValueChanged(exerciseSegmentedControl)
        }
        
        if let weight = exercise.weight {
            self.weight = weight
            weightTextField.text = "\(weight)"
        }
        
        if let duration = exercise.duration {
            self.duration = duration
            exerciseSegmentedControl.selectedSegmentIndex = ExerciseType.withTime.rawValue
            segmentedControlValueChanged(exerciseSegmentedControl)
        }
    }
    
    private func setUpPickerValues(from duration: TimeInterval) {
        let minutesValue = Int(duration / 60)
        let secondesValue = Int(duration.truncatingRemainder(dividingBy: 60))
        
        picker.selectRow(minutes.firstIndex(of: minutesValue) ?? 0, inComponent: 0, animated: true)
        picker.selectRow(secondes.firstIndex(of: secondesValue) ?? 0, inComponent: 1, animated: true)
    }
    
    private func setUpPickerValues(from numberOfReps: Int) {
        let row = reps.map({$0}).firstIndex(of: numberOfReps) ?? 0
        
        picker.selectRow(row, inComponent: 0, animated: true)
    }
}

extension EditExerciseViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case exerciseTitleTextField:
            guard let title = textField.text, !title.isEmpty else {
                validateButton.isEnabled = false
                return
            }
            self.exerciseTitle = title
            validateButton.isEnabled = true
        case weightTextField:
            guard let text = textField.text, let weight = Int(text) else {
                self.weight = nil
                return
            }
            self.weight = weight
        default:
            break
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditExerciseViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard exerciseSegmentedControl.selectedSegmentIndex == ExerciseType.withTime.rawValue else {
            return "\(reps.map({$0})[row])"
        }
        
        if component == 0 {
            return "\(minutes[row])"
        }
        return "\(secondes[row])"
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 50.0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard exerciseSegmentedControl.selectedSegmentIndex == ExerciseType.withTime.rawValue else {
            numberOfReps = reps.map({$0})[row]
            return
        }
        let minutesRow = picker.selectedRow(inComponent: 0)
        let minutesSelected = minutes[minutesRow]
        
        let secondesRow = picker.selectedRow(inComponent: 1)
        let secondesSelected = secondes[secondesRow]
        
        duration = TimeInterval(minutesSelected * 60 + secondesSelected)
    }
}

extension EditExerciseViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        guard exerciseSegmentedControl.selectedSegmentIndex == ExerciseType.withTime.rawValue else {
            return 1
        }
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard exerciseSegmentedControl.selectedSegmentIndex == ExerciseType.withTime.rawValue else {
            return reps.count
        }
        if component == 0 {
            return minutes.count
        }
        return secondes.count
    }
    
    
}
