//
//  SettingsView.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 22.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import SwiftUI

struct SettingsView: View {

    let viewModel: SettingsViewModel

    var body: some View {
        NavigationView {
            Form {
                Section {
                    LanguageCell(
                        currentLanguage: self.viewModel.currentLanguageName,
                        didSelected: self.viewModel.openApplicationSettings
                    )
                }

                Section {
                    NavigationLink(destination: AboutMeView()) {
                        Text(R.string.localizable.aboutMeTitle())
                    }
                }

                Section {
                    DisclaimerCell(
                        disclaimerText: self.viewModel.sourceDisclaimerText,
                        url: self.viewModel.sourceDisclaimerURL,
                        urlDescription: self.viewModel.urlDescription
                    )
                }
            }
            .navigationBarTitle(R.string.localizable.settings())
            .navigationBarColor(backgroundColor: .appRose, tintColor: .white)
            .onDisappear(perform: {
                            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                                self.viewModel.makeAttemptToShowRating(in: scene)
                            }

                        })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel(ratingService: AppStoreRatingService()))
    }
}
