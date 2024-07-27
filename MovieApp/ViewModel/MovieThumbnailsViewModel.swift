import Foundation
import UIKit

class MovieThumbnailsViewModel {

    // MARK: - Private Properties

    private var movieThumbnails = [MovieThumbnail]()

    private lazy var imageLoader: ImageLoader = {
        let imageLoader = ImageLoader()
        return imageLoader
    }()

    // MARK: - API's

    func setMovieThumbnails(movieThumbnails: [MovieThumbnail]) {
        self.movieThumbnails = movieThumbnails
    }

    func movieThumbnailImage(at indexPath: IndexPath, completion: @escaping (UIImage?) -> ()) {
        let movieThumbnail = movieThumbnailForRow(at: indexPath)
        movieThumbnailImage(for: movieThumbnail.thumbnailURL, completion: completion)
    }

    func movieThumbnailImage(for imageURL: URL?, completion: @escaping (UIImage?) -> ()) {
        guard let imageURL = imageURL else {
            print("[MoviesViewModel] imageURL shouldn't be nil.")
            return
        }
        imageLoader.loadImage(with: imageURL, completion: completion)
    }

    // MARK: - Table View Data Source API's

    func numberOfMovieThumbnailsInSection() -> Int {
        if movieThumbnails.isEmpty {
            return 0
        }
        return movieThumbnails.count
    }

    func movieThumbnailForRow(at indexPath: IndexPath) -> MovieThumbnail {
        return movieThumbnails[indexPath.row]
    }

    func movieThumbnailForRow(at index: Int) -> MovieThumbnail {
        return movieThumbnails[index]
    }
}
