//
//  SpotifyAlbumData.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 26/09/2023.
//

import Foundation

struct SpotifyAlbumData: Decodable {
    var next: String?
    var total: Int
    var ablums: [SpotifyAlbumObject] {
        items.map({$0.album})
    }
    
    fileprivate var items: [SpotifySavedAlbumObject]
}

fileprivate struct SpotifySavedAlbumObject: Decodable {
    var album: SpotifyAlbumObject
}

struct SpotifyAlbumObject: Decodable, SpotifyCollectionObject {
    var id: String
    var title: String {
        name
    }
    var uri: String
    var images: [SpotifyImageObject]
    var displayName: String {
        artists.map({$0.name}).joined(separator: ", ")
    }
    
    private var name: String
    private var artists: [SpotifySimplifiedArtistObject]
}

struct SpotifySimplifiedArtistObject: Decodable {
    var name: String
}
