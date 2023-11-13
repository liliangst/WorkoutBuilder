//
//  EditSetViewController.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 06/11/2023.
//

import UIKit

class EditSetViewController: UIViewController {
    
    var set: Sets
    var dataModifier: EditWorkoutDataModifier!

    private let secondes = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55]
    private let minutes = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    var numberOfSets: Int {
        didSet {
            numberOfSetsLabel.text = "Nombre de séries: \(numberOfSets)"
        }
    }
    
    @IBOutlet var backgroundView: UIView! {
        didSet {
            backgroundView.backgroundColor = Asset.darkGray.color.withAlphaComponent(0.4)
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
    
    @IBOutlet var setLabel: UILabel! {
        didSet {
            setLabel.text = "Série"
            setLabel.font = FontFamily.PoppinsExtraBold.regular.font(size: 20)
            setLabel.textColor = Asset.gray1.color
        }
    }
    @IBOutlet var numberOfSetsLabel: UILabel! {
        didSet {
            numberOfSetsLabel.text = "Nombre de séries: \(set.numberOfSets)"
            numberOfSetsLabel.font = FontFamily.DMSans.regular.font(size: 18)
            numberOfSetsLabel.textColor = Asset.gray1.color
            numberOfSetsLabel.textAlignment = .right
        }
    }
    @IBOutlet var restTimeBetweenSetsLabel: UILabel! {
        didSet {
            restTimeBetweenSetsLabel.text = "Repos entre les séries:"
            restTimeBetweenSetsLabel.font = FontFamily.DMSans.regular.font(size: 18)
            restTimeBetweenSetsLabel.textColor = Asset.gray1.color
        }
    }
    
    @IBOutlet var numberOfSetsStepper: UIStepper! {
        didSet {
            numberOfSetsStepper.minimumValue = 1
            numberOfSetsStepper.maximumValue = 10
            numberOfSetsStepper.value = 1
            numberOfSetsStepper.stepValue = 1
            numberOfSetsStepper.backgroundColor = Asset.gray2.color
            numberOfSetsStepper.layer.cornerRadius = 10
            numberOfSetsStepper.tintColor = Asset.green.color
            numberOfSetsStepper.setIncrementImage(numberOfSetsStepper.incrementImage(for: .normal), for: .normal)
            numberOfSetsStepper.setDecrementImage(numberOfSetsStepper.decrementImage(for: .normal), for: .normal)
        }
    }
    @IBOutlet var restTimePicker: UIPickerView! {
        didSet {
            restTimePicker.dataSource = self
            restTimePicker.delegate = self
        }
    }
    
    @IBAction func tapBackButton() {
        dismiss(animated: true)
    }
    
    @IBAction func tapValidateButton() {
        let minutesRow = restTimePicker.selectedRow(inComponent: 0)
        let minutesSelected = minutes[minutesRow]
        
        let secondesRow = restTimePicker.selectedRow(inComponent: 1)
        let secondesSelected = secondes[secondesRow]
        
        WorkoutManager.saveChanges {
            set.restBetweenSet = TimeInterval(minutesSelected * 60 + secondesSelected)
            set.numberOfSets = numberOfSets
        }
        
        dataModifier.refreshData()
        dismiss(animated: true)
    }
    
    @IBAction func tapDeleteButton() {
        dataModifier.delete(set)
        dismiss(animated: true)
    }
    
    @IBAction func numberOfSetsStepperValueChanged(_ sender: UIStepper) {
        numberOfSets = Int(sender.value)
    }
    
    init(set: Sets, dataModifier: EditWorkoutDataModifier) {
        self.set = set
        self.dataModifier = dataModifier
        self.numberOfSets = set.numberOfSets
        super.init(nibName: "EditSetViewController", bundle: Bundle(for: Self.self))
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let restDuration = set.restBetweenSet {
            setUpPickersValues(from: restDuration)
        }
    }
    
    private func setUpPickersValues(from duration: TimeInterval) {
        let minutesValue = Int(duration / 60)
        let secondesValue = Int(duration.truncatingRemainder(dividingBy: 60))
        
        restTimePicker.selectRow(minutes.firstIndex(of: minutesValue) ?? 0, inComponent: 0, animated: true)
        restTimePicker.selectRow(secondes.firstIndex(of: secondesValue) ?? 0, inComponent: 1, animated: true)
    }

}

extension EditSetViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return minutes.count
        }
        return secondes.count
    }
}

extension EditSetViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(minutes[row])"
        }
        return "\(secondes[row])"
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 50.0
    }
}
