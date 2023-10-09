//
//  PlaylistAlbumCollectionViewCell.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 25/09/2023.
//

import UIKit

class PlaylistAlbumCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MusicCollectionCell"
    
    var uri: String = ""
    
    @IBOutlet weak var menuButton: UIButton! {
        didSet {
            menuButton.showsMenuAsPrimaryAction = true
            let play = UIAction(title: "Jouer", image: UIImage(systemName: "play.fill"), handler: { _ in
                SpotifyHandler.shared.play(self.uri)
            })
            let menu = UIMenu(children: [play])
            menuButton.menu = menu
        }
    }
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = FontFamily.DMSans.regular.font(size: 14)
        }
    }
    @IBOutlet weak var artistLabel: UILabel! {
        didSet {
            artistLabel.font = FontFamily.DMSans.regular.font(size: 12)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
