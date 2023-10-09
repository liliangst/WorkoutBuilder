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
    @IBOutlet weak var musicCollectionView: UICollectionView! {
        didSet {
            musicCollectionView.dataSource = self
            musicCollectionView.backgroundColor = nil
        }
    }
    @IBOutlet weak var segmentedControl: UISegmentedControl! {
        didSet {
            segmentedControl.selectedSegmentIndex = 0
            segmentedControl.setTitleTextAttributes([.font : FontFamily.PoppinsExtraBold.regular.font(size: 14)], for: .normal)
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.isHidden = true
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
        NotificationCenter.default.addObserver(self, selector: #selector(didReceivePlaylistsFetchedNotification), name: Notification.Name("PlaylistsFetched"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceivePlayerConnectedNotification), name: Notification.Name("MusicPlayerConnected"), object: nil)
    }
    
    @objc func didReceivePlayerConnectedNotification(_ n: Notification) {
        if let connected = n.object as? Bool, connected {
            connectSpotifyButton.isHidden = true
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
        }
    }
    
    @objc func didReceivePlaylistsFetchedNotification() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.musicSelectionStackView.isHidden = false
            self.musicCollectionView.reloadData()
        }
    }
    
    @IBAction func tapSegmentedControl(_ sender: UISegmentedControl, forEvent event: UIEvent) {
        musicCollectionView.reloadData()
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
        if let imageUrl = musicCollectionItem.images.first?.url {
            cell.imageView.kf.setImage(with: URL(string: imageUrl)!)
        }
        cell.uri = musicCollectionItem.uri
        return cell
    }
}
