//
//  NotificationNameExtension.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 09/10/2023.
//

import Foundation

extension Notification.Name {
    static let MusicPlayerConnected = Notification.Name("MusicPlayerConnected")
    static let PlaylistsFetched = Notification.Name("PlaylistsFetched")
    static let AlbumsFetched = Notification.Name("AlbumsFetched")
    static let IsPlayerPaused = Notification.Name("IsPlayerPaused")
    static let TrackImageLoaded = Notification.Name("TrackImageLoaded")
    static let CurrentTrack = Notification.Name("CurrentTrack")
    static let TrackPlaybackPosition = Notification.Name("TrackPlaybackPosition")
    static let DeleteFavoriteWorkout = Notification.Name("DeleteFavoriteWorkout")
    static let WorkoutToPlaySelected = Notification.Name("WorkoutToPlaySelected")
}
