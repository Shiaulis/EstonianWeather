//
//  ObservatrionListView.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 12.10.2020.
//

import SwiftUI

struct ObservationListView<ViewModel: ObservationListViewModel>: View {

    // MARK: - Properties

    @ObservedObject var viewModel: ViewModel

    // MARK: - Body

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(self.viewModel.displayItems) { displayItem in
                        ObservationView(displayItem: displayItem)
                    }
                }
            }
            .navigationBarTitle("observations")
            .navigationBarColor(backgroundColor: Resource.Color.appRose, tintColor: .white)
        }
    }

}

struct ObservationView: View {
    let displayItem: ObservationDisplayItem

    var body: some View {
        HStack {
            Text(self.displayItem.name)
            Spacer()
        }
    }
}

struct ObservatrionListView_Previews: PreviewProvider {
    static var previews: some View {
        ObservationListView(viewModel: MockObservationListViewModel())
    }
}
