//
//  SpotifyCollectionObject.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 26/09/2023.
//

import Foundation
protocol SpotifyCollectionObject {
    var id: String { get }
    var title: String { get }
    var uri: String { get }
    var images: [SpotifyImageObject] { get }
    var displayName: String { get }
}

struct SpotifyImageObject: Decodable {
    var url: String
}
