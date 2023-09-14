//
//  Constant.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 06/09/2023.
//

import Foundation

class Constant {
    static let SpotifyClientID = "326d81e466fb4fd2905d8dd3ebd6e684"
    static let SpotifyClientSecret = "23fdd6750f124dc7823174ca5a88d25e"
    static let SpotifyRedirectURL = URL(string: "spotify-workout-builder://spotify-login-callback")!
    static let kAccessTokenKey = "access-token-key"
    
    static var spotifyConfiguration = SPTConfiguration(
        clientID: Constant.SpotifyClientID,
        redirectURL: Constant.SpotifyRedirectURL
    )
}
