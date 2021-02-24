//
//  SettingsView.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 22.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import SwiftUI
import StoreKit

struct SettingsView: View {

    let viewModel: SettingsViewModel
    @State private var purchased = false
    @ObservedObject private var products = ProductsDB.shared

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
                    List {
                        ForEach((0 ..< self.products.items.count), id: \.self) { column in
                            let product = self.products.items[column]

                            Text(description(for: product))
                                .onTapGesture {
                                    _ = IAPManager.shared.purchase(product: self.products.items[column])
                                }
                        }
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
            .onAppear {
                IAPManager.shared.getProducts()
            }
            .onDisappear(perform: {
                            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                                self.viewModel.makeAttemptToShowRating(in: scene)
                            }

                        })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func description(for product: SKProduct) -> String {
        let title = product.localizedTitle
        let priceTitle = product.localizedPrice

        return "\(title) (\(priceTitle))"
    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel(ratingService: AppStoreRatingService()))
    }
}

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
