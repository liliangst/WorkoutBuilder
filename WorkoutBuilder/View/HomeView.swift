//
//  HomeView.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 21/11/2023.
//

import SwiftUI

struct HomeView: View {
    
    var delegate: EditWorkoutDelegate
    
    @State var isWorkoutPlayerEnabled: Bool = false
    
    init(delegate: EditWorkoutDelegate) {
        self.delegate = delegate
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Text("Musique")
                    .font(FontFamily.PoppinsExtraBold.regular.swiftUIFont(fixedSize: 32))
                    .foregroundStyle(Asset.Colors.gray1.swiftUIColor)
                    .padding(.leading, 15)
                
                MusicPlayerCard()
                
                if isWorkoutPlayerEnabled {
                    Text("Séance en cours")
                        .font(FontFamily.PoppinsExtraBold.regular.swiftUIFont(fixedSize: 32))
                        .foregroundStyle(Asset.Colors.gray1.swiftUIColor)
                        .padding(.leading, 15)
                    
                    WorkoutPlayerCard()
                }
                
                Text("Séances")
                    .font(FontFamily.PoppinsExtraBold.regular.swiftUIFont(fixedSize: 32))
                    .foregroundStyle(Asset.Colors.gray1.swiftUIColor)
                    .padding(.leading, 15)
                
               FavoriteWorkoutsCarousel(delegate: delegate)
            }
            .padding(.horizontal, 20)
            .padding(.top, 55)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity)
            .onReceive(NotificationCenter.default.publisher(for: .WorkoutToPlaySelected)) { notification in
                guard let isEnabled = notification.object as? Bool else {
                    return
                }
                isWorkoutPlayerEnabled = isEnabled
            }
        }
        .background(Asset.Colors.darkGray.swiftUIColor)
    }
}
