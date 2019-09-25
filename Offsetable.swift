//
//  Offsetable.swift
//  GlossyUI
//
//  Created by Andrzej Michnia on 22/09/2019.
//  Copyright (c) 2019 GirAppe Studio. All rights reserved.
//

import UIKit

// MARK: - Observers protocol

@objc protocol Offsetable: class {

    var offset: CGPoint { get set }
}

extension Offsetable where Self: UIView {

    
}
