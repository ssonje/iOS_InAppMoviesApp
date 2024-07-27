import Foundation
import UIKit

class MovieShowRatingsCell: UITableViewCell {

    // MARK: - UI Properties

    private lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 25
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Configuration

    func configure(rating: Rating) {
        sourceLabel.text = rating.source
        valueLabel.text = rating.value
        setup()
    }

    // MARK: - Private Helpers

    private func setup() {
        contentView.addSubview(ratingStackView)
        ratingStackView.addArrangedSubview(sourceLabel)
        ratingStackView.addArrangedSubview(valueLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            ratingStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            ratingStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
            ratingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            ratingStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            valueLabel.widthAnchor.constraint(equalToConstant: 75)
        ])
    }
}
