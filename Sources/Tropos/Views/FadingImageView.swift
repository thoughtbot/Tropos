import UIKit

private let imageKey = #selector(setter: UIImageView.image).description

class FadingImageView: UIImageView {
    override var image: UIImage? {
        didSet {
            layer.setValue(image, forKey: imageKey)
        }
    }

    override func action(for layer: CALayer, forKey event: String) -> CAAction? {
        switch event {
        case imageKey:
            return CATransition.fade
        default:
            return super.action(for: layer, forKey: event)
        }
    }
}
