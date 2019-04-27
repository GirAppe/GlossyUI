//
//  Common.swift
//  GlossyUI
//
//  Created by Andrzej Michnia on 27/04/2019.
//

import UIKit

public enum Surface {
    case color(UIColor)
    case image(UIImage)
    case pattern(UIImage)
}

public struct Reflex {
    public let image: UIImage?
    public let spacing: CGFloat
    public let style: Style

    public init(image: UIImage? = nil, style: Style = .grid3x3, spacing: CGFloat = 0) {
        self.image = image
        self.spacing = spacing
        self.style = style
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
