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
    @IBOutlet weak var sliderX: UISlider!
    @IBOutlet weak var sliderY: UISlider!

    let manager = CMMotionManager()
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        glossLabel.matt = .color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        glossLabel.gloss = .color(#colorLiteral(red: 0.8510238528, green: 0.8510238528, blue: 0.8510238528, alpha: 1))
        glossLabel.initialOffset = CGPoint(x: -22, y: -200)
        glossLabel.setNeedsLayout()
        glossLabel.setNeedsDisplay()

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

    func update() {
        glossLabel.initialOffset = CGPoint(
            x: CGFloat(sliderX.value),
            y: CGFloat(sliderY.value)
        )

        guard let motion = manager.deviceMotion?.gravity else { return }

        glossLabel.offset = CGPoint(
            x: -220 * CGFloat(motion.x),
            y: 120 * CGFloat(motion.y)
        )
    }
}
