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
    
    var body: some View {
        let offset: CGFloat = 5
        ZStack {
            VStack {
                Text("Pas de service de musique disponible")
                    .font(.appTitle2Font)
                    .foregroundColor(.appGray1)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                Text("Pour ajouter un service de musique veuillez vous connecter dans l'onglet musique.")
                    .font(.appContentFont)
                    .foregroundColor(.appGray1)
                    .multilineTextAlignment(.center)
            }
            .minimumScaleFactor(0.01)
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("MusicPlayerConnected"))) { notification in
                isEmptyState = !(notification.object as! Bool)
            }
            .opacity(isEmptyState ? 1.0 : 0.0)
            
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.appGray3)
                    .offset(y: offset)
                
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.appGray3)
                
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.appGray2)
                    .padding(5)
                
                VStack(spacing: 20) {
                    HStack(spacing: 15) {
                        ZStack {
                            // This is a placeholder
                            // Show green rectangle when there is no image
                            Rectangle()
                                .foregroundColor(.appGreen)
                            Image(systemName: "music.note")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(10)
                                .foregroundColor(.appGray1)
                            
                            if let trackImage = trackImage {
                                Image(uiImage: trackImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                        .cornerRadius(10)
                        .frame(width: 60, height: 60)
                        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("TrackImageLoaded"))) { notification in
                            trackImage = notification.object as? UIImage
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text(SpotifyHandler.shared.currentTrack?.name ?? "Music title")
                                .font(.custom("DMSans-Regular", size: 18))
                                .lineLimit(2)
                            Text(SpotifyHandler.shared.currentTrack?.artist.name ?? "Artist")
                                .font(.custom("DMSans-Regular", size: 16))
                                .lineLimit(1)
                        }
                        .foregroundColor(.appGray1)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    HStack {
                        // TODO: progress values
                        Text("0:20")
                        ProgressView(value: 0.2)
                            .progressViewStyle(MusicPlayerProgressStyle())
                        Text(TimeFormatter.formatToString(timeInMilliseconds: SpotifyHandler.shared.currentTrack?.duration ?? 0))
                    }
                    .frame(height: 10)
                    .font(.custom("DMSans-Regular", size: 10))
                    .foregroundColor(.appGray1)
                    .padding(.horizontal, 15)
                    
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
                        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("IsPlayerPaused"))) { notification in
                            paused = notification.object as! Bool
                        }
                        
                        Button {
                            SpotifyHandler.shared.next()
                        } label: {
                            Image(systemName: "forward.fill")
                                .font(.system(size: 32, weight: .heavy))
                        }
                        
                    }
                    .foregroundColor(.appGray1)
                }
            }
            .opacity(isEmptyState ? 0.0 : 1.0)
        }
        .aspectRatio(1.75, contentMode: .fill)
    }
}

struct MusicPlayerCard_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayerCard()
    }
}

struct MusicPlayerProgressStyle: ProgressViewStyle {
    var height: Double = 10.0
    var labelFontStyle: Font = .body
    
    func makeBody(configuration: Configuration) -> some View {
        let progress = configuration.fractionCompleted ?? 0
        
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(Color.appGray3)
                    .frame(height: height)
                    .frame(width: geometry.size.width)
                
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(Color.appGray1)
                    .frame(width: geometry.size.width * progress, height: height)
            }
        }
    }
}
