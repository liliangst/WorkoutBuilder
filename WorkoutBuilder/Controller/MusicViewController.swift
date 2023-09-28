//
//  MusicViewController.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 07/09/2023.
//

import UIKit
import Kingfisher

class MusicViewController: UIViewController {

    @IBOutlet weak var connectSpotifyButton: UIButton!
    @IBOutlet weak var musicSelectionStackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.backgroundColor = nil
        }
    }
    @IBOutlet weak var segmentedControl: UISegmentedControl! {
        didSet {
            self.segmentedControl.selectedSegmentIndex = 0
        }
    }
    
    var musicCollectionData: [SpotifyCollectionObject] {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return SpotifyHandler.shared.userPlaylists
        case 1:
            return SpotifyHandler.shared.userAlbums
        default:
            return []
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(showMusicSelection), name: Notification.Name("PlaylistsFetched"), object: nil)
    }
    
    @objc func showMusicSelection() {
        connectSpotifyButton.isHidden = true
        musicSelectionStackView.isHidden = false
        collectionView.reloadData()
    }
    
    @IBAction func tapSegmentedControl(_ sender: UISegmentedControl, forEvent event: UIEvent) {
        // TODO: This
        collectionView.reloadData()
    }
    
    @IBAction func tapConnectToSpotify() {
        SpotifyHandler.shared.initiate()
    }
}

extension MusicViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicCollectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistAlbumCollectionViewCell.identifier, for: indexPath) as! PlaylistAlbumCollectionViewCell
        let musicCollectionItem = musicCollectionData[indexPath.row]
        cell.titleLabel.text = musicCollectionItem.title
        cell.artistLabel.text = musicCollectionItem.displayName
        cell.imageView.kf.setImage(with: URL(string: musicCollectionItem.images[0].url)!)
        return cell
    }
}

extension MusicViewController: UICollectionViewDelegate {
    
}
