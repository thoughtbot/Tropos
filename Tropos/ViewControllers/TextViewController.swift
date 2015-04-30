class TextViewController: UIViewController {
    @IBOutlet var textView: UITextView!

    var text: String?

    // MARK: UIViewController

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textView.text = text
        textView.contentOffset = CGPointZero
        textView.font = .defaultRegularFontOfSize(14)
        textView.textColor = .lightTextColor()
    }
}
