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
                        Text("about_me_title")
                    }
                }
                DisclaimerCell(
                    disclaimerText: self.viewModel.disclaimerText,
                    url: self.viewModel.disclaimerURL,
                    urlDescription: self.viewModel.urlDescription
                )
            }
            .navigationBarTitle("settings")
            .navigationBarColor(backgroundColor: Resource.Color.appRose, tintColor: .white)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel(appViewModel: MockApplicationViewModel()))
    }
}
