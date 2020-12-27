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

                Section {
                    DisclaimerCell(
                        disclaimerText: self.viewModel.iconDisclaimerText,
                        url: self.viewModel.iconDisclaimerURL,
                        urlDescription: self.viewModel.iconURLDescription
                    )
                }
            }
            .navigationBarTitle(R.string.localizable.settings())
            .navigationBarColor(backgroundColor: .appRose, tintColor: .white)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel())
    }
}
