//
//  Logger.swift
//  Data Matrix
//
//  Created by Alessandra Souza da Silva on 25/03/25.
//

import OSLog


enum LogCategory: String {
    case socket, calibration, uimodule, lifecycle, tracking
}

final class AppLogger {
    @MainActor static let shared = AppLogger()
    
    private let defaultSubsystem = Bundle.main.bundleIdentifier ?? "dev.novoselov.Data-Matrix"
    
    private init() {}

    func logger(for category: LogCategory) -> Logger {
        return Logger(subsystem: defaultSubsystem, category: category.rawValue.capitalized)
    }
}

