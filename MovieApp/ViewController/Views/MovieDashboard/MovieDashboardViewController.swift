import Foundation
import UIKit

class MovieDashboardViewController: UIViewController {

    // MARK: - Data Properties

    internal let moviesViewModel: MoviesViewModel
    internal let movieCategoryViewModel: MovieCategoryViewModel
    internal let movieThumbnailsViewModel: MovieThumbnailsViewModel

    private let networkService: NetworkServiceProtocol

    // MARK: - UI Properties

    internal lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView.init(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()

    internal lazy var searchView: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search movies by title/genre/actor/director"
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }()

    // MARK: - Constants

    internal static let movieCategoryCellID = "MovieCategoryCellID"
    internal static let movieGenericTypeCellID_Years = "MovieGenericTypeCellID_Years"
    internal static let movieGenericTypeCellID_Genres = "MovieGenericTypeCellID_Genres"
    internal static let movieGenericTypeCellID_Directors = "MovieGenericTypeCellID_Directors"
    internal static let movieGenericTypeCellID_Actors = "MovieGenericTypeCellID_Actors"
    internal static let movieThumbnailCellID = "MovieThumbnailCellID"

    // MARK: - Init

    init() {
        networkService = NetworkService()
        moviesViewModel = MoviesViewModel(networkService: networkService)
        movieCategoryViewModel = MovieCategoryViewModel(networkService: networkService)
        movieThumbnailsViewModel = MovieThumbnailsViewModel()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchRequiredData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchView.searchBar.isHidden = false
    }

    // MARK: - Private Helpers

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(spinner)
        title = "Movie Database"
        setupTableView()
        setupConstraints()
    }

    private func setupTableView() {
        // Add search bar as a table view header
        tableView.tableHeaderView = searchView.searchBar

        // Register required cells
        tableView.register(MovieCategoryCell.self, forCellReuseIdentifier: Self.movieCategoryCellID)
        tableView.register(MovieGenericTypeCell.self, forCellReuseIdentifier: Self.movieGenericTypeCellID_Years)
        tableView.register(MovieGenericTypeCell.self, forCellReuseIdentifier: Self.movieGenericTypeCellID_Genres)
        tableView.register(MovieGenericTypeCell.self, forCellReuseIdentifier: Self.movieGenericTypeCellID_Directors)
        tableView.register(MovieGenericTypeCell.self, forCellReuseIdentifier: Self.movieGenericTypeCellID_Actors)
        tableView.register(MovieThumbnailCell.self, forCellReuseIdentifier: Self.movieThumbnailCellID)

        // Setup delegates
        tableView.dataSource = self
        tableView.delegate = self
        searchView.searchBar.delegate = self
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Setup table view constraints
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Setup spinner view constraints
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func fetchRequiredData() {
        spinner.startAnimating()
        moviesViewModel.fetchMovies() { [weak self] in
            guard let self = self else {
                print("[MovieDashboardViewController] Self should be non nil")
                return
            }

            let movieThumbnails = self.moviesViewModel.getMovieThumbnailsForMovies()
            self.movieThumbnailsViewModel.setMovieThumbnails(movieThumbnails: movieThumbnails)
            self.updateViewIfNeeded()
        }

        movieCategoryViewModel.fetchMovieCategories() { [weak self] in
            guard let self = self else {
                print("[MovieDashboardViewController] Self should be non nil")
                return
            }

            self.updateViewIfNeeded()
        }
    }

    private func updateViewIfNeeded() {
        tableView.reloadData()
        spinner.stopAnimating()
    }
}
