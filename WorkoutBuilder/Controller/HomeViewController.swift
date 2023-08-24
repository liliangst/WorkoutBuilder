//
//  HomeViewController.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 21/08/2023.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView! {
        didSet {
            stackView.spacing = 30
        }
    }
    
    var musicStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5.0
        stack.alignment = .leading
        stack.distribution = .fill
        return stack
    }()
    var workoutsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5.0
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up music section
        setUpLabel(in: musicStack, title: "Musique")
        setUpMusicPlayerView()
        stackView.addArrangedSubview(musicStack)
        NSLayoutConstraint.activate([
            musicStack.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            musicStack.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
        
        // Set up favorite workouts section
        setUpLabel(in: workoutsStack, title: "Séances")
        setUpWorkoutsCarouselView()
        stackView.addArrangedSubview(workoutsStack)
        
        // Adding an empty view at the bottom to fill the space
        let emptyView = UIView()
        emptyView.backgroundColor = nil
        stackView.addArrangedSubview(emptyView)
    }
    
    private func setUpMusicPlayerView() {
        let musicPlayerCard = MusicPlayerCard()
        let hostingMusicPlayerView = UIHostingController(rootView: musicPlayerCard)
        
        self.addChild(hostingMusicPlayerView)
        musicStack.addArrangedSubview(hostingMusicPlayerView.view)
        hostingMusicPlayerView.didMove(toParent: self)
        
        hostingMusicPlayerView.view.backgroundColor = nil
        
        hostingMusicPlayerView.view.translatesAutoresizingMaskIntoConstraints = false
        hostingMusicPlayerView.view.leadingAnchor.constraint(equalTo: musicStack.leadingAnchor).isActive = true
        hostingMusicPlayerView.view.trailingAnchor.constraint(equalTo: musicStack.trailingAnchor).isActive = true
    }
    
    private func setUpWorkoutsCarouselView() {
        let workoutsCarousel = FavoriteWorkoutsCarousel()
        let hostingWorkoutsCarousel = UIHostingController(rootView: workoutsCarousel)
        
        self.addChild(hostingWorkoutsCarousel)
        workoutsStack.addArrangedSubview(hostingWorkoutsCarousel.view)
        hostingWorkoutsCarousel.didMove(toParent: self)
        
        hostingWorkoutsCarousel.view.backgroundColor = nil
        
        hostingWorkoutsCarousel.view.translatesAutoresizingMaskIntoConstraints = false
        hostingWorkoutsCarousel.view.leadingAnchor.constraint(equalTo: workoutsStack.leadingAnchor).isActive = true
        hostingWorkoutsCarousel.view.trailingAnchor.constraint(equalTo: workoutsStack.trailingAnchor).isActive = true
        
    }
    
    private func setUpLabel(in stack: UIStackView, title: String) {
        let label = UILabel()
        
        stack.addArrangedSubview(label)
        
        label.text = title
        label.font = .appTitle1Font
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: stack.leadingAnchor, constant: 15).isActive = true
    }

}
