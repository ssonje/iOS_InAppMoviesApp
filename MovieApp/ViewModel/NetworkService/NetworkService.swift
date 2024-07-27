import Foundation

class NetworkService: NetworkServiceProtocol {
    
    func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        if let url = Bundle.main.url(forResource: "movies", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let movies = try JSONDecoder().decode([Movie].self, from: data)
                completion(.success(movies))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func fetchMovieCategories(completion: @escaping (Result<[MovieCategory], Error>) -> Void) {
        if let url = Bundle.main.url(forResource: "movieCategories", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let movieCategories = try JSONDecoder().decode([MovieCategory].self, from: data)
                completion(.success(movieCategories))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
