//
//  SpinnerView.swift
//  HSpace
//
//  Created by DEEBA on 15.08.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation

import UIKit

@IBDesignable
class SpinnerView : UIView {

    override var layer: CAShapeLayer {
        get {
            return super.layer as! CAShapeLayer
        }
    }

    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.fillColor = nil
        layer.strokeColor = #colorLiteral(red: 0, green: 0.4745098039, blue: 1, alpha: 1)
        layer.lineWidth = 5.5
        
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 1, y: 0.5)
        gradient.endPoint = CGPoint(x: 0, y: 0.5)
        gradient.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        gradient.colors = [
            UIColor(white: 1, alpha: 0.1).cgColor,
            UIColor(white: 1, alpha: 0.3).cgColor,
            UIColor(white: 1, alpha: 0.6).cgColor,
            UIColor(white: 1, alpha: 0.9).cgColor,
            UIColor(white: 1, alpha: 1).cgColor
        ]
        gradient.locations = [
            0.0,
            0.2,
            0.6,
            0.8,
            0.9
        ]
        
        self.layer.mask = gradient
        setPath()
        
    }

    override func didMoveToWindow() {
        animate()
    }

    private func setPath() {
        layer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: layer.lineWidth / 2, dy: layer.lineWidth / 2)).cgPath
    }

    struct Pose {
        let secondsSincePriorPose: CFTimeInterval
        let start: CGFloat
        let length: CGFloat
        init(_ secondsSincePriorPose: CFTimeInterval, _ start: CGFloat, _ length: CGFloat) {
            self.secondsSincePriorPose = secondsSincePriorPose
            self.start = start
            self.length = length
        }
    }

    class var poses: [Pose] {
        get {
            return [
                Pose(0.6, 0.000, 0.7),
                Pose(0.6, 0.500, 0.7),
                Pose(0.6, 1.000, 0.7),
                Pose(0.6, 1.500, 0.7),
                Pose(0.6, 1.875, 0.7),
                Pose(0.6, 2.250, 0.7),
                Pose(0.6, 2.625, 0.7),
                Pose(0.6, 3.000, 0.7),
            ]
        }
    }

    func animate() {
        var time: CFTimeInterval = 0
        var times = [CFTimeInterval]()
        var start: CGFloat = 0
        var rotations = [CGFloat]()
        var strokeEnds = [CGFloat]()

        let poses = type(of: self).poses
        let totalSeconds = poses.reduce(0) { $0 + $1.secondsSincePriorPose }

        for pose in poses {
            time += pose.secondsSincePriorPose
            times.append(time / totalSeconds)
            start = pose.start
            rotations.append(start * 2 * .pi)
            strokeEnds.append(pose.length)
        }

        times.append(times.last!)
        rotations.append(rotations[0])
        strokeEnds.append(strokeEnds[0])

        animateKeyPath(keyPath: "strokeEnd", duration: totalSeconds, times: times, values: strokeEnds)
        animateKeyPath(keyPath: "transform.rotation", duration: totalSeconds, times: times, values: rotations)

    }

    func animateKeyPath(keyPath: String, duration: CFTimeInterval, times: [CFTimeInterval], values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.keyTimes = times as [NSNumber]?
        animation.values = values
        animation.calculationMode = .linear
        animation.duration = duration
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }

}
