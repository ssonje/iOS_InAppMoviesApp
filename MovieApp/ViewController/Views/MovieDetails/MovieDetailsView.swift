import Foundation
import UIKit

/// View for displaying details about the movie
class MovieDetailsView: UIView {

    // MARK: - UI Properties

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var scrollingStackView: UIStackView = {
        let stackView = createStackView()
        setup(stackView: stackView, axis: .vertical)
        return stackView
    }()

    private lazy var movieDetailsStackView: UIStackView = {
        return createStackView()
    }()

    private lazy var movieResearchHeaderLabel: UILabel = {
        let label = createLabel(with: "Movie Details")
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()

    private lazy var moviePosterView: UIImageView = {
        let image = UIImage(systemName: "person.crop.square")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var showRatingsStackView: UIStackView = {
        let stackView = createStackView()
        stackView.axis = .vertical
        stackView.spacing = 25
        return stackView
    }()

    private lazy var showRatingsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Show Ratings", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openRatingsOptions), for: .touchUpInside)
        return button
    }()

    private lazy var showRatingsTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Constants

    internal static let movieShowRatingsCellID = "MovieShowRatingsCellID"

    // MARK: - Data Properties

    internal let movie: Movie
    private let movieThumbnailsViewModel: MovieThumbnailsViewModel

    var image: UIImage?

    // MARK: - Init

    required public init(movie: Movie, movieThumbnailsViewModel: MovieThumbnailsViewModel, frame: CGRect) {
        self.movie = movie
        self.movieThumbnailsViewModel = movieThumbnailsViewModel
        super.init(frame: frame)
        scrollView.delegate = self
        getImage()
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Helpers

    private func setupView() {
        setupScrollViewAndScrollingStackView()
        setupMovieDetailsStackView()
        setupShowRatingsTableView()
        setupConstraints()
    }

    private func setupScrollViewAndScrollingStackView() {
        addSubview(scrollView)
        scrollView.addSubview(scrollingStackView)
        scrollingStackView.addArrangedSubview(movieResearchHeaderLabel)
        scrollingStackView.addArrangedSubview(movieDetailsStackView)
    }

    private func setupMovieDetailsStackView() {
        // Setup main stack view
        setup(stackView: movieDetailsStackView, axis: .vertical)

        let movieTitleStackView = createStackView(staticText: "Title", dynamicText: movie.title)
        let movieYearStackView = createStackView(staticText: "Year", dynamicText: movie.year)
        let movieReleasedStackView = createStackView(staticText: "Released", dynamicText: movie.released)
        let movieRuntimeStackView = createStackView(staticText: "Runtime", dynamicText: movie.runtime)
        let movieGenreStackView = createStackView(staticText: "Genre", dynamicText: movie.genre)
        let movieDirectorStackView = createStackView(staticText: "Director", dynamicText: movie.director)
        let movieWriterStackView = createStackView(staticText: "Writer", dynamicText: movie.writer)
        let movieActorsStackView = createStackView(staticText: "Actors", dynamicText: movie.actors)
        let moviePlotStackView = createStackView(staticText: "Plot", dynamicText: movie.plot)
        let movieLanguageStackView = createStackView(staticText: "Language", dynamicText: movie.language)
        let movieCountryStackView = createStackView(staticText: "Country", dynamicText: movie.country)
        let movieAwardsStackView = createStackView(staticText: "Awards", dynamicText: movie.awards)
        let movieTypeStackView = createStackView(staticText: "Type", dynamicText: movie.type)
        let movieDVDStackView = createStackView(staticText: "DVD", dynamicText: movie.dvd)

        // Setup all the labels stack view
        let stackViews = [
            movieTitleStackView,
            movieYearStackView,
            movieReleasedStackView,
            movieRuntimeStackView,
            movieGenreStackView,
            movieDirectorStackView,
            movieWriterStackView,
            movieActorsStackView,
            moviePlotStackView,
            movieLanguageStackView,
            movieCountryStackView,
            movieAwardsStackView,
            movieTypeStackView,
            movieDVDStackView]
        for stackView in stackViews {
            setup(stackView: stackView, axis: .horizontal)
        }

        movieDetailsStackView.addArrangedSubview(moviePosterView)
        movieDetailsStackView.addArrangedSubview(movieTitleStackView)
        movieDetailsStackView.addArrangedSubview(movieYearStackView)
        movieDetailsStackView.addArrangedSubview(movieReleasedStackView)
        movieDetailsStackView.addArrangedSubview(movieRuntimeStackView)
        movieDetailsStackView.addArrangedSubview(movieGenreStackView)
        movieDetailsStackView.addArrangedSubview(movieDirectorStackView)
        movieDetailsStackView.addArrangedSubview(movieWriterStackView)
        movieDetailsStackView.addArrangedSubview(movieActorsStackView)
        movieDetailsStackView.addArrangedSubview(moviePlotStackView)
        movieDetailsStackView.addArrangedSubview(movieLanguageStackView)
        movieDetailsStackView.addArrangedSubview(movieCountryStackView)
        movieDetailsStackView.addArrangedSubview(movieAwardsStackView)
        movieDetailsStackView.addArrangedSubview(movieTypeStackView)
        movieDetailsStackView.addArrangedSubview(movieDVDStackView)
        movieDetailsStackView.addArrangedSubview(showRatingsStackView)

        // Setup showRatingsStackView
        showRatingsStackView.addArrangedSubview(showRatingsButton)
        showRatingsStackView.addArrangedSubview(showRatingsTableView)
    }

    private func setupShowRatingsTableView() {
        showRatingsTableView.isHidden = true
        showRatingsTableView.register(MovieShowRatingsCell.self, forCellReuseIdentifier: Self.movieShowRatingsCellID)

        // Setup delegates
        showRatingsTableView.dataSource = self
        showRatingsTableView.delegate = self
    }

    private func createStackView(staticText: String? = nil, dynamicText: String? = nil) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false

        if let staticText = staticText {
            let staticLabel = createLabel(with: staticText)
            staticLabel.numberOfLines = 0
            staticLabel.translatesAutoresizingMaskIntoConstraints = false
            staticLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            stackView.addArrangedSubview(staticLabel)
        }

        if let dynamicText = dynamicText {
            let dynamicLabel = createLabel(with: dynamicText)
            dynamicLabel.numberOfLines = 0
            dynamicLabel.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(dynamicLabel)
        }

        return stackView
    }


    private func setup(stackView: UIStackView, axis: NSLayoutConstraint.Axis) {
        stackView.axis = axis
        stackView.spacing = axis == .vertical ? 10 : 25
    }

    private func createLabel(with text: String? = nil) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = text
        return label
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),

            scrollingStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollingStackView.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            scrollingStackView.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
            scrollingStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            moviePosterView.widthAnchor.constraint(equalToConstant: 150),
            moviePosterView.heightAnchor.constraint(equalToConstant: 250),

            showRatingsTableView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func getImage() {
        movieThumbnailsViewModel.movieThumbnailImage(for: movie.poster) { [weak self] image in
            guard let self = self, let image = image else {
                print("[MovieDetailsView] Self shouldn't be nil.")
                return
            }

            DispatchQueue.main.async {
                self.moviePosterView.image = image
                self.setNeedsDisplay()
            }
        }
    }

    @objc
    private func openRatingsOptions() {
        if showRatingsTableView.isHidden {
            showRatingsButton.setTitle("Hide Ratings", for: .normal)
            showRatingsTableView.isHidden = false
            showRatingsTableView.reloadData()
        } else {
            showRatingsButton.setTitle("Show Ratings", for: .normal)
            showRatingsTableView.isHidden = true
        }
        scrollView.layoutIfNeeded()
    }
}
