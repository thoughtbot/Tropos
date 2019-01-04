import os.log
import Settings
import UIKit

final class AcknowledgementsViewController: UITableViewController {
    private var acknowledgements = PreferencePage()
    private var settings = Bundle.main.settingsBundle!

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            acknowledgements = try loadAcknowledgementsList()
        } catch {
            guard #available(iOS 10.0, *) else { return }
            os_log("Failed to load acknowledgements: %{public}@", type: .error, error.localizedDescription)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return acknowledgements.preferenceSpecifiers.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("Third-Party Code", comment: "Title for Acknowledgements library list")
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let library = acknowledgements.preferenceSpecifiers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Library", for: indexPath)
        cell.textLabel?.text = library.title
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        defer { super.prepare(for: segue, sender: sender) }

        guard let destination = segue.destination as? TextViewController,
            let indexPath = (sender as? UITableViewCell).flatMap(tableView.indexPath(for:))
        else { return }

        let library = acknowledgements.preferenceSpecifiers[indexPath.row]
        destination.title = library.title

        do {
            let libraryAcknowledgements = try loadAcknowledgements(forLibraryNamed: library.title.unwrap())
            destination.text = libraryAcknowledgements.footerText
        } catch {
            guard #available(iOS 10.0, *) else { return }

            os_log(
                "Failed to load acknowledgements for library '%{public}@': %{public}@",
                type: .error,
                library.title ?? "nil",
                error.localizedDescription
            )
        }
    }
}

private extension AcknowledgementsViewController {
    func loadAcknowledgementsList() throws -> PreferencePage {
        return try settings
            .url(forResource: "Acknowledgements", withExtension: "plist")
            .map { try Data(contentsOf: $0) }
            .map { try PropertyListDecoder().decode(PreferencePage.self, from: $0) }
            .unwrap()
    }

    func loadAcknowledgements(forLibraryNamed libraryName: String) throws -> PreferenceSpecifier {
        let page = try settings
            .url(forResource: libraryName, withExtension: "plist", subdirectory: "Acknowledgements")
            .map { try Data(contentsOf: $0) }
            .map { try PropertyListDecoder().decode(PreferencePage.self, from: $0) }
            .unwrap()

        return try page.preferenceSpecifiers.first.unwrap()
    }
}
