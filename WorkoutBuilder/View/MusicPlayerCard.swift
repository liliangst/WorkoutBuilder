//
//  MusicPlayerCard.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 21/08/2023.
//

import SwiftUI

struct MusicPlayerCard: View {
    @State var paused: Bool = false
    @State var isEmptyState: Bool = true
    @State var trackImage: UIImage?
    @State var currentTrack: SPTAppRemoteTrack?
    
    @State private var trackTimerAmount = 0.0
    @State private var trackTimerDuration = 0.0
    private let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        let offset: CGFloat = 5
        ZStack {
            VStack {
                Text("Pas de service de musique disponible")
                    .font(FontFamily.PoppinsExtraBold.regular.swiftUIFont(size: 24))
                    .foregroundColor(Asset.gray1.swiftUIColor)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                Text("Pour ajouter un service de musique veuillez vous connecter dans l'onglet musique.")
                    .font(FontFamily.DMSans.regular.swiftUIFont(size: 20))
                    .foregroundColor(Asset.gray1.swiftUIColor)
                    .multilineTextAlignment(.center)
            }
            .minimumScaleFactor(0.01)
            .onReceive(NotificationCenter.default.publisher(for: .MusicPlayerConnected)) { notification in
                isEmptyState = !(notification.object as! Bool)
            }
            .opacity(isEmptyState ? 1.0 : 0.0)
            
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(Asset.gray3.swiftUIColor)
                    .offset(y: offset)
                
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(Asset.gray3.swiftUIColor)
                
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Asset.gray2.swiftUIColor)
                    .padding(5)
                
                VStack(spacing: 20) {
                    HStack(spacing: 15) {
                        ZStack {
                            // This is a placeholder
                            // Show green rectangle when there is no image
                            Rectangle()
                                .foregroundColor(Asset.green.swiftUIColor)
                            Image(systemName: "music.note")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(10)
                                .foregroundColor(Asset.gray1.swiftUIColor)
                            
                            if let trackImage = trackImage {
                                Image(uiImage: trackImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                        .cornerRadius(10)
                        .frame(width: 60, height: 60)
                        .onReceive(NotificationCenter.default.publisher(for: .TrackImageLoaded)) { notification in
                            trackImage = notification.object as? UIImage
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text(currentTrack?.name ?? "Music")
                                .font(FontFamily.DMSans.regular.swiftUIFont(size: 18))
                                .lineLimit(2)
                            Text(currentTrack?.artist.name ?? "Artist")
                                .font(FontFamily.DMSans.regular.swiftUIFont(size: 18))
                                .lineLimit(1)
                        }
                        .foregroundColor(Asset.gray1.swiftUIColor)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    HStack {
                        Text(TimeFormatter.formatToString(timeInMilliseconds: UInt(trackTimerAmount) * 1000))
                            .frame(width: 35)
                        ProgressView(value: trackTimerAmount, total: Double(currentTrack?.duration ?? 0) / 1000)
                            .progressViewStyle(MusicPlayerProgressStyle())
                            .onReceive(timer) { _ in
                                if trackTimerAmount < Double(currentTrack?.duration ?? 0 / 1000) && !paused {
                                    trackTimerAmount += 1
                                }
                            }
                            .onReceive(NotificationCenter.default.publisher(for: .TrackPlaybackPosition)) { notification in
                                guard let position = notification.object as? Int else {
                                    return
                                }
                                trackTimerAmount = Double(position / 1000)
                            }
                        Text(TimeFormatter.formatToString(timeInMilliseconds: currentTrack?.duration ?? 0))
                            .frame(width: 35)
                    }
                    .frame(height: 10)
                    .font(FontFamily.DMSans.regular.swiftUIFont(size: 10))
                    .foregroundColor(Asset.gray1.swiftUIColor)
                    .padding(.horizontal, 15)
                    .onReceive(NotificationCenter.default.publisher(for: .CurrentTrack)) { notification in
                        let track = notification.object as? SPTAppRemoteTrack
                        if currentTrack != nil && currentTrack?.uri != track?.uri {
                            trackTimerAmount = 0.0
                            trackTimerDuration = Double(currentTrack?.duration ?? 0)
                        }
                        currentTrack = track
                    }
                    
                    HStack(spacing: 30) {
                        Button {
                            SpotifyHandler.shared.previous()
                        } label: {
                            Image(systemName: "backward.fill")
                                .font(.system(size: 32, weight: .heavy))
                        }
                        
                        Button {
                            SpotifyHandler.shared.togglePlayPause(isNowPaused: paused)
                        } label: {
                            Image(systemName: paused ? "play.fill" : "pause.fill")
                                .font(.system(size: 32, weight: .heavy))
                                .frame(width: 30, height: 30)
                        }
                        .onReceive(NotificationCenter.default.publisher(for: .IsPlayerPaused)) { notification in
                            paused = notification.object as! Bool
                        }
                        
                        Button {
                            SpotifyHandler.shared.next()
                        } label: {
                            Image(systemName: "forward.fill")
                                .font(.system(size: 32, weight: .heavy))
                        }
                        
                    }
                    .foregroundColor(Asset.gray1.swiftUIColor)
                }
            }
            .opacity(isEmptyState ? 0.0 : 1.0)
        }
        .aspectRatio(1.75, contentMode: .fill)
    }
}

struct MusicPlayerProgressStyle: ProgressViewStyle {
    var height: Double = 10.0
    
    func makeBody(configuration: Configuration) -> some View {
        let progress = configuration.fractionCompleted ?? 0
        
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(Asset.gray3.swiftUIColor)
                    .frame(height: height)
                    .frame(width: geometry.size.width)
                
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(Asset.gray1.swiftUIColor)
                    .frame(width: geometry.size.width * progress, height: height)
            }
        }
    }
}
