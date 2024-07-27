import Foundation

protocol NetworkServiceProtocol {

    func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> Void)

    func fetchMovieCategories(completion: @escaping (Result<[MovieCategory], Error>) -> Void)
}
