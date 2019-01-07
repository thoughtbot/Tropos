import UIKit
import TroposCore

@objc(TRDailyForecastView) public class DailyForecastView: UIView {
    @IBOutlet var dayOfWeekLabel: UILabel!
    @IBOutlet var highTemperatureLabel: UILabel!
    @IBOutlet var lowTemperatureLabel: UILabel!
    @IBOutlet var conditionsImageView: UIImageView!
    @IBOutlet var contentView: DailyForecastView!
    @objc public var viewModel: DailyForecastViewModel? {
        didSet {
            dayOfWeekLabel.text = viewModel?.dayOfWeek
            conditionsImageView.image = viewModel?.conditionsImage
            highTemperatureLabel.text = viewModel?.highTemperature
            lowTemperatureLabel.text = viewModel?.lowTemperature
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        let mainBundle = Bundle.main
        mainBundle.loadNibNamed("TRDailyForecastView", owner: self)
        addSubview(contentView)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
    }
}
