import func Foundation.NSLocalizedString

func TroposCoreLocalizedString(_ string: String, comment: String = "") -> String {
    return NSLocalizedString(string, bundle: .troposBundle, comment: comment)
}
