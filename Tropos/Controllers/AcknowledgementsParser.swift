struct AcknowledgementsParser {
    let propertyList: [String: AnyObject]

    init?(fileURL: NSURL) {
        if let plist = NSDictionary(contentsOfURL: fileURL) as? [String: AnyObject] {
            propertyList = plist
        } else {
            return nil
        }
    }

    func displayString() -> String {
        let acknowledgements = propertyList["PreferenceSpecifiers"] as? [[String: String]] ?? []

        return acknowledgements.reduce("") { string, acknowledgement in
            return string + displayStringForAcknowledgement(acknowledgement)
        }
    }

    private func displayStringForAcknowledgement(acknowledgement: [String: String]) -> String {
        let appendNewline: String -> String = { "\($0)\n" }
        let title = acknowledgement["Title"].map(appendNewline) ?? ""
        let footer = acknowledgement["FooterText"].map(appendNewline) ?? ""
        return title + footer
    }
}
