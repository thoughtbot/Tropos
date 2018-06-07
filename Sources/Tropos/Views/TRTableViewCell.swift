import UIKit
import TroposCore

class TRTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel?.font = UIFont.defaultLightFont(size: 18.0)

        let highlightView = UIView()
        highlightView.backgroundColor = Color.cellSelection
        selectedBackgroundView = highlightView
    }
}
