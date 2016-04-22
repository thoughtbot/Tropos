import Foundation

public enum TimeOfDay {
    case Morning
    case Day
    case Afternoon
    case Night
}

public extension NSCalendar {
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
            return TroposCoreLocalizedString("Tonight")
        case .Morning:
            return TroposCoreLocalizedString("ThisMorning")
        case .Day:
            return TroposCoreLocalizedString("Today")
        case .Afternoon:
            return TroposCoreLocalizedString("ThisAfternoon")
        }
    }

    func localizedTimeOfYesterday(relativeToDate date: NSDate) -> String {
        switch timeOfDay(forDate: date) {
        case .Night:
            return TroposCoreLocalizedString("LastNight")
        case .Morning:
            return TroposCoreLocalizedString("YesterdayMorning")
        case .Day:
            return TroposCoreLocalizedString("Yesterday")
        case .Afternoon:
            return TroposCoreLocalizedString("YesterdayAfternoon")
        }
    }
}
