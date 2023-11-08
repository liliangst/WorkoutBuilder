//
//  EditRestViewController.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 06/11/2023.
//

import UIKit

class EditRestViewController: UIViewController {

    var rest: Rest
    var dataModifier: EditWorkoutDataModifier!
    
    private let secondes = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55]
    private let minutes = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    
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
    
    @IBOutlet var label: UILabel! {
        didSet {
            label.text = "Repos"
            label.font = FontFamily.PoppinsExtraBold.regular.font(size: 20)
            label.textColor = Asset.gray1.color
        }
    }
    @IBOutlet var restTimePicker: UIPickerView! {
        didSet {
            restTimePicker.dataSource = self
            restTimePicker.delegate = self
        }
    }
    
    init(rest: Rest, dataModifier: EditWorkoutDataModifier) {
        self.rest = rest
        self.dataModifier = dataModifier
        super.init(nibName: "EditRestViewController", bundle: Bundle(for: Self.self))
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func tapBackButton() {
        dismiss(animated: true)
    }
    
    @IBAction func tapValidateButton() {
        let minutesRow = restTimePicker.selectedRow(inComponent: 0)
        let minutesSelected = minutes[minutesRow]
        
        let secondesRow = restTimePicker.selectedRow(inComponent: 1)
        let secondesSelected = secondes[secondesRow]
        
        rest.duration = TimeInterval(minutesSelected * 60 + secondesSelected)
        
        dataModifier.refreshData()
        dismiss(animated: true)
    }
    
    @IBAction func tapDeleteButton() {
        dataModifier.delete(rest)
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let duration = rest.duration {
            setUpPickersValues(from: duration)
        }
    }
    
    private func setUpPickersValues(from duration: TimeInterval) {
        let minutesValue = Int(duration / 60)
        let secondesValue = Int(duration.truncatingRemainder(dividingBy: 60))
        
        restTimePicker.selectRow(minutes.firstIndex(of: minutesValue) ?? 0, inComponent: 0, animated: true)
        restTimePicker.selectRow(secondes.firstIndex(of: secondesValue) ?? 0, inComponent: 1, animated: true)
    }
}

extension EditRestViewController: UIPickerViewDataSource {
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

extension EditRestViewController: UIPickerViewDelegate {
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
