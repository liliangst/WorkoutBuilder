//
//  AddWorkoutElementCell.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 24/10/2023.
//

import UIKit

class AddWorkoutElementCell: UITableViewCell {
    
    static let identifier = "AddWorkoutElementCell"
    
    var action: Selector! {
        didSet {
            button.addTarget(nil, action: action, for: .touchUpInside)
        }
    }
    
    @IBOutlet var button: UIButton! {
        didSet {
            let configuration = UIImage.SymbolConfiguration(pointSize: 36, weight: .heavy)
            button.setImage(UIImage(systemName: "plus", withConfiguration: configuration), for: .normal)
            button.setTitle("", for: .normal)
            button.tintColor = Asset.gray2.color
        }
    }
    @IBOutlet var borderView: UIView! {
        didSet {
            borderView.layer.borderWidth = 5
            borderView.layer.borderColor = Asset.gray2.color.cgColor
            borderView.layer.cornerRadius = 10
            borderView.backgroundColor = .clear
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
