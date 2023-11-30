//
//  AddWorkoutElementViewController.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 30/10/2023.
//

import UIKit

protocol AddWorkoutElementDelegate {
    func addElement(_ element: WorkoutElementObject.Type)
}

protocol AddWorkoutElementSheetDelegate {
    func openSheet(_ addWorkoutElementDelegate: AddWorkoutElementDelegate, sheetElements: [WorkoutElementObject.Type])
    func closeSheet()
}

class AddWorkoutElementViewController: UIViewController {

    var delegate: AddWorkoutElementDelegate?
    var sheetElements: [WorkoutElementObject.Type]? {
        didSet {
            for element in sheetElements! {
                switch element {
                case is Sets.Type:
                    setBackgroundView.isHidden = false
                case is Exercise.Type:
                    exerciseBackgroundView.isHidden = false
                case is Rest.Type:
                    restBackgroundView.isHidden = false
                default:
                    break
                }
            }
        }
    }
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "Ajouter"
            titleLabel.font = FontFamily.PoppinsExtraBold.regular.font(size: 20)
            titleLabel.textColor = Asset.Colors.gray1.color
        }
    }
    
    @IBOutlet var setBackgroundView: UIView! {
        didSet {
            setBackgroundView.layer.borderWidth = 5
            setBackgroundView.layer.borderColor = Asset.Colors.green.color.cgColor
            setBackgroundView.layer.cornerRadius = 10
            setBackgroundView.backgroundColor = .clear
            
            setBackgroundView.isHidden = true
        }
    }
    @IBOutlet var addSetButton: UIButton! {
        didSet {
            addSetButton.setAttributedTitle(NSAttributedString(string: "Série", attributes: [.font : FontFamily.DMSans.regular.font(size: 32), .foregroundColor: Asset.Colors.green.color]), for: .normal)
            addSetButton.setAttributedTitle(NSAttributedString(string: "Série", attributes: [.font : FontFamily.DMSans.regular.font(size: 32), .foregroundColor: Asset.Colors.gray1.color]), for: .highlighted)
        }
    }
    
    @IBOutlet var exerciseBackgroundView: UIView! {
        didSet {
            exerciseBackgroundView.layer.borderWidth = 5
            exerciseBackgroundView.layer.borderColor = Asset.Colors.green.color.cgColor
            exerciseBackgroundView.layer.cornerRadius = 10
            exerciseBackgroundView.backgroundColor = .clear
            
            exerciseBackgroundView.isHidden = true
        }
    }
    @IBOutlet var addExerciseButton: UIButton! {
        didSet {
            addExerciseButton.setAttributedTitle(NSAttributedString(string: "Exercice", attributes: [.font : FontFamily.DMSans.regular.font(size: 32), .foregroundColor: Asset.Colors.green.color]), for: .normal)
            addExerciseButton.setAttributedTitle(NSAttributedString(string: "Exercice", attributes: [.font : FontFamily.DMSans.regular.font(size: 32), .foregroundColor: Asset.Colors.gray1.color]), for: .highlighted)
        }
    }
    
    @IBOutlet var restBackgroundView: UIView! {
        didSet {
            restBackgroundView.layer.borderWidth = 5
            restBackgroundView.layer.borderColor = Asset.Colors.green.color.cgColor
            restBackgroundView.layer.cornerRadius = 10
            restBackgroundView.backgroundColor = .clear
            
            restBackgroundView.isHidden = true
        }
    }
    @IBOutlet var addRestButton: UIButton! {
        didSet {
            addRestButton.setAttributedTitle(NSAttributedString(string: "Repos", attributes: [.font : FontFamily.DMSans.regular.font(size: 32), .foregroundColor: Asset.Colors.green.color]), for: .normal)
            addRestButton.setAttributedTitle(NSAttributedString(string: "Repos", attributes: [.font : FontFamily.DMSans.regular.font(size: 32), .foregroundColor: Asset.Colors.gray1.color]), for: .highlighted)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func didTapWorkoutElement(_ sender: UIButton) {
        switch sender {
        case addSetButton:
            delegate?.addElement(Sets.self)
        case addExerciseButton:
            delegate?.addElement(Exercise.self)
        case addRestButton:
            delegate?.addElement(Rest.self)
        default:
            break
        }
    }

    func setSheetElements(_ sheetElements: [WorkoutElementObject.Type]) {
        for element in sheetElements {
            switch element {
            case is Sets.Type:
                setBackgroundView.isHidden = false
            case is Exercise.Type:
                exerciseBackgroundView.isHidden = false
            case is Rest.Type:
                restBackgroundView.isHidden = false
            default:
                break
            }
        }
    }
    
}
