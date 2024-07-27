import Foundation
import UIKit

class MovieThumbnailCell: UITableViewCell {

    // MARK: - UI Properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var languageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var movieThumbnailView: UIImageView = {
        let image = UIImage(systemName: "person.crop.square")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var movieDetailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var movieThumbnailDetailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 25
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Configuration

    func configure(movieThumbnail: MovieThumbnail) {
        titleLabel.text = movieThumbnail.title
        languageLabel.text = "Language: " + movieThumbnail.language
        yearLabel.text = "Year: " + movieThumbnail.year
        
        setup()
    }

    func updateThumbnailImage(image: UIImage?) {
        DispatchQueue.main.async {
            if image != nil {
                self.movieThumbnailView.image = image
                self.movieThumbnailView.layoutIfNeeded()
            }
        }
    }

    // MARK: - Private Helpers

    private func setup() {
        contentView.addSubview(movieThumbnailDetailsStackView)
        movieThumbnailDetailsStackView.addArrangedSubview(movieThumbnailView)
        movieThumbnailDetailsStackView.addArrangedSubview(movieDetailsStackView)

        movieDetailsStackView.addArrangedSubview(titleLabel)
        movieDetailsStackView.addArrangedSubview(languageLabel)
        movieDetailsStackView.addArrangedSubview(yearLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            movieThumbnailDetailsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            movieThumbnailDetailsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            movieThumbnailDetailsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            movieThumbnailDetailsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            movieThumbnailView.widthAnchor.constraint(equalToConstant: 75),
            movieThumbnailView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
}
