//
//  CardView.swift
//  SegmentControl
//
//  Created by Alexander Borisov on 14.07.2024.
//

import UIKit

protocol CardViewDelegate: AnyObject {
    func didDragCardView(_ offset: CGFloat)
    func didEndDraggingCardView(_ velocity: CGFloat)
}

final class CardView: UIView {

    private let barView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        return view
    }()

    private lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(didDrag(_:)))
        return gesture
    }()

    weak var delegate: CardViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        barView.layer.cornerRadius = barView.bounds.height / 2
    }

    private func configureUI() {
        addSubview(barView)
        
        NSLayoutConstraint.activate([
            barView.centerXAnchor.constraint(equalTo: centerXAnchor),
            barView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            barView.widthAnchor.constraint(equalToConstant: 44),
            barView.heightAnchor.constraint(equalToConstant: 8)
        ])

        layer.cornerRadius = 24
        backgroundColor = .systemBackground

        addGestureRecognizer(panGesture)
    }

    @objc private func didDrag(_ r: UIPanGestureRecognizer) {
        let offset = r.translation(in: r.view).y
        delegate?.didDragCardView(-offset)

        if case .ended = r.state {
            delegate?.didEndDraggingCardView(r.velocity(in: r.view).y)
        }

        r.setTranslation(.zero, in: r.view)
    }
}
