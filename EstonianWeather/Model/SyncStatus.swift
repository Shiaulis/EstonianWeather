//
//  SyncStatus.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 23.12.2020.
//

import Foundation

enum SyncStatus {
    case ready
    case syncing
    case synced(Date)
    case failed(String)
}
