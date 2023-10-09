//
//  SpotifyPlaylistData.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 22/09/2023.
//

import Foundation

struct SpotifyPlaylistData: Decodable {
    var next: String?
    var total: Int
    var items: [SpotifySimplifiedPlaylistObject]
}

struct SpotifySimplifiedPlaylistObject: Decodable, SpotifyCollectionObject {
    var id: String
    var title: String {
        name
    }
    var uri: String
    var images: [SpotifyImageObject]
    var displayName: String {
        owner.display_name ?? ""
    }
    
    private var name: String
    private var owner: SpotifyPlaylistOwnerObject
}

struct SpotifyPlaylistOwnerObject: Decodable {
    var display_name: String?
}
