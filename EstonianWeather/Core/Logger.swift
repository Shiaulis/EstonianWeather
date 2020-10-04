//
//  Logger.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 28.09.2020.
//

import Foundation

enum LoggerModule {
    case dataParser, mainService, dataMapper

    fileprivate var name: String {
        switch self {
        case .dataParser: return "🔎 Data Parser"
        case .mainService: return "🧑‍🔧 Main Service"
        case .dataMapper: return "💿 Data Mapper"
        }
    }
}

protocol Logger {

    func log(message: String, error: Error, module: LoggerModule)
    func logNotImplemented(functionality: String, module: LoggerModule)
    func log(information: String, module: LoggerModule)
    func log(successState: String, module: LoggerModule)

}

final class PrintLogger {

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

    func log(message: String, error: Error, module: LoggerModule) {
        log("❌ \(module.name): \(message) Error: \(error.localizedDescription)")
        assertionFailure()
    }

    func logNotImplemented(functionality: String, module: LoggerModule) {
        log("🚧 \(module.name): \(functionality) not implemented yet")
    }

    func log(information: String, module: LoggerModule) {
        log("ℹ️ \(module.name): \(information)")
    }

    func log(successState: String, module: LoggerModule) {
        log("✅ \(module.name): \(successState)")
    }

}
