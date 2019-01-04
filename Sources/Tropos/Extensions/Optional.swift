extension Optional {
    func unwrap(file: StaticString = #file, line: UInt = #line) throws -> Wrapped {
        if let value = self {
            return value
        } else {
            throw NilError(file: file, line: line)
        }
    }
}
