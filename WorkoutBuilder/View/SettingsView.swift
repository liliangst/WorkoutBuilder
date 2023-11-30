//
//  SettingsView.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 30/11/2023.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Paramètres")
                    .font(FontFamily.PoppinsExtraBold.regular.swiftUIFont(size: 32))
                    .foregroundStyle(Asset.Colors.gray1.swiftUIColor)
                
                Spacer()
            }
            
            Text("Contactez-nous par mail via l'adresse suivante: \nliliangst@outlook.fr")
                .font(FontFamily.DMSans.regular.swiftUIFont(size: 18))
                .multilineTextAlignment(.center)
                .foregroundStyle(Asset.Colors.gray1.swiftUIColor)
                .tint(Asset.Colors.green.swiftUIColor)
            
            Text("Version de l'application: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)")
                .font(FontFamily.DMSans.regular.swiftUIFont(size: 16))
                .multilineTextAlignment(.center)
                .foregroundStyle(Asset.Colors.gray1.swiftUIColor)
                .tint(Asset.Colors.green.swiftUIColor)
            
            Spacer()
        }
        .padding(20)
    }
}

#Preview {
    SettingsView()
}
