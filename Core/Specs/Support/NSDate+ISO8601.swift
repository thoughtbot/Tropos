import Foundation

extension Date {
    init?(iso8601String: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: iso8601String) else { return nil }
        let timeInterval = date.timeIntervalSince(Date(timeIntervalSince1970: 0))
        self.init(timeIntervalSince1970: timeInterval)
    }
}
