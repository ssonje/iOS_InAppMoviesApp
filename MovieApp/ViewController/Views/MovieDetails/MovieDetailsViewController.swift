import Foundation
import UIKit

/// View controller for displaying details about the movie
class MovieDetailsViewController: UIViewController {

    // MARK: - UI Properties

    private lazy var movieDetailsView: UIView = {
        let view = MovieDetailsView(
            movie: movie,
            movieThumbnailsViewModel: movieThumbnailsViewModel,
            frame: view.frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Data Properties

    private var movie: Movie
    private let movieThumbnailsViewModel: MovieThumbnailsViewModel

    // MARK: - Init

    init(movie: Movie, movieThumbnailsViewModel: MovieThumbnailsViewModel) {
        self.movie = movie
        self.movieThumbnailsViewModel = movieThumbnailsViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(movieDetailsView)
        setupConstraints()
    }

    // MARK: - Private Helpers

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            movieDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieDetailsView.topAnchor.constraint(equalTo: view.topAnchor),
            movieDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
