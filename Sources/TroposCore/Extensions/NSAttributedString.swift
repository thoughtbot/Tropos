import UIKit

extension NSAttributedString {
    @objc var entireRange: NSRange {
        return NSRange(location: 0, length: length)
    }
}

extension NSAttributedString {
    @objc var font: UIFont? {
        return attribute(.font, at: 0, effectiveRange: nil) as? UIFont
    }

    @objc var textColor: UIColor? {
        return attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor
    }
}

extension NSMutableAttributedString {
    override var font: UIFont? {
        get {
            return super.font
        }
        set {
            if let font = newValue {
                setAttributes([.font: font], range: entireRange)
            } else {
                removeAttribute(.font, range: entireRange)
            }
        }
    }

    override var textColor: UIColor? {
        get {
            return super.textColor
        }
        set {
            if let color = newValue {
                setTextColor(color, forRange: entireRange)
            } else {
                removeAttribute(.foregroundColor, range: entireRange)
            }
        }
    }

    @objc func setTextColor(_ color: UIColor, forRange range: NSRange) {
        setAttributes([.foregroundColor: color], range: range)
    }

    @objc func setTextColor(_ color: UIColor, forSubstring substring: String) {
        let range = (string as NSString).range(of: substring)
        setTextColor(color, forRange: range)
    }
}
