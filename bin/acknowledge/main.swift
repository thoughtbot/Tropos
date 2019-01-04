import Foundation
import Settings

enum AcknowledgeError: Error, LocalizedError {
    case missingCarthageCheckouts
    case settingsBundleInvalid(URL)
    case settingsBundleNotFound

    var errorDescription: String? {
        switch self {
        case .missingCarthageCheckouts:
            return "Unable to locate Carthage checkouts. Run 'carthage checkout' and try again."
        case let .settingsBundleInvalid(url):
            return "Invalid settings bundle at path: \(url.relativePath)"
        case .settingsBundleNotFound:
            return "Unable to locate Settings.bundle."
        }
    }
}

extension FileManager.DirectoryEnumerator {
    func nextFileURL(relativeTo url: URL) -> URL? {
        return nextObject().map { path in
            url.appendingPathComponent(path as! String)
        }
    }
}

extension String {
    func hasPrefix(_ prefix: String, options: CompareOptions) -> Bool {
        return range(of: prefix, options: options.union(.anchored)) != nil
    }
}

func findSettingsBundle() throws -> URL {
    let tropos = URL(fileURLWithPath: "Sources/Tropos")
    let enumerator = FileManager.default.enumerator(atPath: tropos.path)!

    while let file = enumerator.nextFileURL(relativeTo: tropos) {
        if file.lastPathComponent == "Settings.bundle" {
            if Bundle(url: file) != nil {
                return file
            } else {
                throw AcknowledgeError.settingsBundleInvalid(file)
            }
        }
    }

    throw AcknowledgeError.settingsBundleNotFound
}

func findLicenses(_ foundLicense: (_ library: String, _ license: URL) throws -> Void) throws {
    let carthage = URL(fileURLWithPath: "Carthage/Checkouts")

    guard let enumerator = FileManager.default.enumerator(atPath: carthage.path) else {
        throw AcknowledgeError.missingCarthageCheckouts
    }

    var currentLibrary: String?
    var currentLicense: URL?

    while let file = enumerator.nextFileURL(relativeTo: carthage) {
        switch enumerator.level {
        case 1:
            if let currentLibrary = currentLibrary, let currentLicense = currentLicense {
                try foundLicense(currentLibrary, currentLicense)
            }

            currentLibrary = file.lastPathComponent
            currentLicense = nil

        case 2:
            if file.lastPathComponent.hasPrefix("license", options: .caseInsensitive) {
                currentLicense = file
            }

        default:
            enumerator.skipDescendents()
        }
    }
}

func main() throws {
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .xml
    let fileManager = FileManager.default

    let settings = try findSettingsBundle()
    let acknowledgementsDir = settings.appendingPathComponent("Acknowledgements")
    let acknowledgementsFile = acknowledgementsDir.appendingPathExtension("plist")

    try fileManager.removeItem(at: acknowledgementsDir)
    try fileManager.createDirectory(at: acknowledgementsDir, withIntermediateDirectories: true)

    var acknowledgementsPage = PreferencePage()

    try findLicenses { library, license in
        var childSpecifier = PreferenceSpecifier(type: "PSChildPaneSpecifier")
        childSpecifier.file = "Acknowledgements/\(library)"
        childSpecifier.title = library
        acknowledgementsPage.preferenceSpecifiers.append(childSpecifier)

        var acknowledgements = PreferenceSpecifier(type: "PSGroupSpecifier")
        acknowledgements.footerText = try String(contentsOf: license)

        let libraryPage = PreferencePage(preferenceSpecifiers: [acknowledgements])
        let libraryURL = acknowledgementsDir.appendingPathComponent("\(library).plist", isDirectory: false)
        print("Writing \(libraryURL.relativePath)")
        try fileManager.createFile(atPath: libraryURL.path, contents: encoder.encode(libraryPage))
    }

    print("Writing \(acknowledgementsFile.relativePath)")
    try fileManager.createFile(atPath: acknowledgementsFile.path, contents: encoder.encode(acknowledgementsPage))
}

do {
    try main()
} catch {
    fputs("error: \(error.localizedDescription)\n", stderr)
    exit(1)
}
