import UIKit
import TroposCore

enum SettingsTableViewControllerSegueIdentifier: String {
    case PrivacyPolicy = "ShowWebViewController"
    case Acknowledgements = "ShowTextViewController"

    init?(identifier: String?) {
      guard let identifier = identifier else { return nil }
      self.init(rawValue: identifier)
    }
}

enum Section: Int {
    case UnitSystem
    case Info
    case About
}

enum UnitSystemSection: Int {
    case Metric
    case Imperial
}

enum InfoSection: Int {
    case PrivacyPolicy
    case Acknowledgements
    case Forecast
}

enum AboutSection: Int {
    case Thoughtbot
}

class SettingsTableViewController: UITableViewController {
    @IBOutlet var thoughtbotImageView: UIImageView!
    private let settingsController = SettingsController()

    override func viewDidLoad() {
        super.viewDidLoad()

      settingsController.unitSystemChanged = { [weak self] unitSystem in
          guard let indexPath = self?.indexPathForUnitSystem(unitSystem) else { return }
          self?.tableView.checkCellAtIndexPath(indexPath)
        }

        thoughtbotImageView.tintColor = .lightTextColor()
        thoughtbotImageView.image = thoughtbotImageView.image?.imageWithRenderingMode(
          .AlwaysTemplate
        )

        NSNotificationCenter.defaultCenter().addObserverForName(
          UIApplicationWillResignActiveNotification,
          object: .None,
          queue: .None
        ) { [weak self] _ in
          guard let selectedIndexPath = self?.tableView.indexPathForSelectedRow else { return }
          self?.tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.checkCellAtIndexPath(indexPathForUnitSystem(settingsController.unitSystem))
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch SettingsTableViewControllerSegueIdentifier(identifier: segue.identifier) {
          case .PrivacyPolicy?:
              let webViewController = segue.destinationViewController as? WebViewController
              webViewController?.URL = NSURL(string: "http://www.troposweather.com/privacy/")!
          case .Acknowledgements?:
              let textViewController = segue.destinationViewController as? TextViewController
              let fileURL = NSBundle.mainBundle().URLForResource(
                "Pods-Tropos-settings-metadata",
                withExtension: "plist"
              )
              let parser = fileURL.flatMap { AcknowledgementsParser(fileURL: $0) }
              textViewController?.text = parser?.displayString()
        case nil:
          break
        }
    }

    override func tableView(
      tableView: UITableView,
      didSelectRowAtIndexPath
      indexPath: NSIndexPath
    ) {
        switch (indexPath.section, indexPath.row) {
        case (Section.UnitSystem.rawValue, _):
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            tableView.uncheckCellsInSection(indexPath.section)
            selectUnitSystemAtIndexPath(indexPath)
        case (Section.Info.rawValue, InfoSection.Forecast.rawValue):
            UIApplication.sharedApplication().openURL(NSURL(string: "https://forecast.io")!)
        case (Section.About.rawValue, AboutSection.Thoughtbot.rawValue):
            UIApplication.sharedApplication().openURL(NSURL(string: "https://thoughtbot.com")!)
        default: break
        }
    }

    override func tableView(
      tableView: UITableView,
      willDisplayHeaderView view: UIView,
      forSection section: Int
    ) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.font = .defaultLightFont(size: 13)
            headerView.textLabel?.textColor = .lightTextColor()
        }
    }

    override func tableView(
      tableView: UITableView,
      titleForHeaderInSection section: Int
    ) -> String? {
        switch section {
        case Section.About.rawValue: return appVersionString()
        default: return super.tableView(tableView, titleForHeaderInSection: section)
        }
    }

    private func appVersionString() -> String? {
        let bundle = NSBundle.mainBundle()
        guard let infoDictionary = bundle.infoDictionary as? [String: String] else {
          return .None
        }

        guard let version = infoDictionary["CFBundleShortVersionString"] else { return .None }
        guard let buildNumber = infoDictionary["CFBundleVersion"] else { return .None }

        return "Tropos \(version) (\(buildNumber))".uppercaseString

    }

    private func selectUnitSystemAtIndexPath(indexPath: NSIndexPath) {
        if let system = UnitSystem(rawValue: indexPath.row) {
            settingsController.unitSystem = system
        }
    }

    private func indexPathForUnitSystem(unitSystem: UnitSystem) -> NSIndexPath {
        return NSIndexPath(forRow: unitSystem.rawValue, inSection: 0)
    }
}

extension UITableView {
    func checkCellAtIndexPath(indexPath: NSIndexPath) {
        cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
    }

    func uncheckCellsInSection(section: Int) {
        for index in 0 ..< numberOfRowsInSection(section) {
            let indexPath = NSIndexPath(forRow: index, inSection: section)
            cellForRowAtIndexPath(indexPath)?.accessoryType = .None
        }
    }
}
