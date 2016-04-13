import Foundation

enum TimeOfDay {
    case Morning
    case Day
    case Afternoon
    case Night
}

extension NSCalendar {
    func timeOfDay(forDate date: NSDate) -> TimeOfDay {
        let components = self.components(.Hour, fromDate: date)

        if components.hour < 4 {
            return .Night
        } else if components.hour < 9 {
            return .Morning
        } else if components.hour < 14 {
            return .Day
        } else if components.hour < 17 {
            return .Afternoon
        } else {
            return .Night
        }
    }

    func localizedTimeOfDay(forDate date: NSDate) -> String {
        switch timeOfDay(forDate: date) {
        case .Night:
            return NSLocalizedString("Tonight", comment: "")
        case .Morning:
            return NSLocalizedString("ThisMorning", comment: "")
        case .Day:
            return NSLocalizedString("Today", comment: "")
        case .Afternoon:
            return NSLocalizedString("ThisAfternoon", comment: "")
        }
    }

    func localizedTimeOfYesterday(relativeToDate date: NSDate) -> String {
        switch timeOfDay(forDate: date) {
        case .Night:
            return NSLocalizedString("LastNight", comment: "")
        case .Morning:
            return NSLocalizedString("YesterdayMorning", comment: "")
        case .Day:
            return NSLocalizedString("Yesterday", comment: "")
        case .Afternoon:
            return NSLocalizedString("YesterdayAfternoon", comment: "")
        }
    }
}
