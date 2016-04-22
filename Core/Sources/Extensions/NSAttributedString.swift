import UIKit

extension NSAttributedString {
    var entireRange: NSRange {
        return NSRange(location: 0, length: length)
    }
}

extension NSAttributedString {
    var font: UIFont? {
        return attribute(NSFontAttributeName, atIndex: 0, effectiveRange: nil) as? UIFont
    }

    var textColor: UIColor? {
        return attribute(NSForegroundColorAttributeName, atIndex: 0, effectiveRange: nil) as? UIColor
    }
}

extension NSMutableAttributedString {
    override var font: UIFont? {
        get {
            return super.font
        }
        set {
            if let font = newValue {
                setAttributes([NSFontAttributeName: font], range: entireRange)
            } else {
                removeAttribute(NSFontAttributeName, range: entireRange)
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
                removeAttribute(NSForegroundColorAttributeName, range: entireRange)
            }
        }
    }

    func setTextColor(color: UIColor, forRange range: NSRange) {
        setAttributes([NSForegroundColorAttributeName: color], range: range)
    }

    func setTextColor(color: UIColor, forSubstring substring: String) {
        let range = (string as NSString).rangeOfString(substring)
        setTextColor(color, forRange: range)
    }
}
