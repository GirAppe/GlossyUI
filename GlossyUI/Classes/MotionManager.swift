//
//  MotionManager.swift
//  GlossyUI
//
//  Created by Andrzej Michnia on 31/05/2019.
//  Copyright (c) 2019 GirAppe Studio. All rights reserved.
//

import Foundation
import CoreMotion
import UIKit

final internal class MotionManager {

    // MARK: - Shared instance

    static var shared = MotionManager()

    // MARK: - Properties

    let manager = CMMotionManager()
    var timer: Timer?
    let state = State()

    private var registrations = NSHashTable<Offsetable>(options: .weakMemory)
    private lazy var setupIfNeeded: VoidCompletion = { setup(); return {} }()

    // MARK: - Lifecycle

    private init() { /* empty on purpose */ }

    deinit {
        timer?.invalidate()
        manager.isDeviceMotionActive ? manager.stopAccelerometerUpdates() : ()
    }

    // MARK: - Setup

    private func setup() {
        guard manager.isDeviceMotionAvailable else { return }

        manager.startDeviceMotionUpdates()

        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            self?.update()
        }
        dlog("Motion manager setup done")
    }

    var lastAttitude: CMAttitude? = nil
    var lastOrientation: UIInterfaceOrientation = .portrait

    private func update() {
        guard let attitude = manager.deviceMotion?.attitude else { return }

        state.update(with: attitude)

        registrations.allObjects.forEach { component in
            component.offset = state.offset
        }
    }

    // MARK: - Actions

    func register(_ observer: Offsetable) {
        setupIfNeeded()
        registrations.add(observer)
        dlog("Registered observer, count \(registrations.allObjects.count)")
    }
}

// MARK: - Manager state and position

extension MotionManager {

    enum Position {
        case down
        case front
        case up
    }

    class State {

        var offset: CGPoint { return CGPoint(x: roll, y: pitch) }
        var roll: CGFloat = 0   // x
        var pitch: CGFloat = 0  // y

        private var position = Position.down
        private let ε = 0.4
        private var baseθ = 0.0
        private var baseψ = 0.0
        private var baseRoll = 0.0
        private var lastRoll = 0.0

        func update(with attitude: CMAttitude) {
            let w = attitude.quaternion.w
            let x = attitude.quaternion.x
            let y = attitude.quaternion.y
            let z = attitude.quaternion.z

            let sinp = +2.0 * (w * y - z * x)
            let sinr_cosp = +2.0 * (w * x + y * z)
            let cosr_cosp = +1.0 - 2.0 * (x * x + y * y)
            let siny_cosp = +2.0 * (w * z + x * y)
            let cosy_cosp = +1.0 - 2.0 * (y * y + z * z)

            var ϕ: Double = 0   // p
            var θ: Double = 0   // r
            var ψ: Double = 0   // y

            let orientation = UIApplication.shared.statusBarOrientation
            switch orientation {
            case .portrait:
                ϕ = atan2(sinr_cosp, cosr_cosp)
                θ = fabs(sinp) >= 1 ? copysign(.pi½, sinp) : asin(sinp)
                ψ = atan2(siny_cosp, cosy_cosp)
            case .landscapeLeft:
                θ = atan2(sinr_cosp, cosr_cosp)
                ϕ = fabs(sinp) >= 1 ? copysign(.pi½, sinp) : asin(sinp)
                ψ = atan2(siny_cosp, cosy_cosp)
            case .landscapeRight:
                θ = atan2(sinr_cosp, cosr_cosp)
                ϕ = -1 * (fabs(sinp) >= 1 ? copysign(.pi½, sinp) : asin(sinp))
                ψ = atan2(siny_cosp, cosy_cosp)
            default:
                break
            }

            let newPosition: Position = {
                switch ϕ {
                case let n where n < .pi½ - ε: return .down
                case let n where n > .pi½ + ε: return .up
                default: return .front
                }
            }()

            if position != newPosition {
                baseθ = θ
                baseψ = ψ
                position = newPosition
                baseRoll = lastRoll
                dlog("\(newPosition)")
            }

            let pitch = ϕ / .pi
            let roll: Double = {
                switch position {
                case .down:
                    return  1.0 * (θ - baseθ) / .pi
                case .front:
                    return -0.7 * (ψ - baseψ) / .pi
                case .up:
                    return -1.0 * (θ - baseθ) / .pi
                }
            }() + baseRoll

            lastRoll = roll

            self.roll = -4 * CGFloat(roll)
            self.pitch = -2 * CGFloat(pitch)
        }
    }
}
