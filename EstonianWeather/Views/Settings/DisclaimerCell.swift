//
//  DisclaimerCell.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 21.11.2020.
//

import SwiftUI

struct DisclaimerCell: View {

    let disclaimerText: String
    let url: URL
    let urlDescription: String

    var body: some View {
        VStack {
            Text(self.disclaimerText)
                .multilineTextAlignment(.center)
            Spacer()
            URLButton(url: self.url, urlDescription: self.urlDescription)
        }
        .font(.caption)
    }
}

private struct URLButton: View {
    let url: URL
    let urlDescription: String

    var body: some View {
        Button(action: buttonAction) {
            Text(self.urlDescription)
        }
    }

    private func buttonAction() {
        UIApplication.shared.open(self.url)
    }
}

struct DisclaimerCell_Previews: PreviewProvider {
    static var previews: some View {
        DisclaimerCell(
            disclaimerText: "Информация о погоде предоставлена Национальной Службой Погоды Эстонии",
            url: Resource.URL.disclaimerURL(for: .russian),
            urlDescription: "https://ilmateenindus.com")
            .previewLayout(.fixed(width: 414, height: 88))

    }
}
