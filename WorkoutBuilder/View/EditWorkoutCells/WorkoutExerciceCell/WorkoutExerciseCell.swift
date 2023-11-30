//
//  WorkoutExerciseCell.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 25/10/2023.
//

import UIKit

class WorkoutExerciseCell: UITableViewCell {
    
    static let identifier = "WorkoutExerciseCell"
    
    var parentViewController: UIViewController!
    var dataModifier: EditWorkoutDataModifier!
    
    var exercise: Exercise! {
        didSet {
            setUpTitleLabel(with: exercise.title)
            setUpExerciseDesc()
        }
    }
    
    @IBOutlet var exerciseTitle: UILabel! {
        didSet {
            exerciseTitle.font = FontFamily.DMSans.regular.font(size: 20)
            exerciseTitle.textColor = Asset.Colors.green.color
            exerciseTitle.numberOfLines = 2
            
        }
    }
    @IBOutlet var exerciseDescLabel: UILabel! {
        didSet {
            exerciseDescLabel.font = FontFamily.DMSans.regular.font(size: 20)
            exerciseDescLabel.textColor = Asset.Colors.gray2.color
            exerciseDescLabel.numberOfLines = 2
            exerciseDescLabel.text = ""
        }
    }
    @IBOutlet var editButton: UIButton! {
        didSet {
            let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .heavy)
            editButton.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: configuration), for: .normal)
            editButton.setTitle("", for: .normal)
            editButton.tintColor = Asset.Colors.gray1.color
        }
    }
    @IBOutlet var borderView: UIView! {
        didSet {
            borderView.layer.borderWidth = 5
            borderView.layer.borderColor = Asset.Colors.green.color.cgColor
            borderView.layer.cornerRadius = 10
            borderView.backgroundColor = .clear
        }
    }
    
    @IBAction func openEditExerciseView(_ sender: UIButton) {
        let editExerciseVC = EditExerciseViewController(exercise: exercise, dataModifier: dataModifier)
        parentViewController.present(editExerciseVC, animated: true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(false, animated: false)
    }

    private func setUpTitleLabel(with title: String) {
        guard !exercise.title.isEmpty else {
            return
        }
        exerciseTitle.text = exercise.title
    }
    
    private func setUpExerciseDesc() {
        if let weight = exercise.weight, let numberOfReps = exercise.numberOfReps {
            exerciseDescLabel.text = "\(weight)kg \n×\(numberOfReps)"
        } else if let numberOfReps = exercise.numberOfReps {
            exerciseDescLabel.text = "×\(numberOfReps)"
        }
        
        if let duration = exercise.duration {
            exerciseDescLabel.text = TimeFormatter.formatToString(timeInMilliseconds: UInt(duration) * 1000)
        }
    }
}
