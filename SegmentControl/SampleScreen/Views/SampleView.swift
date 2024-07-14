//
//  SampleView.swift
//  SegmentControl
//
//  Created by Alexander Borisov on 14.07.2024.
//

import UIKit

class SampleView: UIView {

    private enum State {
        case bottom
        case middle
        case top
    }

    private let cardView = CardView()

    private var cardViewHeightAnchor: NSLayoutConstraint?

    private var state: State = .bottom {
        didSet {
            updateCardViewState()
        }
    }

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample view made at Coffee & Code :3"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    private let kittyImageView: UIImageView = {
        let image = UIImage(named: "kitty")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        cardView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cardView)
        addSubview(descriptionLabel)
        addSubview(kittyImageView)

        backgroundColor = .systemGray

        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor),

            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            descriptionLabel.bottomAnchor.constraint(equalTo: cardView.topAnchor, constant: -24),

            kittyImageView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            kittyImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
        ])
        cardViewHeightAnchor = cardView.heightAnchor.constraint(equalToConstant: 400)
        cardViewHeightAnchor?.priority = .defaultHigh
        cardViewHeightAnchor?.isActive = true

        cardView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SampleView: CardViewDelegate {

    func didDragCardView(_ offset: CGFloat) {
        cardViewHeightAnchor?.constant += offset
    }

    func didEndDraggingCardView(_ velocity: CGFloat) {
        let ratio = cardView.bounds.height / bounds.height
        let velocity = -velocity

        switch state {
        case .bottom:
            let toMiddleWithVelocity = velocity >= 250
            let toMiddleByFraction = ratio > 0.3

            if toMiddleWithVelocity || toMiddleByFraction {
                state = .middle
            } else {
                state = .bottom
            }
        case .middle:
            let toTopWithVelocity = velocity >= 250
            let toTopByFraction = ratio > 0.5
            let toBottomWithVelocity = velocity <= -250

            if toTopWithVelocity || toTopByFraction {
                state = .top
            } else if toBottomWithVelocity {
                state = .bottom
            } else {
                state = .middle
            }
        case .top:
            let toMiddleWithVelocity = velocity <= -250
            let toMiddleByFraction = ratio < 0.8

            if toMiddleWithVelocity || toMiddleByFraction {
                state = .middle
            } else {
                state = .top
            }
        }
    }

    private func updateCardViewState() {
        switch state {
        case .top:
            cardViewHeightAnchor?.constant = bounds.height * 0.8
        case .middle:
            cardViewHeightAnchor?.constant = bounds.height * 0.5
        case .bottom:
            cardViewHeightAnchor?.constant = bounds.height * 0.15
        }

        UIView.animate(withDuration: 0.15) {
            self.layoutIfNeeded()
        }
    }
}
