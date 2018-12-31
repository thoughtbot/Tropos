import UIKit
import TroposCore

@objc(TRDailyForecastView) public class DailyForecastView: UIView {
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    @IBOutlet weak var highTemperatureLabel: UILabel!
    @IBOutlet weak var lowTemperatureLabel: UILabel!
    @IBOutlet weak var conditionsImageView: UIImageView!
    @IBOutlet var contentView: DailyForecastView!
    @objc public var viewModel: DailyForecastViewModel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        let mainBundle = Bundle.main
        mainBundle.loadNibNamed(String(describing: "TRDailyForecastView"), owner: self, options: nil)
        addSubview(contentView)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
    }

    func setViewModel(dailyForecastViewModel: DailyForecastViewModel) {
        viewModel = dailyForecastViewModel
        dayOfWeekLabel.text = dailyForecastViewModel.dayOfWeek
        conditionsImageView.image = dailyForecastViewModel.conditionsImage
        highTemperatureLabel.text = dailyForecastViewModel.highTemperature
        lowTemperatureLabel.text = dailyForecastViewModel.lowTemperature
    }
}
