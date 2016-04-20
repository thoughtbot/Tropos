import Foundation

struct RelativeDateFormatter {
    private let calendar: NSCalendar
    private let dateFormatter: NSDateFormatter

    init(calendar: NSCalendar = .currentCalendar()) {
        self.calendar = calendar
        self.dateFormatter = NSDateFormatter()
        self.dateFormatter.doesRelativeDateFormatting = true
    }

    func localizedStringFromDate(date: NSDate) -> String {
        let timeString = timeStringFromDate(date)

        if let dateString = dateStringFromDate(date) {
            let format = NSLocalizedString("UpdatedAtDateAndTime", comment: "")
            return NSString.localizedStringWithFormat(format, dateString, timeString) as String
        } else {
            let format = NSLocalizedString("UpdatedAtTime", comment: "")
            return NSString.localizedStringWithFormat(format, timeString) as String
        }
    }

    private func dateStringFromDate(date: NSDate) -> String? {
        let components = calendar.components([.Day, .Hour, .Minute, .Second], fromDate: date, toDate: NSDate(), options: [])
        guard components.day == 0 else { return nil }
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .NoStyle
        return dateFormatter.stringFromDate(date)
    }

    private func timeStringFromDate(date: NSDate) -> String {
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = .ShortStyle
        return dateFormatter.stringFromDate(date)
    }
}
