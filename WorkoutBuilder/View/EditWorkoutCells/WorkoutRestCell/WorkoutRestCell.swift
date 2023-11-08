//
//  WorkoutRestCell.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 25/10/2023.
//

import UIKit

class WorkoutRestCell: UITableViewCell {

    static let identifier = "WorkoutRestCell"
    
    var parentViewController: UIViewController!
    var dataModifier: EditWorkoutDataModifier!
    
    var rest: Rest! {
        didSet {
            setUpRestTimeLabel(from: rest.duration ?? 0)
        }
    }
    
    @IBOutlet var restTitle: UILabel! {
        didSet {
            restTitle.font = FontFamily.DMSans.regular.font(size: 20)
            restTitle.textColor = Asset.gray2.color
            restTitle.text = "Repos"
        }
    }
    @IBOutlet var restTimeLabel: UILabel! {
        didSet {
            restTimeLabel.font = FontFamily.DMSans.regular.font(size: 20)
            restTimeLabel.textColor = Asset.gray2.color
        }
    }
    @IBOutlet var editButton: UIButton! {
        didSet {
            let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .heavy)
            editButton.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: configuration), for: .normal)
            editButton.setTitle("", for: .normal)
            editButton.tintColor = Asset.gray1.color
        }
    }
    @IBOutlet var borderView: UIView! {
        didSet {
            borderView.layer.borderWidth = 5
            borderView.layer.borderColor = Asset.green.color.cgColor
            borderView.layer.cornerRadius = 10
            borderView.backgroundColor = .clear
        }
    }
    
    @IBAction func openEditRestView(_ sender: UIButton) {
        let editRestVC = EditRestViewController(rest: rest, dataModifier: dataModifier)
        parentViewController.present(editRestVC, animated: true)
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
    
    private func setUpRestTimeLabel(from duration: TimeInterval) {
        restTimeLabel.text = TimeFormatter.formatToString(timeInMilliseconds: UInt(duration) * 1000)
    }
    
}
