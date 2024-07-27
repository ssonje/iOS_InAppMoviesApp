import Foundation
import UIKit

class MovieCategoryView: UIView {

    // MARK: - UI Properties

    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var imageView: UIImageView = {
        let image = UIImage(systemName: "arrow.right")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 25
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Configuration

    func configure(movieCategory: MovieCategory) {
        categoryLabel.text = movieCategory.category
        setup()
    }

    // MARK: - Private Helpers

    private func setup() {
        addSubview(stackView)
        stackView.addArrangedSubview(categoryLabel)
        stackView.addArrangedSubview(imageView)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),

            imageView.widthAnchor.constraint(equalToConstant: 15)
        ])
    }
}
