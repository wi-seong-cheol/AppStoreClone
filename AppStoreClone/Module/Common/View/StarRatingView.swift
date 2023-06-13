//
//  StarRatingView.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/06/13.
//

import UIKit

final class StarRatingView: UIView {
    
    private var viewSize: CGSize = .init()
    
    func configure(with rating: Double) {
        let layers = createStarLayers(rating)
        
        layer.sublayers = layers
        updateSize(layers)
    }
    
    override public var intrinsicContentSize: CGSize {
        return viewSize
    }
}

private extension StarRatingView {
    
    func updateSize(_ layers: [CALayer]) {
        viewSize = calculateSizeToFitLayers(layers)
        invalidateIntrinsicContentSize()
        
        frame.size = intrinsicContentSize
    }
    
    func calculateSizeToFitLayers(_ layers: [CALayer]) -> CGSize {
        var size = CGSize()
        
        for layer in layers {
            if layer.frame.maxX > size.width {
                size.width = layer.frame.maxX
            }
            
            if layer.frame.maxY > size.height {
                size.height = layer.frame.maxY
            }
        }
        
        return size
    }
    
    // TODO: configure
    
    func createStarLayers(_ rating: Double, totalStars: Int = 5) -> [CALayer] {
        let filledStarCount = Int(rating)
        let emptyStarCount = Int(Double(totalStars) - rating)
        let partial = rating - Double(filledStarCount)
        
        var starLayers = [CALayer]()
        
        (0..<filledStarCount).forEach { _ in
            starLayers.append(createStarLayer(true))
        }
        
        if 0 < partial && partial < 1 {
            starLayers.append(createPartialStar(partial))
        }
        
        (0..<emptyStarCount).forEach { _ in
            starLayers.append(createStarLayer(false))
        }
        
        positionStarLayers(starLayers)
        return starLayers
    }
    
    func createPartialStar(_ starFillLevel: Double) -> CALayer {
        let filledStarLayer = createStarLayer(true)
        let emptyStarLayer = createStarLayer(false)
        
        let parentLayer = CALayer()
        parentLayer.contentsScale = UIScreen.main.scale
        parentLayer.bounds = CGRect(origin: .zero, size: filledStarLayer.bounds.size)
        parentLayer.anchorPoint = .zero
        parentLayer.addSublayer(emptyStarLayer)
        parentLayer.addSublayer(filledStarLayer)
        
        // Make filled layer width smaller according to the fill level
        filledStarLayer.bounds.size.width *= CGFloat(starFillLevel)
        
        return parentLayer
    }
    
    func createStarLayer(_ isFilled: Bool) -> CALayer {
        return create(
            fillColor: isFilled ? .gray : .white
        )
    }
    
    func positionStarLayers(_ layers: [CALayer], starMargin: Double = 5.0) {
        var positionX: CGFloat = 0
        
        for layer in layers {
            layer.position.x = positionX
            positionX += layer.bounds.width + CGFloat(starMargin)
        }
    }
    
    // TODO: StarLayer
    func create(
        size: Double = 12.0,
        lineWidth: Double = 1.0,
        fillColor: UIColor = .gray,
        strokeColor: UIColor = .gray,
        cornerRadius: Double = 0.4
    ) -> CALayer {
        
        let containerLayer = createContainerLayer(size)
        let path = createStarPath(size: size,
                                  lineWidth: lineWidth,
                                  cornerRadius: cornerRadius)
        
        let shapeLayer = createShapeLayer(path.cgPath,
                                          lineWidth: lineWidth,
                                          fillColor: fillColor,
                                          strokeColor: strokeColor,
                                          size: size)
        
        containerLayer.addSublayer(shapeLayer)
        
        return containerLayer
    }
    
    // MARK: 이미지로 별 그릴 때
    //    func create(image: UIImage, size: Double = 12.0) -> CALayer {
    //        let containerLayer = createContainerLayer(size)
    //        let imageLayer = createContainerLayer(size)
    //
    //        imageLayer.contents = image.cgImage
    //        imageLayer.contentsGravity = CALayerContentsGravity.resizeAspect
    //        containerLayer.addSublayer(imageLayer)
    //
    //        return containerLayer
    //    }
    //
    //    func create(image: UIImage, filledColor: UIColor = .gray, size: Double = 12.0) -> CALayer {
    //        let containerLayer = createContainerLayer(size)
    //        let imageLayer = createContainerLayer(size)
    //
    //        imageLayer.contents = image.cgImage
    //        imageLayer.contentsGravity = CALayerContentsGravity.resizeAspect
    //        containerLayer.mask = imageLayer
    //        containerLayer.backgroundColor = filledColor.cgColor
    //
    //        return containerLayer
    //    }
    
    func createShapeLayer(
        _ path: CGPath,
        lineWidth: Double,
        fillColor: UIColor,
        strokeColor: UIColor,
        size: Double
    ) -> CALayer {
        
        let layer = CAShapeLayer()
        layer.anchorPoint = CGPoint()
        layer.contentsScale = UIScreen.main.scale
        layer.strokeColor = strokeColor.cgColor
        layer.fillColor = fillColor.cgColor
        layer.lineWidth = CGFloat(lineWidth)
        layer.bounds.size = CGSize(width: size, height: size)
        layer.masksToBounds = true
        layer.path = path
        layer.isOpaque = true
        return layer
    }
    
    func createContainerLayer(_ size: Double) -> CALayer {
        let layer = CALayer()
        layer.contentsScale = UIScreen.main.scale
        layer.anchorPoint = CGPoint()
        layer.masksToBounds = true
        layer.bounds.size = CGSize(width: size, height: size)
        layer.isOpaque = true
        return layer
    }
    
    func createStarPath(
        size: Double,
        lineWidth: Double,
        cornerRadius: Double
    ) -> UIBezierPath {
        
        let rotation: CGFloat = 54.0
        let rect = CGRect(origin: .zero, size: CGSize(width: size, height: size))
        let lineWidth: CGFloat = lineWidth
        let cornerRadius: CGFloat = cornerRadius
        
        let path = UIBezierPath()
        let centerPoint = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let r = rect.width / 2
        let rn = r * 0.95 - cornerRadius - lineWidth
        
        var cangle = rotation
        for i in 1 ... 10 {
            // compute center point of tip arc
            let isInner: Bool = i % 2 == 0 ? true : false
            
            if isInner {
                let p = CGPoint(x: centerPoint.x + (rn * (5 / 8)) * cos(cangle * .pi / 180),
                                y: centerPoint.y + (rn * (5 / 8)) * sin(cangle * .pi / 180))
                path.addLine(to: p)
            } else {
                let cc = CGPoint(x: centerPoint.x + (rn + lineWidth) * cos(cangle * .pi / 180),
                                 y: centerPoint.y + (rn + lineWidth) * sin(cangle * .pi / 180))
                
                // compute tangent point along tip arc
                let p = CGPoint(x: cc.x + cornerRadius * cos((cangle - 72) * .pi / 180),
                                y: cc.y + cornerRadius * sin((cangle - 72) * .pi / 180))
                
                if i == 1 {
                    path.move(to: p)
                } else {
                    path.addLine(to: p)
                }
                
                path.addArc(withCenter: cc,
                            radius: cornerRadius,
                            startAngle: (cangle - 72) * .pi / 180,
                            endAngle: (cangle + 72) * .pi / 180,
                            clockwise: true)
            }
            
            cangle += 36
        }
        
        path.close()
        return path
    }
}
