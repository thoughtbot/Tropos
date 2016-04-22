import UIKit

extension UIColor {
    public static var defaultTextColor: UIColor {
        return .whiteColor()
    }

    public static var primaryBackgroundColor: UIColor {
        return UIColor(hue: 240.0 / 360.0, saturation: 0.24, brightness: 0.13, alpha: 1.0)
    }

    public static var secondaryBackgroundColor: UIColor {
        return UIColor(hue: 240.0 / 360.0, saturation: 0.22, brightness: 0.16, alpha: 1.0)
    }

    public static var hotColor: UIColor {
        return UIColor(hue: 11.0 / 360.0, saturation: 0.80, brightness: 0.92, alpha: 1.0)
    }

    public static var warmerColor: UIColor {
        return UIColor(hue: 40.0 / 360.0, saturation: 1.0, brightness: 0.97, alpha: 1.0)
    }

    public static var coolerColor: UIColor {
        return UIColor(hue: 194.0 / 360.0, saturation: 1.0, brightness: 0.93, alpha: 1.0)
    }

    public static var coldColor: UIColor {
        return UIColor(hue: 194.0 / 360.0, saturation: 0.54, brightness: 0.95, alpha: 1.0)
    }

    func lighten(by amount: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        return UIColor(
            hue: hue,
            saturation: saturation * (1 - amount),
            brightness: brightness * (1 - amount) + amount,
            alpha: alpha
        )
    }
}
