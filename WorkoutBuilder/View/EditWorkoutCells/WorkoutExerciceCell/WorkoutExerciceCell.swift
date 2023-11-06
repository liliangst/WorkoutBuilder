//
//  WorkoutExerciceCell.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 25/10/2023.
//

import UIKit

class WorkoutExerciceCell: UITableViewCell {
    
    static let identifier = "WorkoutExerciceCell"
    
    @IBOutlet var exerciceTitle: UILabel! {
        didSet {
            exerciceTitle.font = FontFamily.DMSans.regular.font(size: 20)
            exerciceTitle.textColor = Asset.green.color
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

}
