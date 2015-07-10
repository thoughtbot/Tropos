class TRTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel?.font = UIFont.defaultLightFontOfSize(18.0)

        let highlightView = UIView()
        highlightView.backgroundColor = Color.cellSelection
        selectedBackgroundView = highlightView
    }
}
