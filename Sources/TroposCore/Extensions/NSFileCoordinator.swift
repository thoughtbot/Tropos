import Foundation

extension NSFileCoordinator {
    func coordinateReadingItem<Result>(at url: URL, byAccessor accessor: (URL) throws -> Result) throws -> Result {
        var accessorError: Error?
        var nsError: NSError?
        var result: Result?
        coordinate(readingItemAt: url, error: &nsError) { url in
            do {
                result = try accessor(url)
            } catch {
                accessorError = error
            }
        }

        switch (nsError as Error?, accessorError, result) {
        case let (error?, nil, nil),
             let (nil, error?, nil):
            throw error
        case let (nil, nil, result?):
            return result
        default:
            fatalError("expected either an error or result")
        }
    }
}
