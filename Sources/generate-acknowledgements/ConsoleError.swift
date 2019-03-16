import Foundation

public protocol ConsoleError: LocalizedError, CustomNSError {
    var filePath: String? { get }
    var fileURL: URL? { get }
}

extension Error {
    public var consoleDescription: String {
        let error = self as NSError
        var message: String

        if var path = error.userInfo[NSFilePathErrorKey] as? String {
            path.makeRelativePath()
            message = "\(path): \(error.localizedDescription)"
        } else {
            message = error.localizedDescription
        }

        if let failureReason = error.localizedFailureReason {
            message += " (\(failureReason))"
        }

        if let recoverySuggestion = error.localizedRecoverySuggestion {
            message += ": \(recoverySuggestion)"
        }

        message.applyTransform(.toLatinASCII)
        return message
    }
}

extension ConsoleError {
    public var filePath: String? {
        return nil
    }

    public var fileURL: String? {
        return nil
    }

    private var filePathFromURL: String? {
        return fileURL?.relativePath
    }

    public var errorUserInfo: [String: Any] {
        var userInfo: [String: Any] = [:]

        if let errorDescription = errorDescription {
            userInfo[NSLocalizedDescriptionKey] = errorDescription
        }

        if let failureReason = failureReason {
            userInfo[NSLocalizedFailureReasonErrorKey] = failureReason
        }

        if let recoverySuggestion = recoverySuggestion {
            userInfo[NSLocalizedRecoverySuggestionErrorKey] = recoverySuggestion
        }

        if let filePath = filePath ?? filePathFromURL {
            userInfo[NSFilePathErrorKey] = filePath
        }

        return userInfo
    }
}
