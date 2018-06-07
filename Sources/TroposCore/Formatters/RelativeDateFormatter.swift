import Foundation

public struct RelativeDateFormatter {
    private let calendar: Calendar
    private let dateFormatter: DateFormatter

    public init(calendar: Calendar = .current) {
        self.calendar = calendar
        self.dateFormatter = DateFormatter()
        self.dateFormatter.doesRelativeDateFormatting = true
    }

    public func localizedStringFromDate(_ date: Date) -> String {
        let timeString = timeStringFromDate(date)

        if let dateString = dateStringFromDate(date) {
            let format = TroposCoreLocalizedString("UpdatedAtDateAndTime")
            return String.localizedStringWithFormat(format, dateString, timeString)
        } else {
            let format = TroposCoreLocalizedString("UpdatedAtTime")
            return String.localizedStringWithFormat(format, timeString)
        }
    }

    private func dateStringFromDate(_ date: Date) -> String? {
        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: date, to: Date())
        guard components.day == 0 else { return nil }
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }

    private func timeStringFromDate(_ date: Date) -> String {
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}
