import Foundation

struct AcknowledgementsParser {
    let propertyList: [String: Any]

    init?(fileURL: URL) {
        if let plist = NSDictionary(contentsOf: fileURL) as? [String: Any] {
            self.propertyList = plist
        } else {
            return nil
        }
    }

    func displayString() -> String {
        let acknowledgements = propertyList["PreferenceSpecifiers"] as? [[String: String]] ?? []

        return acknowledgements.reduce("") { string, acknowledgement in
            string + displayStringForAcknowledgement(acknowledgement)
        }
    }

    private func displayStringForAcknowledgement(_ acknowledgement: [String: String]) -> String {
        let appendNewline: (String) -> String = { "\($0)\n" }
        let title = acknowledgement["Title"].map(appendNewline) ?? ""
        let footer = acknowledgement["FooterText"].map(appendNewline) ?? ""
        return title + footer
    }
}
