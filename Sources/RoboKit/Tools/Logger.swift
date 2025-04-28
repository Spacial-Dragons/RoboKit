import OSLog

/// Represents different levels of logging severity.
/// Each level corresponds to a specific OSLogType and has a numeric value for comparison.
enum LogLevel: Int {
    /// Debug level logs - used for detailed information during development
    case debug = 0
    /// Info level logs - used for general information about application flow
    case info = 1
    /// Warning level logs - used for potentially harmful situations
    case warning = 2
    /// Error level logs - used for error events that might still allow the application to continue running
    case error = 3
    /// Fault level logs - used for critical errors that should be investigated immediately
    case fault = 4

    /// Maps the LogLevel to the corresponding OSLogType
    var osLogType: OSLogType {
        switch self {
        case .debug: return .debug
        case .info: return .info
        case .warning: return .default
        case .error: return .error
        case .fault: return .fault
        }
    }

    /// Returns a string representation of the log level
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

/// Represents different categories of logging within the application.
/// Each category helps organize and filter logs based on their source or purpose.
enum LogCategory: String {
    /// Logs related to socket connections and network communication
    case socket
    /// Logs related to device calibration processes
    case calibration
    /// Logs related to UI components and user interactions
    case uimodule
    /// Logs related to application lifecycle events
    case lifecycle
    /// Logs related to tracking and monitoring operations
    case tracking

    /// Returns a formatted string representation of the category
    var formatted: String {
        "[\(self.rawValue.capitalized)]"
    }
}

/// A centralized logging system for the application using Apple's OSLog framework.
/// This class provides a singleton instance for consistent logging across the application.
/// It supports different log levels and categories for better organization and filtering.
final class AppLogger {
    /// The shared singleton instance of the logger.
    /// This instance is accessible from anywhere in the application.
    @MainActor static let shared = AppLogger()

    /// The default subsystem identifier for the logger.
    /// Uses the application's bundle identifier or a fallback value.
    private let defaultSubsystem = Bundle.main.bundleIdentifier ?? "com.SpacialDragons.RoboKit"

    /// Private initializer to enforce singleton pattern
    private init() {}

    /// Creates and returns a Logger instance for the specified category.
    /// - Parameter category: The LogCategory for which to create the logger
    /// - Returns: A configured Logger instance
    func logger(for category: LogCategory) -> Logger {
        return Logger(subsystem: defaultSubsystem, category: category.rawValue.capitalized)
    }
}

extension AppLogger {
    /// Central logging method that handles all log messages.
    /// - Parameters:
    ///   - message: The message to log
    ///   - level: The severity level of the log
    ///   - category: The category of the log
    ///   - file: The source file where the log is called (automatically captured)
    ///   - function: The name of the function where the log is called (automatically captured)
    ///   - line: The line number where the log is called (automatically captured)
    ///   - context: Optional additional context information to include in the log
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

    /// Logs a debug message with the specified category and function information.
    /// - Parameters:
    ///   - message: The message to log
    ///   - category: The category of the log
    ///   - file: The source file where the log is called (automatically captured)
    ///   - function: The name of the function where the log is called (automatically captured)
    ///   - line: The line number where the log is called (automatically captured)
    ///   - context: Optional additional context information to include in the log
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

    /// Logs an informational message with the specified category and function information.
    /// - Parameters:
    ///   - message: The message to log
    ///   - category: The category of the log
    ///   - file: The source file where the log is called (automatically captured)
    ///   - function: The name of the function where the log is called (automatically captured)
    ///   - line: The line number where the log is called (automatically captured)
    ///   - context: Optional additional context information to include in the log
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

    /// Logs a warning message with the specified category and function information.
    /// - Parameters:
    ///   - message: The message to log
    ///   - category: The category of the log
    ///   - file: The source file where the log is called (automatically captured)
    ///   - function: The name of the function where the log is called (automatically captured)
    ///   - line: The line number where the log is called (automatically captured)
    ///   - context: Optional additional context information to include in the log
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

    /// Logs an error message with the specified category and function information.
    /// - Parameters:
    ///   - message: The message to log
    ///   - category: The category of the log
    ///   - file: The source file where the log is called (automatically captured)
    ///   - function: The name of the function where the log is called (automatically captured)
    ///   - line: The line number where the log is called (automatically captured)
    ///   - context: Optional additional context information to include in the log
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

    /// Logs a fault message with the specified category and function information.
    /// Faults are critical errors that should be investigated immediately.
    /// - Parameters:
    ///   - message: The message to log
    ///   - category: The category of the log
    ///   - file: The source file where the log is called (automatically captured)
    ///   - function: The name of the function where the log is called (automatically captured)
    ///   - line: The line number where the log is called (automatically captured)
    ///   - context: Optional additional context information to include in the log
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
