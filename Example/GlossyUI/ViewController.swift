//
//  ViewController.swift
//  GlossyUI
//
//  Created by Andrzej Michnia on 04/27/2019.
//  Copyright (c) 2019 Andrzej Michnia. All rights reserved.
//

import UIKit
import GlossyUI

class ViewController: UIViewController {

    @IBOutlet weak var glossLabel: GlossLabel!
    @IBOutlet weak var glossImageView: GlossImageView!
    @IBOutlet weak var sliderX: UISlider?
    @IBOutlet weak var sliderY: UISlider?

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

        sliderX?.value = Float(glossLabel.initialOffset.x)
        sliderY?.value = Float(glossLabel.initialOffset.y)
    }

    @IBAction func sliderXupdated(_ sender: UISlider) {
        update()
    }

    @IBAction func sliderYupdated(_ sender: UISlider) {
        update()
    }

    func update() {
        glossLabel.initialOffset = CGPoint(
            x: CGFloat(sliderX?.value ?? 0),
            y: CGFloat(sliderY?.value ?? 0)
        )
        glossImageView.initialOffset = CGPoint(
            x: CGFloat(sliderX?.value ?? 0),
            y: CGFloat(sliderY?.value ?? 0)
        )
    }
}
