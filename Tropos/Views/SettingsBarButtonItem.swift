class SettingsBarButtonItem: UIBarButtonItem {
    
    // MARK: - NSObject+UIKit
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let button = UIButton(frame: CGRect(origin: .zeroPoint, size: CGSize(width: 30, height: 30)))
        button.setBackgroundImage(UIImage(named: "settings"), forState: .Normal)
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        customView = button
    }
}
