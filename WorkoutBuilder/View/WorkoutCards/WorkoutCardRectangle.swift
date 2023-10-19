//
//  WorkoutCard.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 11/10/2023.
//

import SwiftUI

struct WorkoutCardRectangle: View {
    @State var isFavorite: Bool = false
    let title: String
    let numberOfExercises: Int
    
    var body: some View {
        Button {

        } label: {
            ZStack {
                VStack(spacing: 5) {
                    HStack {
                        Text(title)
                            .font(FontFamily.PoppinsExtraBold.regular.swiftUIFont(fixedSize: 24))
                            .foregroundColor(Asset.gray1.swiftUIColor)

                        Spacer()

                        Button {
                            isFavorite.toggle()
                        } label: {
                            Image(systemName: isFavorite ? "star.fill" : "star")
                                .resizable()
                                .scaledToFit()
                                .font(.system(size: 24, weight: .heavy))
                                .frame(width: 20, height: 20)
                                .foregroundColor(Asset.green.swiftUIColor)
                        }.padding(.bottom, 15)

                    }
                    .padding([.horizontal, .top], 15)

                    HStack {
                        VStack {
                            Text(String(numberOfExercises) +
                                 String(numberOfExercises > 1 ? " exercices" : " exercice") +
                                 "\n1h10")
                            .font(FontFamily.DMSans.regular.swiftUIFont(fixedSize: 20))
                            .foregroundColor(Asset.gray1.swiftUIColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 15)

                            Spacer()
                        }

                        VStack {

                            Spacer()

                            HStack(spacing: 5) {
                                Spacer()

                                Button {
                                    // TODO: Start workout
                                } label: {
                                    Image(systemName: "play.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .font(.system(size: 24, weight: .heavy))
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(Asset.gray1.swiftUIColor)
                                        .padding(10)
                                }

                                Button {
                                    // TODO: Open workout edition page
                                } label: {
                                    Image(systemName: "square.and.pencil")
                                        .resizable()
                                        .scaledToFit()
                                        .font(.system(size: 24, weight: .heavy))
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(Asset.gray1.swiftUIColor)
                                        .padding(10)
                                }
                            }
                            .padding([.horizontal, .bottom], 10)
                        }
                    }
                }
            }
        }
        .frame(width: 300, height: 130)
        .padding(.vertical, 10)
        .buttonStyle(RaisedButtonStyle())
    }
}

#Preview {
    WorkoutCardRectangle(title: "Title", numberOfExercises: 4)
}
