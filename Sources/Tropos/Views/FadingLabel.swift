import UIKit

private let textKey = #selector(setter: UILabel.text).description
private let attributedTextKey = #selector(setter: UILabel.attributedText).description

class FadingLabel: UILabel {
    override var text: String? {
        didSet {
            layer.setValue(text, forKey: textKey)
        }
    }

    override var attributedText: NSAttributedString? {
        didSet {
            layer.setValue(attributedText, forKey: attributedTextKey)
        }
    }

    override func action(for layer: CALayer, forKey event: String) -> CAAction? {
        switch event {
        case textKey, attributedTextKey:
            return CATransition.fade
        default:
            return super.action(for: layer, forKey: event)
        }
    }
}
