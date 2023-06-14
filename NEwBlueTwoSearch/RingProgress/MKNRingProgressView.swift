//
//  MKNRingProgressView.swift
//  NEwBlueTwoSearch
//
//  Created by sege li on 2023/6/5.
//

import Foundation
import UIKit

@objc(MKRingProgressViewStyle)
public enum RingProgressViewStyle: Int {
    case round
    case square
}

@IBDesignable
@objc(MKRingProgressView)
open class RingProgressView: UIView {
    /// The start color of the progress ring.
    @IBInspectable open var startColor: UIColor = .red {
        didSet {
            ringProgressLayer.startColor = startColor.cgColor
        }
    }
    
    /// The end color of the progress ring.
    @IBInspectable open var endColor: UIColor = .blue {
        didSet {
            ringProgressLayer.endColor = endColor.cgColor
        }
    }
    
    /// The color of backdrop circle, visible at progress values between 0.0 and 1.0.
    /// If not specified, `startColor` with 15% opacity will be used.
    @IBInspectable open var backgroundRingColor: UIColor? {
        didSet {
            ringProgressLayer.backgroundRingColor = backgroundRingColor?.cgColor
        }
    }
    
    /// The width of the progress ring. Defaults to `20`.
    @IBInspectable open var ringWidth: CGFloat {
        get {
            return ringProgressLayer.ringWidth
        }
        set {
            ringProgressLayer.ringWidth = newValue
        }
    }
    
    /// The style of the progress line end. Defaults to `round`.
    @objc open var style: RingProgressViewStyle {
        get {
            return ringProgressLayer.progressStyle
        }
        set {
            ringProgressLayer.progressStyle = newValue
        }
    }
    
    /// The opacity of the shadow below progress line end. Defaults to `1.0`.
    /// Values outside the [0,1] range will be clamped.
    @IBInspectable open var ringShadowOpacity: CGFloat {
        get {
            return ringProgressLayer.endShadowOpacity
        }
        set {
            ringProgressLayer.endShadowOpacity = newValue
        }
    }
    
    /// Whether or not to hide the progress ring when progress is zero. Defaults to `false`.
    @IBInspectable open var hidesRingForZeroProgress: Bool {
        get {
            return ringProgressLayer.hidesRingForZeroProgress
        }
        set {
            ringProgressLayer.hidesRingForZeroProgress = newValue
        }
    }
    
    /// The Antialiasing switch. Defaults to `true`.
    @IBInspectable open var allowsAntialiasing: Bool {
        get {
            return ringProgressLayer.allowsAntialiasing
        }
        set {
            ringProgressLayer.allowsAntialiasing = newValue
        }
    }
    
    /// The scale of the generated gradient image.
    /// Use lower values for better performance and higher values for more precise gradients.
    @IBInspectable open var gradientImageScale: CGFloat {
        get {
            return ringProgressLayer.gradientImageScale
        }
        set {
            ringProgressLayer.gradientImageScale = newValue
        }
    }
    
    /// The progress. Can be any nonnegative number, every whole number corresponding to one full revolution, i.e. 1.0 -> 360°, 2.0 -> 720°, etc. Defaults to `0.0`. Animatable.
    @IBInspectable open var progress: Double {
        get {
            return Double(ringProgressLayer.progress)
        }
        set {
            ringProgressLayer.progress = CGFloat(newValue)
        }
    }
    
    open override class var layerClass: AnyClass {
        return RingProgressLayer.self
    }
    
    private var ringProgressLayer: RingProgressLayer {
        return layer as! RingProgressLayer
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    private func setup() {
        layer.drawsAsynchronously = true
        layer.contentsScale = UIScreen.main.scale
        isAccessibilityElement = true
        #if swift(>=4.2)
            accessibilityTraits = UIAccessibilityTraits.updatesFrequently
        #else
            accessibilityTraits = UIAccessibilityTraitUpdatesFrequently
        #endif
        accessibilityLabel = "Ring progress"
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        ringProgressLayer.disableProgressAnimation = true
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, tvOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                ringProgressLayer.startColor = startColor.cgColor
                ringProgressLayer.endColor = endColor.cgColor
                ringProgressLayer.backgroundRingColor = backgroundRingColor?.cgColor
            }
        }
    }
    
    // MARK: Accessibility
    
    private var overriddenAccessibilityValue: String?
    
    open override var accessibilityValue: String? {
        get {
            if let override = overriddenAccessibilityValue {
                return override
            }
            return String(format: "%.f%%", progress * 100)
        }
        set {
            overriddenAccessibilityValue = newValue
        }
    }
}


@objc(MKRingProgressLayer)
open class RingProgressLayer: CALayer {
    /// The progress ring start color.
    @objc open var startColor: CGColor = UIColor.red.cgColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The progress ring end color.
    @objc open var endColor: CGColor = UIColor.blue.cgColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The color of the background ring.
    @objc open var backgroundRingColor: CGColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The width of the progress ring.
    @objc open var ringWidth: CGFloat = 20 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The style of the progress line end (rounded or straight).
    @objc open var progressStyle: RingProgressViewStyle = .round {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The opacity of the shadow under the progress end.
    @objc open var endShadowOpacity: CGFloat = 1.0 {
        didSet {
            endShadowOpacity = min(max(endShadowOpacity, 0.0), 1.0)
            setNeedsDisplay()
        }
    }
    
    /// Whether or not to hide the progress ring when progress is zero.
    @objc open var hidesRingForZeroProgress: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// Whether or not to allow anti-aliasing for the generated image.
    @objc open var allowsAntialiasing: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The scale of the generated gradient image.
    /// Use lower values for better performance and higher values for more precise gradients.
    @objc open var gradientImageScale: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The current progress shown by the view.
    /// Values less than 0.0 are clamped. Values greater than 1.0 present multiple revolutions of the progress ring.
    @NSManaged public var progress: CGFloat
    
    /// Disable actions for `progress` property.
    internal var disableProgressAnimation: Bool = false
    
    private let gradientGenerator = GradientGenerator()
    
    open override class func needsDisplay(forKey key: String) -> Bool {
        if key == "progress" {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    open override func action(forKey event: String) -> CAAction? {
        if !disableProgressAnimation, event == "progress" {
            if let action = super.action(forKey: "opacity") as? CABasicAnimation {
                let animation = action.copy() as! CABasicAnimation
                animation.keyPath = event
                animation.fromValue = (presentation() ?? model()).value(forKey: event)
                animation.toValue = nil
                return animation
            } else {
                let animation = CABasicAnimation(keyPath: event)
                animation.duration = 0.001
                return animation
            }
        }
        return super.action(forKey: event)
    }
    
    open override func display() {
        contents = contentImage()
    }
    
    func contentImage() -> CGImage? {
        let size = bounds.size
        guard size.width > 0, size.height > 0 else {
            return nil
        }
        if #available(iOS 10.0, tvOS 10.0, *) {
            let format = UIGraphicsImageRendererFormat.default()
            let image = UIGraphicsImageRenderer(size: size, format: format).image { ctx in
                drawContent(in: ctx.cgContext)
            }
            return image.cgImage
        } else {
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            guard let ctx = UIGraphicsGetCurrentContext() else {
                return nil
            }
            drawContent(in: ctx)
            let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
            UIGraphicsEndImageContext()
            return image
        }
    }
    
    private func drawContent(in context: CGContext) {
        context.setShouldAntialias(allowsAntialiasing)
        context.setAllowsAntialiasing(allowsAntialiasing)
        
        let useGradient = startColor != endColor
        
        let squareSize = min(bounds.width, bounds.height)
        let squareRect = CGRect(
            x: (bounds.width - squareSize) / 2,
            y: (bounds.height - squareSize) / 2,
            width: squareSize,
            height: squareSize
        )
        let gradientRect = squareRect.integral
        
        let w = min(ringWidth, squareSize / 2)
        let r = min(bounds.width, bounds.height) / 2 - w / 2
        let c = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let p = max(0.0, disableProgressAnimation ? progress : presentation()?.progress ?? 0.0)
        let angleOffset = CGFloat.pi / 2
        let angle = 2 * .pi * p - angleOffset
        let minAngle = 1.1 * atan(0.5 * w / r)
        let maxAngle = 2 * .pi - 3 * minAngle - angleOffset
        
        let circleRect = squareRect.insetBy(dx: w / 2, dy: w / 2)
        let circlePath = UIBezierPath(ovalIn: circleRect)
        
        let angle1 = angle > maxAngle ? maxAngle : angle
        
        context.setLineWidth(w)
        context.setLineCap(progressStyle.lineCap)
        
        // Draw backdrop circle
        
        context.addPath(circlePath.cgPath)
        let bgColor = backgroundRingColor ?? startColor.copy(alpha: 0.15)!
        context.setStrokeColor(bgColor)
        context.strokePath()
        
        // Draw solid arc
        
        if angle > maxAngle {
            let offset = angle - maxAngle
            
            let arc2Path = UIBezierPath(
                arcCenter: c,
                radius: r,
                startAngle: -angleOffset,
                endAngle: offset,
                clockwise: true
            )
            context.addPath(arc2Path.cgPath)
            context.setStrokeColor(startColor)
            context.strokePath()
            
            context.translateBy(x: circleRect.midX, y: circleRect.midY)
            context.rotate(by: offset)
            context.translateBy(x: -circleRect.midX, y: -circleRect.midY)
        }
        
        // Draw shadow and progress end
        
        if p > 0.0 || !hidesRingForZeroProgress {
            context.saveGState()
            
            if endShadowOpacity > 0.0 {
                context.addPath(
                    CGPath(
                        __byStroking: circlePath.cgPath,
                        transform: nil,
                        lineWidth: w,
                        lineCap: .round,
                        lineJoin: .round,
                        miterLimit: 0
                    )!
                )
                context.clip()
                
                let shadowOffset = CGSize(
                    width: w / 10 * cos(angle + angleOffset),
                    height: w / 10 * sin(angle + angleOffset)
                )
                context.setShadow(
                    offset: shadowOffset,
                    blur: w / 3,
                    color: UIColor(white: 0.0, alpha: endShadowOpacity).cgColor
                )
            }
            
            let arcEnd = CGPoint(x: c.x + r * cos(angle1), y: c.y + r * sin(angle1))
            
            let shadowPath: UIBezierPath = {
                switch progressStyle {
                case .round:
                    return UIBezierPath(
                        ovalIn: CGRect(
                            x: arcEnd.x - w / 2,
                            y: arcEnd.y - w / 2,
                            width: w,
                            height: w
                        )
                    )
                case .square:
                    let path = UIBezierPath(
                        rect: CGRect(
                            x: arcEnd.x - w / 2,
                            y: arcEnd.y - 2,
                            width: w,
                            height: 2
                        )
                    )
                    path.apply(CGAffineTransform(translationX: -arcEnd.x, y: -arcEnd.y))
                    path.apply(CGAffineTransform(rotationAngle: angle1))
                    path.apply(CGAffineTransform(translationX: arcEnd.x, y: arcEnd.y))
                    return path
                }
            }()
            
            let shadowFillColor: CGColor = {
                let fadeStartProgress: CGFloat = 0.02
                if !hidesRingForZeroProgress || p > fadeStartProgress {
                    return startColor
                }
                // gradually decrease shadow opacity
                return startColor.copy(alpha: p / fadeStartProgress)!
            }()
            context.addPath(shadowPath.cgPath)
            context.setFillColor(shadowFillColor)
            context.fillPath()
            
            context.restoreGState()
        }
        
        // Draw gradient arc
        
        let gradient: CGImage? = {
            guard useGradient else {
                return nil
            }
            let s = Float(1.5 * w / (2 * .pi * r))
            gradientGenerator.scale = gradientImageScale
            gradientGenerator.size = gradientRect.size
            gradientGenerator.colors = [endColor, endColor, startColor, startColor]
            gradientGenerator.locations = [0.0, s, 1.0 - s, 1.0]
            gradientGenerator.endPoint = CGPoint(x: 0.5 - CGFloat(2 * s), y: 1.0)
            return gradientGenerator.image()
        }()
        
        if p > 0.0 {
            let arc1Path = UIBezierPath(
                arcCenter: c,
                radius: r,
                startAngle: -angleOffset,
                endAngle: angle1,
                clockwise: true
            )
            if let gradient = gradient {
                context.saveGState()
                
                context.addPath(
                    CGPath(
                        __byStroking: arc1Path.cgPath,
                        transform: nil,
                        lineWidth: w,
                        lineCap: progressStyle.lineCap,
                        lineJoin: progressStyle.lineJoin,
                        miterLimit: 0
                    )!
                )
                context.clip()
                
                context.interpolationQuality = .none
                context.draw(gradient, in: gradientRect)
                
                context.restoreGState()
            } else {
                context.setStrokeColor(startColor)
                context.setLineWidth(w)
                context.setLineCap(progressStyle.lineCap)
                context.addPath(arc1Path.cgPath)
                context.strokePath()
            }
        }
    }
}

private extension RingProgressViewStyle {
    var lineCap: CGLineCap {
        switch self {
        case .round:
            return .round
        case .square:
            return .butt
        }
    }
    
    var lineJoin: CGLineJoin {
        switch self {
        case .round:
            return .round
        case .square:
            return .miter
        }
    }
}


internal final class GradientGenerator {
    var scale: CGFloat = UIScreen.main.scale {
        didSet {
            if scale != oldValue {
                reset()
            }
        }
    }
    
    var size: CGSize = .zero {
        didSet {
            if size != oldValue {
                reset()
            }
        }
    }
    
    var colors: [CGColor] = [] {
        didSet {
            if colors != oldValue {
                reset()
            }
        }
    }
    
    var locations: [Float] = [] {
        didSet {
            if locations != oldValue {
                reset()
            }
        }
    }
    
    var startPoint: CGPoint = CGPoint(x: 0.5, y: 0.5) {
        didSet {
            if startPoint != oldValue {
                reset()
            }
        }
    }
    
    var endPoint: CGPoint = CGPoint(x: 1.0, y: 0.5) {
        didSet {
            if endPoint != oldValue {
                reset()
            }
        }
    }
    
    private var generatedImage: CGImage?
    
    func reset() {
        generatedImage = nil
    }
    
    func image() -> CGImage? {
        if let image = generatedImage {
            return image
        }
        
        let w = Int(size.width * scale)
        let h = Int(size.height * scale)
        
        guard w > 0, h > 0 else {
            return nil
        }
        
        let bitsPerComponent: Int = MemoryLayout<UInt8>.size * 8
        let bytesPerPixel: Int = bitsPerComponent * 4 / 8
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        var data = [ARGB]()
        
        for y in 0 ..< h {
            for x in 0 ..< w {
                let c = pixelDataForGradient(
                    at: CGPoint(x: x, y: y),
                    size: CGSize(width: w, height: h),
                    colors: colors,
                    locations: locations,
                    startPoint: startPoint,
                    endPoint: endPoint
                )
                data.append(c)
            }
        }
        
        // Fix for #63 - force retain `data` to prevent crash when CGContext uses the buffer
        let image: CGImage? = withExtendedLifetime(&data) { (data: UnsafeMutableRawPointer) -> CGImage? in
            guard let ctx = CGContext(
                data: data,
                width: w,
                height: h,
                bitsPerComponent: bitsPerComponent,
                bytesPerRow: w * bytesPerPixel,
                space: colorSpace,
                bitmapInfo: bitmapInfo.rawValue
            ) else {
                return nil
            }
            ctx.interpolationQuality = .none
            ctx.setShouldAntialias(false)
            
            return ctx.makeImage()
        }
        
        generatedImage = image
        return image
    }
    
    private func pixelDataForGradient(
        at point: CGPoint,
        size: CGSize,
        colors: [CGColor],
        locations: [Float],
        startPoint: CGPoint,
        endPoint: CGPoint
    ) -> ARGB {
        let t = conicalGradientStop(point, size, startPoint, endPoint)
        return interpolatedColor(t, colors, locations)
    }
    
    private func conicalGradientStop(_ point: CGPoint, _ size: CGSize, _ g0: CGPoint, _ g1: CGPoint) -> Float {
        let c = CGPoint(x: size.width * g0.x, y: size.height * g0.y)
        let s = CGPoint(x: size.width * (g1.x - g0.x), y: size.height * (g1.y - g0.y))
        let q = atan2(s.y, s.x)
        let p = CGPoint(x: point.x - c.x, y: point.y - c.y)
        var a = atan2(p.y, p.x) - q
        if a < 0 {
            a += 2 * .pi
        }
        let t = a / (2 * .pi)
        return Float(t)
    }
    
    private func interpolatedColor(_ t: Float, _ colors: [CGColor], _ locations: [Float]) -> ARGB {
        assert(!colors.isEmpty)
        assert(colors.count == locations.count)
        
        var p0: Float = 0
        var p1: Float = 1
        
        var c0 = colors.first!
        var c1 = colors.last!
        
        for (i, v) in locations.enumerated() {
            if v > p0, t >= v {
                p0 = v
                c0 = colors[i]
            }
            if v < p1, t <= v {
                p1 = v
                c1 = colors[i]
            }
        }
        
        let p: Float
        if p0 == p1 {
            p = 0
        } else {
            p = lerp(t, inRange: p0 ... p1, outRange: 0 ... 1)
        }
        
        let color0 = ARGB(c0)
        let color1 = ARGB(c1)
        
        return color0.interpolateTo(color1, p)
    }
}

// MARK: - Color Data

private struct ARGB {
    let a: UInt8 = 0xFF
    var r: UInt8
    var g: UInt8
    var b: UInt8
}

extension ARGB: Equatable {
    static func == (lhs: ARGB, rhs: ARGB) -> Bool {
        return (lhs.r == rhs.r && lhs.g == rhs.g && lhs.b == rhs.b)
    }
}

extension ARGB {
    init(_ color: CGColor) {
        let c = color.components!.map { min(max($0, 0.0), 1.0) }
        switch color.numberOfComponents {
        case 2:
            self.init(r: UInt8(c[0] * 0xFF), g: UInt8(c[0] * 0xFF), b: UInt8(c[0] * 0xFF))
        case 4:
            self.init(r: UInt8(c[0] * 0xFF), g: UInt8(c[1] * 0xFF), b: UInt8(c[2] * 0xFF))
        default:
            self.init(r: 0, g: 0, b: 0)
        }
    }
    
    func interpolateTo(_ color: ARGB, _ t: Float) -> ARGB {
        let r = lerp(t, self.r, color.r)
        let g = lerp(t, self.g, color.g)
        let b = lerp(t, self.b, color.b)
        return ARGB(r: r, g: g, b: b)
    }
}

// MARK: - Utility

private func lerp(_ t: Float, _ a: UInt8, _ b: UInt8) -> UInt8 {
    return UInt8(Float(a) + min(max(t, 0), 1) * (Float(b) - Float(a)))
}

private func lerp(_ value: Float, inRange: ClosedRange<Float>, outRange: ClosedRange<Float>) -> Float {
    return (value - inRange.lowerBound) * (outRange.upperBound - outRange.lowerBound) / (inRange.upperBound - inRange.lowerBound) + outRange.lowerBound
}
