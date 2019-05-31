//
//  ViewController.swift
//  GlossyUI
//
//  Created by Andrzej Michnia on 04/27/2019.
//  Copyright (c) 2019 Andrzej Michnia. All rights reserved.
//

import UIKit
import CoreMotion
import GlossyUI

class ViewController: UIViewController {

    @IBOutlet weak var glossLabel: GlossLabel!
    @IBOutlet weak var glossImageView: GlossImageView!
    @IBOutlet weak var sliderX: UISlider!
    @IBOutlet weak var sliderY: UISlider!

    let manager = CMMotionManager()
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        glossLabel.matt = .color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        glossLabel.gloss = .color(#colorLiteral(red: 0.8510238528, green: 0.8510238528, blue: 0.8510238528, alpha: 1))
        glossLabel.initialOffset = CGPoint(x: -0.01, y: -0.5)
        glossLabel.setNeedsLayout()
        glossLabel.setNeedsDisplay()

        glossImageView.matt = .image(UIImage(named: "skillcloud-test-matt")!)
        glossImageView.gloss = .image(UIImage(named: "skillcloud-test-gloss")!)
        glossImageView.shape = .image(UIImage(named: "skillcloud-test-mask")!)
        glossImageView.reflex = Reflex(
            image: UIImage(named: "skillcloud-test-blink")!,
            style: .grid3x3
        )

        sliderX.value = Float(glossLabel.initialOffset.x)
        sliderY.value = Float(glossLabel.initialOffset.y)

        setup()
    }

    deinit {
        timer?.invalidate()
        manager.isDeviceMotionActive ? manager.stopAccelerometerUpdates() : ()
    }

    func setup() {
        guard manager.isDeviceMotionAvailable else { return }

        manager.startDeviceMotionUpdates()

        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            self?.update()
        }
    }

    @IBAction func sliderXupdated(_ sender: UISlider) {
        update()
        print(glossLabel.initialOffset)
    }

    @IBAction func sliderYupdated(_ sender: UISlider) {
        update()
        print(glossLabel.initialOffset)
    }

    enum Position {
        case down
        case front
        case up
    }

    var position = Position.down
    let ε = 0.2
    var baseθ = 0.0
    var baseψ = 0.0
    var baseRoll = 0.0
    var lastRoll = 0.0

    func update() {
        glossLabel.initialOffset = CGPoint(
            x: CGFloat(sliderX.value),
            y: CGFloat(sliderY.value)
        )
        glossImageView.initialOffset = CGPoint(
            x: CGFloat(sliderX.value),
            y: CGFloat(sliderY.value)
        )

        guard let attitude = manager.deviceMotion?.attitude else { return }

        let w = attitude.quaternion.w
        let x = attitude.quaternion.x
        let y = attitude.quaternion.y
        let z = attitude.quaternion.z

        let sinr_cosp = +2.0 * (w * x + y * z)
        let cosr_cosp = +1.0 - 2.0 * (x * x + y * y)
        let sinp = +2.0 * (w * y - z * x)
        let siny_cosp = +2.0 * (w * z + x * y)
        let cosy_cosp = +1.0 - 2.0 * (y * y + z * z)

        let ϕ = atan2(sinr_cosp, cosr_cosp)
        let θ = fabs(sinp) >= 1 ? copysign(Double.pi / 2, sinp) : asin(sinp)
        let ψ = atan2(siny_cosp, cosy_cosp)

        let newPosition: Position = {
            switch ϕ {
            case let n where n < Double.pi½ - ε: return .down
            case let n where n > Double.pi½ + ε: return .up
            default: return .front
            }
        }()

        if position != newPosition {
            baseθ = θ
            baseψ = ψ
            position = newPosition
            baseRoll = lastRoll
        }

        let pitch = ϕ / Double.pi
        let roll: Double = {
            switch position {
            case .down:
                return  1.0 * (θ - baseθ) / Double.pi // 0 after transition
            case .front:
                return -0.7 * (ψ - baseψ) / Double.pi // 0 after transition
            case .up:
                return -1.0 * (θ - baseθ) / Double.pi // 0 after transition
            }
        }() + baseRoll

        lastRoll = roll

        glossImageView.offset = CGPoint(
            x: -4 * CGFloat(roll),
            y: -2 * CGFloat(pitch)
        )
        glossLabel.offset = CGPoint(
            x: -4 * CGFloat(roll),
            y: -2 * CGFloat(pitch)
        )
    }
}

extension Int {
    func format(f: String) -> String {
        return String(format: "%\(f)d", self)
    }
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

extension FloatingPoint {
    func transition(_ a: Self, _ b: Self) -> Self {
        let aWeight = 1 - self
        let bWeight = self
        return a * aWeight + b * bWeight
    }
}

extension Double {
    static var pi½: Double { return Double.pi / 2 }
}
