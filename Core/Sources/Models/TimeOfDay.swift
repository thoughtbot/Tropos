import Foundation

public enum TimeOfDay {
    case morning
    case day
    case afternoon
    case night
}

public extension Calendar {
    func timeOfDay(forDate date: Date) -> TimeOfDay {
        let components = self.dateComponents([.hour], from: date)

        if components.hour! < 4 {
            return .night
        } else if components.hour! < 9 {
            return .morning
        } else if components.hour! < 14 {
            return .day
        } else if components.hour! < 17 {
            return .afternoon
        } else {
            return .night
        }
    }

    func localizedTimeOfDay(forDate date: Date) -> String {
        switch timeOfDay(forDate: date) {
        case .night:
            return TroposCoreLocalizedString("Tonight")
        case .morning:
            return TroposCoreLocalizedString("ThisMorning")
        case .day:
            return TroposCoreLocalizedString("Today")
        case .afternoon:
            return TroposCoreLocalizedString("ThisAfternoon")
        }
    }

    func localizedTimeOfYesterday(relativeToDate date: Date) -> String {
        switch timeOfDay(forDate: date) {
        case .night:
            return TroposCoreLocalizedString("LastNight")
        case .morning:
            return TroposCoreLocalizedString("YesterdayMorning")
        case .day:
            return TroposCoreLocalizedString("Yesterday")
        case .afternoon:
            return TroposCoreLocalizedString("YesterdayAfternoon")
        }
    }
}
