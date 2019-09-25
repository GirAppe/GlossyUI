//
//  Common.swift
//  GlossyUI
//
//  Created by Andrzej Michnia on 27/04/2019.
//  Copyright (c) 2019 GirAppe Studio. All rights reserved.
//

import UIKit

/// Surface description. Use it to control what would be shown as matt/gloss
///
/// - color: fill with color
/// - image: fill with image
/// - pattern: fill with pattern
public enum Surface {
    case color(UIColor)
    case image(UIImage)
    case pattern(UIImage)

    public static func imageNamed(_ name: String, in bundle: Bundle = Bundle.main) -> Surface {
        return Surface.image(UIImage(named: name, in: bundle, compatibleWith: nil) ?? UIImage())
    }

    public static func patternNamed(_ name: String, in bundle: Bundle = Bundle.main) -> Surface {
        return Surface.pattern(UIImage(named: name, in: bundle, compatibleWith: nil) ?? UIImage())
    }
}

/// Use it to modify reflex style, whenever you need custom reflections
public struct Reflex {

    public let image: UIImage?
    public let spacing: CGFloat
    public let style: Style

    public init(image: UIImage? = nil, spacing: CGFloat = 0, style: Style = .grid3x3) {
        self.image = image
        self.spacing = spacing
        self.style = style
    }

    public static func with(image: UIImage) -> Reflex {
        return Reflex(image: image)
    }

    public func with(image: UIImage) -> Reflex {
        return Reflex(image: image, spacing: spacing, style: style)
    }

    public static func with(imageNamed name: String, in bundle: Bundle = Bundle.main) -> Reflex {
        return Reflex(image: UIImage(named: name, in: bundle, compatibleWith: nil) ?? UIImage())
    }

    public func with(imageNamed name: String, in bundle: Bundle = Bundle.main) -> Reflex {
        let image = UIImage(named: name, in: bundle, compatibleWith: nil) ?? UIImage()
        return Reflex(image: image, spacing: spacing, style: style)
    }

    public func with(spacing: CGFloat) -> Reflex {
        return Reflex(image: image, spacing: spacing, style: style)
    }

    public func with(style: Style) -> Reflex {
        return Reflex(image: image, spacing: spacing, style: style)
    }

    public enum Style {
        case grid1x1
        case grid3x3

        var count: Int {
            switch self {
            case .grid1x1: return 1 * 1
            case .grid3x3: return 3 * 3
            }
        }
        var rowCount: Int {
            switch self {
            case .grid1x1: return 1
            case .grid3x3: return 3
            }
        }
    }
}
