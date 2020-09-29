//
//  LanguageCell.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 22.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import SwiftUI

struct LanguageCell: View {

    let currentLanguage: String
    let didSelected: () -> Void

    var body: some View {
        Button(action: self.didSelected) {
            HStack {
                Text("Current language")
                    .foregroundColor(Color(.label))
                Spacer()
                Text(self.currentLanguage)
                    .foregroundColor(Color(.secondaryLabel))
            }
        }
    }
}

struct LanguageCell_Previews: PreviewProvider {
    static var previews: some View {
        LanguageCell(currentLanguage: "English", didSelected: {})
        .previewLayout(.fixed(width: 414, height: 44))

    }
}
