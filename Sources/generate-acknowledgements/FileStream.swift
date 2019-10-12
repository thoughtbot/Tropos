import Foundation

public var standardOutput = FileStream(file: stdout)
public var standardError = FileStream(file: stderr)

public struct FileStream: TextOutputStream {
    var file: UnsafeMutablePointer<FILE>

    public mutating func write(_ string: String) {
        fputs(string, file)
    }
}
