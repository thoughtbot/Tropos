enum SettingsTableViewControllerSegueIdentifier: String {
    case PrivacyPolicy = "ShowWebViewController"
    case Acknowledgements = "ShowTextViewController"
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

enum AboutSection: Int {
    case Thoughtbot
    case Forecast
}

class SettingsTableViewController: UITableViewController {
    @IBOutlet var thoughtbotImageView: UIImageView!
    private let settingsController = TRSettingsController()
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsController.unitSystemChanged.subscribeNext { unitSystem in
            if let system = TRUnitSystem(rawValue: unitSystem as! Int) {
                self.tableView.checkCellAtIndexPath(self.indexPathForUnitSystem(system))
            }
        }

        NSNotificationCenter.defaultCenter().rac_addObserverForName(UIApplicationWillEnterForegroundNotification, object: nil).subscribeNext { _ in
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }

        thoughtbotImageView.tintColor = .lightTextColor();
        thoughtbotImageView.image = thoughtbotImageView.image!.imageWithRenderingMode(.AlwaysTemplate)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.checkCellAtIndexPath(indexPathForUnitSystem(settingsController.unitSystem))
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = SettingsTableViewControllerSegueIdentifier(rawValue: segue.identifier ?? "") {
            switch identifier {
            case .PrivacyPolicy:
                let webViewController = segue.destinationViewController as? WebViewController
                webViewController?.URL = NSURL(string: "http://www.troposweather.com/privacy/")!
            case .Acknowledgements:
                let textViewController = segue.destinationViewController as? TextViewController
                let fileURL = NSBundle.mainBundle().URLForResource("Acknowledgements", withExtension: "plist")
                let parser = fileURL.flatMap { AcknowledgementsParser(fileURL: $0) }
                textViewController?.text = parser?.displayString()
            }
        }
    }

    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (Section.UnitSystem.rawValue, _):
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            tableView.uncheckCellsInSection(indexPath.section)
            selectUnitSystemAtIndexPath(indexPath)
        case (Section.About.rawValue, AboutSection.Thoughtbot.rawValue):
            UIApplication.sharedApplication().openURL(NSURL(string: "https://thoughtbot.com")!)
        case (Section.About.rawValue, AboutSection.Forecast.rawValue):
            UIApplication.sharedApplication().openURL(NSURL(string: "https://forecast.io")!)
        default: break
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel.font = .defaultLightFontOfSize(13)
            headerView.textLabel.textColor = .lightTextColor()
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Section.About.rawValue: return appVersionString()
        default: return super.tableView(tableView, titleForHeaderInSection: section)
        }
    }

    private func appVersionString() -> String {
        var string = "Tropos"

        let infoDictionary = NSBundle.mainBundle().infoDictionary as? [String: AnyObject]

        if let version = infoDictionary?["CFBundleShortVersionString"] as? String, buildNumber = infoDictionary?["CFBundleVersion"] as? String {
            string += " \(version) (\(buildNumber))"
        }

        return string.uppercaseString
    }
    
    // MARK: Private
    
    private func selectUnitSystemAtIndexPath(indexPath: NSIndexPath) {
        if let system = TRUnitSystem(rawValue: indexPath.row) {
            settingsController.unitSystem = system
        }
    }
    
    private func indexPathForUnitSystem(unitSystem: TRUnitSystem) -> NSIndexPath {
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
