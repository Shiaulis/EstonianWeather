//
//  Logger.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 28.09.2020.
//

import Foundation

public enum LoggerModule {
    case dataParser, mainViewModel, dataMapper, ratingService, purchases

    fileprivate var name: String {
        switch self {
        case .dataParser: return "🔎 Data Parser"
        case .mainViewModel: return "🧑‍🔧 Main View Model"
        case .dataMapper: return "💿 Data Mapper"
        case .ratingService: return "✨ Rating Service"
        case .purchases: return "💰 Purchases"
        }
    }
}

public protocol Logger {

    func log(message: String, error: Error, module: LoggerModule)
    func logNotImplemented(functionality: String, module: LoggerModule)
    func log(information: String, module: LoggerModule)
    func log(successState: String, module: LoggerModule)

}

public final class PrintLogger {

    public init() {}

    private var currentDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = .current
        return dateFormatter.string(from: Date())
    }

    private func log(_ string: String) {
        print("\(self.currentDate): \(string)")
    }
}

extension PrintLogger: Logger {

    public func log(message: String, error: Error, module: LoggerModule) {
        log("❌ \(module.name): \(message) Error: \(error.localizedDescription)")
        assertionFailure()
    }

    public func logNotImplemented(functionality: String, module: LoggerModule) {
        log("🚧 \(module.name): \(functionality) not implemented yet")
    }

    public func log(information: String, module: LoggerModule) {
        log("ℹ️ \(module.name): \(information)")
    }

    public func log(successState: String, module: LoggerModule) {
        log("✅ \(module.name): \(successState)")
    }

}
