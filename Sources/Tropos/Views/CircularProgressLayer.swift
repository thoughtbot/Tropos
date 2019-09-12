import UIKit

@objc(TRCircularProgressLayer) class CircularProgressLayer: CALayer {
    @objc var progress: CGFloat = CGFloat(0)
    @objc var radius = CGFloat(15.0)
    @objc let outerRingWidth = CGFloat(3.0)

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init() {
        super.init()
        self.actions = [
            "bounds": NSNull(),
            "contents": NSNull(),
            "position": NSNull(),
        ]
        self.contentsScale = UIScreen.main.scale
        self.needsDisplayOnBoundsChange = true
    }

    init(layer: CircularProgressLayer) {
        super.init(layer: layer)
        progress = layer.progress
        radius = layer.radius
    }

    override func draw(in ctx: CGContext) {
        let center = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
        let progress = min(self.progress, 1.0 - CGFloat.ulpOfOne)
        let radians = (progress * .pi * 2.0) - .pi

        ctx.setFillColor(self.backgroundColor ?? UIColor.black.cgColor)
        ctx.fill(bounds)
        ctx.setBlendMode(.clear)
        ctx.setLineWidth(CGFloat(outerRingWidth))
        ctx.setStrokeColor(UIColor.clear.cgColor)
        ctx.addArc(
            center: center,
            radius: CGFloat(radius),
            startAngle: 0.0,
            endAngle: 2 * .pi,
            clockwise: false
        )
        ctx.strokePath()

        if progress > 0.0 {
            ctx.setFillColor(UIColor.clear.cgColor)
            let progressPath = CGMutablePath()
            progressPath.move(to: center)
            progressPath.addArc(
                center: center,
                radius: CGFloat(self.radius),
                startAngle: 3.0 * .pi,
                endAngle: radians,
                clockwise: false
            )
            ctx.closePath()
            ctx.addPath(progressPath)
            ctx.fillPath()
        }
    }

    override class func needsDisplay(forKey key: String) -> Bool {
        switch key {
        case "progress", "radius", "outerRingWidth":
            return true
        default:
            return false
        }
    }
}
