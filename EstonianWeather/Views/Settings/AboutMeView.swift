//
//  AboutMeView.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 22.11.2020.
//

import SwiftUI

struct AboutMeView: View {
    var body: some View {
        ScrollView {
            VStack {
                HStack(spacing: 64) {
                    Spacer()
                    Image("shiaulis")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .shadow(radius: 10)
                        .frame(maxWidth: 400)
                        .padding()
                    Spacer()
                }
                Text("about_me_text")
                    .padding()
                ContactMeButton()
                Spacer()
            }
        }
        .navigationBarTitle("about_me_title")
    }
}

private struct ContactMeButton: View {

    var body: some View {
        Button(action: buttonAction) {
            Text("contact_me")
        }
    }

    private func buttonAction() {
        UIApplication.shared.open(Resource.URL.email)
    }
}

struct AboutMeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AboutMeView()
                .navigationTitle("about_me")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
