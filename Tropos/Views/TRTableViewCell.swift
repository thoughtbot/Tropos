class TRTableViewCell: UITableViewCell {
  override func awakeFromNib() {
    super.awakeFromNib()
    textLabel?.font = UIFont.defaultLightFontOfSize(18.0)
  }
}
