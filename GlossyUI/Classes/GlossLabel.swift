//
//  GlossLabel.swift
//  Pods
//
//  Created by Andrzej Michnia on 27/04/2019.
//

import UIKit

public class GlossLabel: UILabel {

    override public var font: UIFont! {
        get { return super.font }
        set {
            globalShapeView.font = newValue
            super.font = newValue
        }
    }
    override public var text: String? {
        get { return super.text }
        set {
            globalShapeView.text = newValue
            super.text = newValue
        }
    }
    override public var textAlignment: NSTextAlignment {
        get { return super.textAlignment }
        set {
            super.textAlignment = newValue
            globalShapeView.textAlignment = newValue
        }
    }
    override public var textColor: UIColor! {
        get { return mattView.backgroundColor }
        set {
            super.textColor = .clear
            mattView.backgroundColor = newValue
        }
    }

    public var reflex: Reflex = Reflex() {
        didSet { reflexView.build(with: reflex) }
    }
    public var gloss: Surface = .color(.white) {
        didSet { updateGlow() }
    }
    public var matt: Surface = .color(.black) {
        didSet { updateGlow() }
    }
    public var offset: CGPoint = .zero {
        didSet { update() }
    }
    public var initialOffset: CGPoint = .zero {
        didSet { update() }
    }

    // Hierarchy
    private let packageView = UIView()
    private let mattView = UIImageView()
    private let glossView = UIImageView()
    private let reflexMaskView = UIView()
    private let reflexView = ReflexView()
    private let globalShapeMaskView = UIView()
    private let globalShapeView = UILabel()

    private var centerX: NSLayoutConstraint?
    private var centerY: NSLayoutConstraint?

    private lazy var buildOnce: () -> Void = {
        build()
        return {}
    }()

    public override func layoutSubviews() {
        super.layoutSubviews()
        buildOnce()
    }

    private func update() {
        centerX?.constant = offset.x + initialOffset.x
        centerY?.constant = offset.y + initialOffset.y
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
    }

    private func build() {
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
    }
}

public class GlossImageView: UIImageView {

    public override var contentMode: UIViewContentMode {
        get { return super.contentMode }
        set {
            super.contentMode = newValue
            glossView.contentMode = newValue
            shapeView.contentMode = newValue
        }
    }

    public var reflex: Reflex = Reflex() {
        didSet { reflexView.build(with: reflex) }
    }
    public var gloss: Surface = .color(.white) {
        didSet { updateGlow() }
    }
    public var matt: Surface = .color(.black) {
        didSet { updateGlow() }
    }
    public var shape: Surface = .color(.clear) {
        didSet { updateGlow() }
    }
    public var offset: CGPoint = .zero {
        didSet { update() }
    }
    public var initialOffset: CGPoint = .zero {
        didSet { update() }
    }

    // Hierarchy
    private let packageView = UIView()
        private let glossView = UIImageView()
        private let reflexMaskView = UIView()
        private let reflexView = ReflexView()
    private let shapeMaskView = UIView()
    private let shapeView = UIImageView()

    private var centerX: NSLayoutConstraint?
    private var centerY: NSLayoutConstraint?

    private lazy var buildOnce: () -> Void = {
        build()
        return {}
    }()

    public override func layoutSubviews() {
        super.layoutSubviews()
        buildOnce()
    }

    private func update() {
        centerX?.constant = offset.x + initialOffset.x
        centerY?.constant = offset.y + initialOffset.y
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
    }
}
