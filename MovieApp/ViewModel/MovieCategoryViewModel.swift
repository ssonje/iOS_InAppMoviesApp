import Foundation

class MovieCategoryViewModel {

    // MARK: - Private Properties

    private let networkService: NetworkServiceProtocol
    private var movieCategories = [MovieCategory]()

    // MARK: - Init

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    // MARK: - API's

    func fetchMovieCategories(completion: @escaping () -> ()) {
        networkService.fetchMovieCategories() { result in
            switch result {
            case .success(let movieCategories):
                self.movieCategories = movieCategories
                completion()
            case .failure(let error):
                print("[MovieCategoryViewModel] While processing the json data, got an error: \(error.localizedDescription)")
            }
        }
    }

    func updateMovieCategory(at index: Int, with newMovieCategory: MovieCategory) {
        movieCategories[index] = newMovieCategory
    }

    // MARK: - Table View Data Source API's

    func numberOfMovieCategories() -> Int {
        if movieCategories.isEmpty {
            return 0
        }
        return movieCategories.count

    }

    func movieCategoriesForRow(at section: Int) -> MovieCategory {
        return movieCategories[section]
    }

    func isAllMoviesCell(indexPath: IndexPath) -> Bool {
        return (indexPath.row == (movieCategories.count - 1))
    }
}
