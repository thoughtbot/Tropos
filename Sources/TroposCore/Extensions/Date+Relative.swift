import Foundation

extension Date {
    static var yesterday: Date {
        return Calendar.current.date(byAdding: .init(day: -1), to: Date())!
    }
}
