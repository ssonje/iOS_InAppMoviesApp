import Foundation
import UIKit

class MoviesViewModel {

    // MARK: - Properties

    var shouldShowMoviesForSearchText: Bool = false
    var shouldShowMoviesForGenericTypeCell: Bool = false

    // MARK: - Private Properties

    private let networkService: NetworkServiceProtocol
    private var movies = [Movie]()
    private var searchedMovies = [Movie]()
    private var filteredMovies = [Movie]()
    private var selectedRow: Int = 0
    private var selectedSection: Int = 0

    // MARK: - Init

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    // MARK: - API's

    func fetchMovies(completion: @escaping () -> ()) {
        networkService.fetchMovies() { result in
            switch result {
            case .success(let movies):
                self.movies = movies
                completion()
            case .failure(let error):
                print("[MoviesViewModel] While processing the json data, got an error: \(error.localizedDescription)")
            }
        }
    }

    func getMovies() -> [Movie] {
        return movies
    }

    func getUniqueYears() -> [String] {
        var set = Set<String>()
        return movies.compactMap { movie in
            if set.firstIndex(of: movie.year) == nil {
                set.insert(movie.year)
                return movie.year
            }

            return nil
        }
    }

    func getUniqueGenres() -> [String] {
        var set = Set<String>()
        return movies.flatMap { movie -> [String] in
            var currentGenres = movie.genre.components(separatedBy: ",")
            currentGenres = currentGenres.compactMap { currentGenre -> String? in
                let trimmedCurrentGenre = currentGenre.trimmingCharacters(in: .whitespaces)
                if set.firstIndex(of: trimmedCurrentGenre) == nil {
                    set.insert(trimmedCurrentGenre)
                    return trimmedCurrentGenre
                }
                return nil
            }
            return currentGenres
        }
    }

    func getUniqueDirectors() -> [String] {
        var set = Set<String>()
        return movies.flatMap { movie -> [String] in
            var currentDirectors = movie.director.components(separatedBy: ",")
            currentDirectors = currentDirectors.compactMap { currentDirector -> String? in
                if set.firstIndex(of: currentDirector) == nil {
                    set.insert(currentDirector)
                    return currentDirector
                }
                return nil
            }
            return currentDirectors
        }
    }

    func getUniqueActors() -> [String] {
        var set = Set<String>()
        return movies.flatMap { movie -> [String] in
            var currentActors = movie.actors.components(separatedBy: ",")
            currentActors = currentActors.compactMap { currentActor -> String? in
                if set.firstIndex(of: currentActor) == nil {
                    set.insert(currentActor)
                    return currentActor
                }
                return nil
            }
            return currentActors
        }
    }

    func getMovieThumbnailsForMovies() -> [MovieThumbnail] {
        return movies.map { movie in
            return MovieThumbnail(
                title: movie.title,
                year: movie.year,
                language: movie.language,
                thumbnailURL: movie.poster)
        }
    }

    func getMovieThumbnailsForSearchedMovies() -> [MovieThumbnail] {
        return searchedMovies.map { movie in
            return MovieThumbnail(
                title: movie.title,
                year: movie.year,
                language: movie.language,
                thumbnailURL: movie.poster)
        }
    }

    func toggleShouldShowMoviesForSearchText() {
        shouldShowMoviesForSearchText.toggle()
    }

    func fetchQueryResult(searchText: String) {
        var searchedMovies = [Movie]()

        // Search movies as per the title
        let moviesAsPerTitle = self.movies.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        searchedMovies.append(contentsOf: moviesAsPerTitle)

        // Search movies as per the genre
        let moviesAsPerGenre = self.movies.filter { $0.genre.lowercased().contains(searchText.lowercased()) }
        searchedMovies.append(contentsOf: moviesAsPerGenre)

        // Search movies as per the actors
        let moviesAsPerActor = self.movies.filter { $0.actors.lowercased().contains(searchText.lowercased()) }
        searchedMovies.append(contentsOf: moviesAsPerActor)

        // Search movies as per the directors
        let moviesAsPerDirector = self.movies.filter { $0.director.lowercased().contains(searchText.lowercased()) }
        searchedMovies.append(contentsOf: moviesAsPerDirector)

        self.searchedMovies = searchedMovies
    }

    func getSearchedMovies() -> [Movie] {
        return searchedMovies
    }

    func toggleShouldShowMoviesForGenericTypeCell() {
        shouldShowMoviesForGenericTypeCell.toggle()
    }

    func fetchMoviesAfterTappingOnGenricTypeCell(searchText: String, section: Int) {
        var filteredMovies = [Movie]()

        switch section {
        case 0:
            let moviesAsPerYears = self.movies.filter { $0.year.lowercased().contains(searchText.lowercased()) }
            filteredMovies = moviesAsPerYears

        case 1:
            let moviesAsPerGenres = self.movies.filter { $0.genre.lowercased().contains(searchText.lowercased()) }
            filteredMovies = moviesAsPerGenres

        case 2:
            let moviesAsPerDirectors = self.movies.filter { $0.director.lowercased().contains(searchText.lowercased()) }
            filteredMovies = moviesAsPerDirectors

        case 3:
            let moviesAsPerActors = self.movies.filter { $0.actors.lowercased().contains(searchText.lowercased()) }
            filteredMovies = moviesAsPerActors

        default:
            break
        }

        self.filteredMovies = filteredMovies
    }

    func getFilteredMovies() -> [Movie] {
        return filteredMovies
    }

    func getMovieThumbnailsForFilteredMovies() -> [MovieThumbnail] {
        return filteredMovies.map { movie in
            return MovieThumbnail(
                title: movie.title,
                year: movie.year,
                language: movie.language,
                thumbnailURL: movie.poster)
        }
    }

    func updateCurrentSelectedRow(at indexPath: IndexPath) {
        selectedRow = indexPath.row
        selectedSection = indexPath.section
    }

    func getSelectedRow() -> Int {
        return selectedRow
    }

    func getSelectedSection() -> Int {
        return selectedSection
    }

    // MARK: - Table View Data Source API's

    func numberOfMoviesInSection() -> Int {
        if movies.isEmpty {
            return 0
        }
        return movies.count
    }

    func movieForRow(at indexPath: IndexPath) -> Movie {
        return movies[indexPath.row]
    }

    func movieForRow(at index: Int) -> Movie {
        return movies[index]
    }
}
