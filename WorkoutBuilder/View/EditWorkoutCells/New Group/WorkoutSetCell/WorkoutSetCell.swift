//
//  WorkoutSetCell.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 25/10/2023.
//

import UIKit
import SwiftUI

class WorkoutSetCell: UITableViewCell {

    static let identifier = "WorkoutSetCell"
    
    var set: Sets = Sets()
    
    var delegate: AddWorkoutElementSheetDelegate?
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = FontFamily.DMSans.regular.font(size: 30)
            titleLabel.textColor = Asset.green.color
            titleLabel.text = "Série"
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
    @IBOutlet var titleBorderView: UIView! {
        didSet {
            titleBorderView.layer.borderWidth = 5
            titleBorderView.layer.borderColor = Asset.green.color.cgColor
            titleBorderView.layer.cornerRadius = 10
            titleBorderView.backgroundColor = .clear
        }
    }
    
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.isScrollEnabled = false
            tableView.dataSource = self
            tableView.register(UINib(nibName: AddWorkoutElementCell.identifier, bundle: nil), forCellReuseIdentifier: AddWorkoutElementCell.identifier)
            tableView.register(UINib(nibName: WorkoutExerciceCell.identifier, bundle: nil), forCellReuseIdentifier: WorkoutExerciceCell.identifier)
            tableView.register(UINib(nibName: WorkoutRestCell.identifier, bundle: nil), forCellReuseIdentifier: WorkoutRestCell.identifier)
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
    
    @objc func tapAddWorkoutElementCell() {
        delegate?.openSheet(self, sheetElements: [Exercice.self, Rest.self])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(false, animated: false)
    }
}
