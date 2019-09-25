//
//  GlossLabel.swift
//  Pods
//
//  Created by Andrzej Michnia on 27/04/2019.
//  Copyright (c) 2019 GirAppe Studio. All rights reserved.
//

import UIKit

open class GlossLabel: UILabel, Offsetable {

    // MARK: - Public properties

    /// Strength of the effect between 0 and 1, where 0 means matt only and 1 is normal (default).
    open var effectStrength: CGFloat = 1.0
    /// Reflex to use. By default it uses built-in reflex image
    open var reflex: Reflex = Reflex(spacing: -20) {
        didSet { reflexView.build(with: reflex) }
    }
    /// Glossy (front) surface
    open var gloss: Surface = .color(.white) {
        didSet { updateGlow() }
    }
    /// Matt (background) surface
    open var matt: Surface = .color(.black) {
        didSet { updateGlow() }
    }
    /// Initial offset of the reflex. This can be modified even if motion & scroll effects are on.
    open var initialOffset: CGPoint = .zero {
        didSet { update() }
    }
    /// Reflex offst within the view. It is strongly reccomended to not update it manually,
    /// unless motion & scroll effects are off
    open var offset: CGPoint = .zero {
        didSet { update() }
    }

    // MARK: - Overrides

    override open var font: UIFont! {
        get { return super.font }
        set {
            globalShapeView.font = newValue
            super.font = newValue
        }
    }
    override open var text: String? {
        get { return super.text }
        set {
            globalShapeView.text = newValue
            super.text = newValue
        }
    }
    override open var textAlignment: NSTextAlignment {
        get { return super.textAlignment }
        set {
            super.textAlignment = newValue
            globalShapeView.textAlignment = newValue
        }
    }
    override open var textColor: UIColor! {
        get { return mattView.backgroundColor }
        set {
            super.textColor = .clear
            mattView.backgroundColor = newValue
        }
    }

    // MARK: - Hierarchy

    private let packageView = UIView()
    private let mattView = UIImageView()
    private let glossView = UIImageView()
    private let reflexMaskView = UIView()
    private let reflexView = ReflexView()
    private let globalShapeMaskView = UIView()
    private let globalShapeView = UILabel()

    // MARK: - Private properties

    private var useScrollingEffect: Bool = true

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

    public func setScrollingEffect(enabled: Bool) {
        useScrollingEffect = enabled

    }

    public func setEffect(power: CGFloat) {

    }

    // MARK: - Updates and build

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

        centerX?.constant = aspiringOffsetX
        centerY?.constant = aspiringOffsetY
        setNeedsLayout()
        setNeedsDisplay()
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
        case let .color(gloss):
            mattView.image = nil
            mattView.backgroundColor = gloss
        case let .image(image):
            mattView.image = image
            mattView.backgroundColor = .clear
        case let .pattern(pattern):
            mattView.image = nil
            mattView.backgroundColor = UIColor(patternImage: pattern)
        }

        glossView.alpha = effectStrength
    }

    private func build() {
        dlog("Build \(self)...")
        super.textColor = .clear

        glossView.contentMode = .scaleAspectFill
        mattView.contentMode = .scaleAspectFill

        packageView.translatesAutoresizingMaskIntoConstraints = false
        mattView.translatesAutoresizingMaskIntoConstraints = false
        glossView.translatesAutoresizingMaskIntoConstraints = false
        reflexView.translatesAutoresizingMaskIntoConstraints = false
        globalShapeView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(packageView)
        packageView.addSubview(mattView)
        packageView.addSubview(glossView)
        addSubview(reflexMaskView)
        reflexMaskView.addSubview(reflexView)
        addSubview(globalShapeMaskView)
        globalShapeMaskView.addSubview(globalShapeView)

        reflexMaskView.frame = self.bounds
        globalShapeMaskView.frame = self.bounds

        NSLayoutConstraint.activate([
            // Package
            packageView.topAnchor.constraint(equalTo: topAnchor),
            packageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            packageView.leftAnchor.constraint(equalTo: leftAnchor),
            packageView.rightAnchor.constraint(equalTo: rightAnchor),

            mattView.topAnchor.constraint(equalTo: topAnchor),
            mattView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mattView.leftAnchor.constraint(equalTo: leftAnchor),
            mattView.rightAnchor.constraint(equalTo: rightAnchor),

            glossView.topAnchor.constraint(equalTo: topAnchor),
            glossView.bottomAnchor.constraint(equalTo: bottomAnchor),
            glossView.leftAnchor.constraint(equalTo: leftAnchor),
            glossView.rightAnchor.constraint(equalTo: rightAnchor),

            reflexView.widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor),
            reflexView.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor),

            globalShapeView.topAnchor.constraint(equalTo: topAnchor),
            globalShapeView.bottomAnchor.constraint(equalTo: bottomAnchor),
            globalShapeView.leftAnchor.constraint(equalTo: leftAnchor),
            globalShapeView.rightAnchor.constraint(equalTo: rightAnchor),
        ])

        centerX = reflexView.centerXAnchor.constraint(equalTo: centerXAnchor)
        centerY = reflexView.centerYAnchor.constraint(equalTo: centerYAnchor)
        centerX?.isActive = true
        centerY?.isActive = true

        reflexView.build(with: reflex)

        globalShapeView.textColor = .black
        globalShapeView.text = text
        globalShapeView.textAlignment = textAlignment
        globalShapeView.font = font

        glossView.mask = reflexMaskView
        packageView.mask = globalShapeMaskView

        dlog("Done")
        // Prepare starting (not initial!) offset and register for updates
        self.offset = MotionManager.shared.state.offset
        MotionManager.shared.register(self)
    }
}
