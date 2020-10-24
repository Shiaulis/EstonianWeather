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
                LanguageCell(
                    currentLanguage: self.viewModel.currentLanguageName,
                    didSelected: self.viewModel.openApplicationSettings
                )
            }
            .navigationBarTitle("settings")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel(settingsService: SettingsService()))
    }
}
