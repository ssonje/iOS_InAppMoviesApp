import Foundation
import UIKit

class MovieGenericTypeCell: UITableViewCell {

    // MARK: - UI Properties

    private lazy var containerView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()

    private lazy var movieGenericTypeDetailView: MovieGenericTypeDetailView = {
        let view = MovieGenericTypeDetailView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Configuration

    func configure(data: String) {
        movieGenericTypeDetailView.configure(text: data)
        setup()
    }

    // MARK: - Private Helpers

    private func setup() {
        contentView.addSubview(containerView)
        containerView.addArrangedSubview(movieGenericTypeDetailView)

        // Setup constraints
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
