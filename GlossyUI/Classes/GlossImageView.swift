//
//  GlossImageView.swift
//  GlossyUI
//
//  Created by Andrzej Michnia on 29/04/2019.
//  Copyright (c) 2019 GirAppe Studio. All rights reserved.
//

import UIKit

open class GlossImageView: UIImageView, Offsetable {

    // MARK: - Public properties

    open var reflex: Reflex = Reflex() {
        didSet { reflexView.build(with: reflex) }
    }
    open var gloss: Surface = .color(.white) {
        didSet { updateGlow() }
    }
    open var matt: Surface = .color(.black) {
        didSet { updateGlow() }
    }
    open var shape: Surface = .color(.clear) {
        didSet { updateGlow() }
    }
    open var offset: CGPoint = .zero {
        didSet { update() }
    }
    open var initialOffset: CGPoint = .zero {
        didSet { update() }
    }

    // MARK: - Overrides

    open override var contentMode: UIView.ContentMode {
        get { return super.contentMode }
        set {
            super.contentMode = newValue
            glossView.contentMode = newValue
            shapeView.contentMode = newValue
        }
    }

    // MARK: - Hierarchy

    private let packageView = UIView()
    private let glossView = UIImageView()
    private let reflexMaskView = UIView()
    private let reflexView = ReflexView()
    private let shapeMaskView = UIView()
    private let shapeView = UIImageView()

    // MARK: - Private Properties

    private var centerX: NSLayoutConstraint?
    private var centerY: NSLayoutConstraint?
    private lazy var buildOnce: () -> Void = {
        build()
        return {}
    }()

    // MARK: - Lifecycle

    override open func layoutSubviews() {
        super.layoutSubviews()
        buildOnce()
    }

    // MARK: - Setup

    private func update() {
        let size = CGSize(
            width: reflexView.bounds.width + reflex.spacing,
            height: reflexView.bounds.height + reflex.spacing
        )

        var aspiringOffsetX = (offset.x + initialOffset.x) * size.width
        var aspiringOffsetY = (offset.y + initialOffset.y) * size.height

        guard size.width > 0, size.height > 0 else { return }

        while aspiringOffsetX < -size.width {
            aspiringOffsetX += size.width
        }

        while aspiringOffsetY < -size.height {
            aspiringOffsetY += size.height
        }

        while aspiringOffsetX > size.width {
            aspiringOffsetX -= size.width
        }

        while aspiringOffsetY > size.height {
            aspiringOffsetY -= size.height
        }
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        centerX?.constant = aspiringOffsetX
        centerY?.constant = aspiringOffsetY
        setNeedsLayout()
        setNeedsDisplay()
        CATransaction.commit()
    }

    private func updateGlow() {
        switch gloss {
        case let .color(gloss):
            glossView.image = nil
            glossView.backgroundColor = gloss
        case let .image(image):
            glossView.image = image
            glossView.backgroundColor = .clear
        case let .pattern(pattern):
            glossView.image = nil
            glossView.backgroundColor = UIColor(patternImage: pattern)
        }

        switch matt {
        case let .color(matt):
            self.image = nil
            self.backgroundColor = matt
        case let .image(image):
            self.image = image
            self.backgroundColor = .clear
        case let .pattern(pattern):
            self.image = nil
            self.backgroundColor = UIColor(patternImage: pattern)
        }

        switch shape {
        case let .color(shape):
            shapeView.image = nil
            shapeView.backgroundColor = shape
        case let .image(image):
            shapeView.image = image
            shapeView.backgroundColor = .clear
        case let .pattern(pattern):
            shapeView.image = nil
            shapeView.backgroundColor = UIColor(patternImage: pattern)
        }
    }

    private func build() {
        dlog("Build \(self)...")
        glossView.contentMode = contentMode
        shapeView.contentMode = contentMode

        packageView.translatesAutoresizingMaskIntoConstraints = false
        glossView.translatesAutoresizingMaskIntoConstraints = false
        reflexView.translatesAutoresizingMaskIntoConstraints = false
        shapeView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(packageView)
        packageView.addSubview(glossView)
        addSubview(reflexMaskView)
        reflexMaskView.addSubview(reflexView)
        addSubview(shapeMaskView)
        shapeMaskView.addSubview(shapeView)

        reflexMaskView.frame = self.bounds
        shapeMaskView.frame = self.bounds

        NSLayoutConstraint.activate([
            // Package
            packageView.topAnchor.constraint(equalTo: topAnchor),
            packageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            packageView.leftAnchor.constraint(equalTo: leftAnchor),
            packageView.rightAnchor.constraint(equalTo: rightAnchor),

            glossView.topAnchor.constraint(equalTo: topAnchor),
            glossView.bottomAnchor.constraint(equalTo: bottomAnchor),
            glossView.leftAnchor.constraint(equalTo: leftAnchor),
            glossView.rightAnchor.constraint(equalTo: rightAnchor),

            reflexView.widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor),
            reflexView.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor),

            shapeView.topAnchor.constraint(equalTo: topAnchor),
            shapeView.bottomAnchor.constraint(equalTo: bottomAnchor),
            shapeView.leftAnchor.constraint(equalTo: leftAnchor),
            shapeView.rightAnchor.constraint(equalTo: rightAnchor),
            ])

        centerX = reflexView.centerXAnchor.constraint(equalTo: centerXAnchor)
        centerY = reflexView.centerYAnchor.constraint(equalTo: centerYAnchor)
        centerX?.isActive = true
        centerY?.isActive = true

        reflexView.build(with: reflex)

        glossView.mask = reflexMaskView
        packageView.mask = shapeMaskView

        dlog("Done")
        // Prepare starting (not initial!) offset and register for updates
        self.offset = MotionManager.shared.state.offset
        MotionManager.shared.register(self)
    }
}
