//
//  DodoWallpaperViewController.swift
//  GlossyUI_Example
//
//  Created by Andrzej Michnia on 22/09/2019.
//  Copyright © 2019 GirAppe Studio. All rights reserved.
//

import UIKit
import GlossyUI

class DodoWallpaperViewController: UIViewController {

    @IBOutlet weak var glossImageView: GlossImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let mattImage = UIImage(named: "dodo-wallpaper-matt")!
        let glossImage = UIImage(named: "dodo-wallpaper-gloss")!
        let reflexImage = UIImage(named: "dodo-wallpaper-reflex")!

        glossImageView.matt = .pattern(mattImage)
        glossImageView.gloss = .pattern(glossImage)
        glossImageView.reflex = Reflex
            .with(image: reflexImage)
            .with(spacing: 480)
        glossImageView.shape = .color(.white)
        glossImageView.initialOffset = CGPoint(x: 0, y: -800)
    }
}
