//
//  NewWorkoutViewController.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 13/10/2023.
//

import UIKit

class NewWorkoutViewController: UIViewController {

    override func viewDidLoad() {
        let btnConfiguration = UIImage.SymbolConfiguration(weight: .heavy)
        let backButtonImage = UIImage(systemName: "arrowshape.turn.up.left", withConfiguration: btnConfiguration)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backButtonImage, style: .done, target: self, action: #selector(tapBackButton))
    }
    
    @objc private func tapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
