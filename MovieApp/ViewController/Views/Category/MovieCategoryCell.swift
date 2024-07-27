import Foundation
import UIKit

class MovieCategoryCell: UITableViewCell {

    // MARK: - UI Properties

    private lazy var containerView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()

    private lazy var movieCategoryView: MovieCategoryView = {
        let view = MovieCategoryView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()


    // MARK: - Configuration

    func configure(movieCategory: MovieCategory) {
        movieCategoryView.configure(movieCategory: movieCategory)
        setupView()
    }

    // MARK: - Private Helpers

    private func setupView() {
        contentView.addSubview(containerView)
        containerView.addArrangedSubview(movieCategoryView)

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
