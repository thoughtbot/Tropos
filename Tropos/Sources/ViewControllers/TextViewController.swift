import UIKit

class TextViewController: UIViewController {
    @IBOutlet var textView: UITextView!

    var text: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.contentInset = UIEdgeInsetsZero
        textView.textContainerInset = UIEdgeInsets(
            top: 20.0,
            left: 20.0,
            bottom: 20.0,
            right: 20.0
        )
        textView.font = UIFont.defaultRegularFont(size: 14)
        textView.textColor = .lightTextColor()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textView.text = text
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.contentOffset = .zero
    }
}
