import TroposCore
import UIKit

private enum SegueIdentifier: String {
    case privacyPolicy = "ShowWebViewController"
    case acknowledgements = "ShowAcknowledgementsViewController"

    init?(identifier: String?) {
        guard let identifier = identifier else { return nil }
        self.init(rawValue: identifier)
    }
}

enum Section: Int {
    case unitSystem
    case info
    case about
}

enum UnitSystemSection: Int {
    case metric
    case imperial
}

enum InfoSection: Int {
    case privacyPolicy
    case acknowledgements
    case forecast
}

enum AboutSection: Int {
    case thoughtbot
}

class SettingsTableViewController: UITableViewController {
    @IBOutlet var thoughtbotImageView: UIImageView!
    private var resignActiveObservation: Any?
    private let settingsController = SettingsController()

    override func viewDidLoad() {
        super.viewDidLoad()

        settingsController.unitSystemChanged = { [weak self] unitSystem in
            guard let indexPath = self?.indexPathForUnitSystem(unitSystem) else { return }
            self?.tableView.checkCellAtIndexPath(indexPath)
        }

        thoughtbotImageView.tintColor = .lightText
        thoughtbotImageView.image = thoughtbotImageView.image?.withRenderingMode(
            .alwaysTemplate
        )

        resignActiveObservation = NotificationCenter.default.addObserver(
            forName: .UIApplicationWillResignActive,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            guard let selectedIndexPath = self?.tableView.indexPathForSelectedRow else { return }
            self?.tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }

    deinit {
        if let resignActiveObservation = resignActiveObservation {
            NotificationCenter.default.removeObserver(resignActiveObservation)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.checkCellAtIndexPath(indexPathForUnitSystem(settingsController.unitSystem))
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch SegueIdentifier(identifier: segue.identifier) {
        case .privacyPolicy?:
            let webViewController = segue.destination as? WebViewController
            webViewController?.url = URL(string: "http://www.troposweather.com/privacy/")!
        default:
            break
        }
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt
        indexPath: IndexPath
    ) {
        switch (indexPath.section, indexPath.row) {
        case (Section.unitSystem.rawValue, _):
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.uncheckCellsInSection(indexPath.section)
            selectUnitSystemAtIndexPath(indexPath)
        case (Section.info.rawValue, InfoSection.forecast.rawValue):
            UIApplication.shared.openURL(URL(string: "https://forecast.io")!)
        case (Section.about.rawValue, AboutSection.thoughtbot.rawValue):
            UIApplication.shared.openURL(URL(string: "https://thoughtbot.com")!)
        default: break
        }
    }

    override func tableView(
        _ tableView: UITableView,
        willDisplayHeaderView view: UIView,
        forSection section: Int
    ) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.font = .defaultLightFont(size: 13)
            headerView.textLabel?.textColor = .lightText
        }
    }

    override func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        switch section {
        case Section.about.rawValue: return appVersionString()
        default: return super.tableView(tableView, titleForHeaderInSection: section)
        }
    }

    private func appVersionString() -> String? {
        let bundle = Bundle.main
        guard let infoDictionary = bundle.infoDictionary as? [String: String] else {
            return .none
        }

        guard let version = infoDictionary["CFBundleShortVersionString"] else { return .none }
        guard let buildNumber = infoDictionary["CFBundleVersion"] else { return .none }

        return "Tropos \(version) (\(buildNumber))".uppercased()
    }

    private func selectUnitSystemAtIndexPath(_ indexPath: IndexPath) {
        if let system = UnitSystem(rawValue: indexPath.row) {
            settingsController.unitSystem = system
        }
    }

    private func indexPathForUnitSystem(_ unitSystem: UnitSystem) -> IndexPath {
        return IndexPath(row: unitSystem.rawValue, section: 0)
    }
}

extension UITableView {
    @objc func checkCellAtIndexPath(_ indexPath: IndexPath) {
        cellForRow(at: indexPath)?.accessoryType = .checkmark
    }

    @objc func uncheckCellsInSection(_ section: Int) {
        for index in 0 ..< numberOfRows(inSection: section) {
            let indexPath = IndexPath(row: index, section: section)
            cellForRow(at: indexPath)?.accessoryType = .none
        }
    }
}
