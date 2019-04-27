//
//  ReflexView.swift
//  GlossyUI
//
//  Created by Andrzej Michnia on 27/04/2019.
//

import UIKit

class ReflexView: UIView {

    func defaultReflexImage() -> UIImage {
        let podMainBundle = Bundle(for: ReflexView.self)
        let path = podMainBundle.path(forResource: "GlossyUI", ofType: "bundle")!
        let bundle = Bundle(path: path)
        return UIImage(named: "blink1", in: bundle, compatibleWith: nil)!
    }

    func build(with reflex: Reflex) {
        // Cleanup
        subviews.forEach { $0.removeFromSuperview() }
        clipsToBounds = false

        // Prepare
        let reflexImage = reflex.image ?? defaultReflexImage()
        let spacing = reflex.spacing

        let imageView = UIImageView(image: reflexImage)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .vertical)

        addSubview(imageView)

        switch reflex.style {
        case .grid1x1:
            break
        case .grid3x3:
            let count = reflex.style.count
            let views = (1...count-1).map { _ in buildImageView(image: reflexImage) }
            views.forEach { view in
                addSubview(view)
                NSLayoutConstraint.activate([
                    view.widthAnchor.constraint(equalTo: imageView.widthAnchor),
                    view.heightAnchor.constraint(equalTo: imageView.heightAnchor),
                ])
            }
            // Top Left
            NSLayoutConstraint.activate([
                views[0].rightAnchor.constraint(equalTo: imageView.leftAnchor, constant: -spacing),
                views[0].bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -spacing)
            ])
            // Top
            NSLayoutConstraint.activate([
                views[1].centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
                views[1].bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -spacing)
            ])
            // Top Right
            NSLayoutConstraint.activate([
                views[2].leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: spacing),
                views[2].bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -spacing)
            ])
            // Left
            NSLayoutConstraint.activate([
                views[3].rightAnchor.constraint(equalTo: imageView.leftAnchor, constant: -spacing),
                views[3].centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
            ])
            // Right
            NSLayoutConstraint.activate([
                views[4].leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: spacing),
                views[4].centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
            ])
            // Bottom Left
            NSLayoutConstraint.activate([
                views[5].rightAnchor.constraint(equalTo: imageView.leftAnchor, constant: -spacing),
                views[5].topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: spacing)
            ])
            // Bottom
            NSLayoutConstraint.activate([
                views[6].centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
                views[6].topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: spacing)
            ])
            // Bottom Right
            NSLayoutConstraint.activate([
                views[7].leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: spacing),
                views[7].topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: spacing)
            ])
        }

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        let width = imageView.widthAnchor.constraint(equalToConstant: reflexImage.size.width)
        width.priority = UILayoutPriority(999)
        width.isActive = true

        let height = imageView.heightAnchor.constraint(equalToConstant: reflexImage.size.height)
        height.priority = UILayoutPriority(999)
        height.isActive = true
    }

    private func buildRow(from queue: inout [UIImageView], count: Int, spacing: CGFloat) -> UIStackView {
        let range = 0..<count
        let row = queue[range].map { $0 }
        queue.removeSubrange(range)

        let stackRow = UIStackView(arrangedSubviews: row)
        stackRow.spacing = spacing
        stackRow.axis = .horizontal
        stackRow.distribution = .fillEqually
        stackRow.translatesAutoresizingMaskIntoConstraints = false
        return stackRow
    }

    private func buildImageView(image: UIImage) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}

