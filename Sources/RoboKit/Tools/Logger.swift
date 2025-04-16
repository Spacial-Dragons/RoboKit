import OSLog

enum LogLevel: Int {
    case debug = 0
    case info = 1
    case warning = 2
    case error = 3
    case fault = 4
    
    var osLogType: OSLogType {
        switch self {
        case .debug: return .debug
        case .info: return .info
        case .warning: return .default
        case .error: return .error
        case .fault: return .fault
        }
    }
    
    var stringValue: String {
        switch self {
        case .debug: return "DEBUG"
        case .info: return "INFO"
        case .warning: return "WARNING"
        case .error: return "ERROR"
        case .fault: return "FAULT"
        }
    }
}

enum LogCategory: String {
    case socket
    case calibration
    case uimodule
    case lifecycle
    case tracking

    var formatted: String {
        "[\(self.rawValue.capitalized)]"
    }
}

final class AppLogger {
    @MainActor static let shared = AppLogger()
    
    private let defaultSubsystem = Bundle.main.bundleIdentifier ?? "com.SpacialDragons.RoboKit"
    
    private init() {}

    func logger(for category: LogCategory) -> Logger {
        return Logger(subsystem: defaultSubsystem, category: category.rawValue.capitalized)
    }
}

extension AppLogger {
    func log(
        _ message: String,
        level: LogLevel,
        category: LogCategory,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        context: [String: Any]? = nil
    ) {
        let fileName = (file as NSString).lastPathComponent
        var logMessage = "[RoboKit] [\(level.stringValue)] [\(fileName):\(line)] [\(function)]"
        
        if let context = context {
            logMessage += " [Context: \(context)]"
        }
        
        logMessage += ": \(message)"
        
        logger(for: category).log(
            level: level.osLogType,
            "\(logMessage, privacy: .public)"
        )
    }
    
    func debug(
        _ message: String,
        category: LogCategory,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        context: [String: Any]? = nil
    ) {
        log(message, level: .debug, category: category, file: file, function: function, line: line, context: context)
    }

    func info(
        _ message: String,
        category: LogCategory,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        context: [String: Any]? = nil
    ) {
        log(message, level: .info, category: category, file: file, function: function, line: line, context: context)
    }
    func warning(
        _ message: String,
        category: LogCategory,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        context: [String: Any]? = nil
    ) {
        log(message, level: .warning, category: category, file: file, function: function, line: line, context: context)
    }

    func error(
        _ message: String,
        category: LogCategory,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        context: [String: Any]? = nil
    ) {
        log(message, level: .error, category: category, file: file, function: function, line: line, context: context)
    }

    func fault(
        _ message: String,
        category: LogCategory,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        context: [String: Any]? = nil
    ) {
        log(message, level: .fault, category: category, file: file, function: function, line: line, context: context)
    }
}
