
import Foundation
import UIKit

// MARK: - UITableViewDelegate

extension MovieDashboardViewController: UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return movieCategoryViewModel.numberOfMovieCategories()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if moviesViewModel.getShouldShowMoviesForSearchText() {
            let movieDetailsViewController = MovieDetailsViewController(
                movie: moviesViewModel.getSearchedMovies()[indexPath.row],
                movieThumbnailsViewModel: movieThumbnailsViewModel)
            searchView.searchBar.isHidden = true
            navigationController?.pushViewController(movieDetailsViewController, animated: true)
            return
        }

        let movieCategories = movieCategoryViewModel.numberOfMovieCategories()
        for index in 0..<movieCategories {
            if indexPath.section == index {
                if indexPath.row == 0 {
                    var movieCategory = movieCategoryViewModel.movieCategoriesForRow(at: indexPath.section)
                    if movieCategory.open {
                        movieCategory.open = false
                        movieCategoryViewModel.updateMovieCategory(at: indexPath.section, with: movieCategory)
                    } else {
                        movieCategory.open = true
                        movieCategoryViewModel.updateMovieCategory(at: indexPath.section, with: movieCategory)
                    }
                } else {
                    if moviesViewModel.getShouldShowMoviesForGenericTypeCell() {
                        let movieCategory = movieCategoryViewModel.movieCategoriesForRow(at: indexPath.section)
                        let filteredMovies = moviesViewModel.getMovieThumbnailsForFilteredMovies()
                        let firstRange = 0...moviesViewModel.getSelectedRow()
                        if movieCategory.open
                            && moviesViewModel.getShouldShowMoviesForGenericTypeCell()
                            && !firstRange.contains(indexPath.row)
                            && indexPath.row - moviesViewModel.getSelectedRow() - 1 < filteredMovies.count {
                            switch indexPath.section {
                            case 0, 1, 2, 3:
                                let movieDetailsViewController = MovieDetailsViewController(
                                    movie: moviesViewModel.getFilteredMovies()[indexPath.row - moviesViewModel.getSelectedRow() - 1],
                                    movieThumbnailsViewModel: movieThumbnailsViewModel)
                                navigationController?.pushViewController(movieDetailsViewController, animated: true)
                            default:
                                navigationController?.pushViewController(UIViewController(), animated: true)
                            }
                        } else {
                            moviesViewModel.toggleShouldShowMoviesForGenericTypeCell()
                        }
                    } else {
                        switch indexPath.section {
                        case 0:
                            let searchText = moviesViewModel.getUniqueYears()[indexPath.row - 1]
                            getMoviesAfterTappingOnTheGenericCell(searchText: searchText, indexPath: indexPath)
                        case 1:
                            let searchText = moviesViewModel.getUniqueGenres()[indexPath.row - 1]
                            getMoviesAfterTappingOnTheGenericCell(searchText: searchText, indexPath: indexPath)
                        case 2:
                            let searchText = moviesViewModel.getUniqueDirectors()[indexPath.row - 1]
                            getMoviesAfterTappingOnTheGenericCell(searchText: searchText, indexPath: indexPath)
                        case 3:
                            let searchText = moviesViewModel.getUniqueActors()[indexPath.row - 1]
                            getMoviesAfterTappingOnTheGenericCell(searchText: searchText, indexPath: indexPath)
                        default:
                            let movieDetailsViewController = MovieDetailsViewController(
                                movie: moviesViewModel.movieForRow(at: indexPath),
                                movieThumbnailsViewModel: movieThumbnailsViewModel)
                            navigationController?.pushViewController(movieDetailsViewController, animated: true)
                        }
                    }
                }
            } else {
                var movieCategory = movieCategoryViewModel.movieCategoriesForRow(at: index)
                if movieCategory.open {
                    movieCategory.open = false
                    movieCategoryViewModel.updateMovieCategory(at: index, with: movieCategory)

                    if moviesViewModel.getShouldShowMoviesForGenericTypeCell() {
                        moviesViewModel.toggleShouldShowMoviesForGenericTypeCell()
                    }
                }
            }
        }
        let sections = IndexSet.init(integersIn: 0..<movieCategories)
        tableView.reloadSections(sections, with: .none)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0, 1, 2, 3:
            let movieCategory = movieCategoryViewModel.movieCategoriesForRow(at: indexPath.section)
            let filteredMovies = moviesViewModel.getMovieThumbnailsForFilteredMovies()
            let firstRange = 0...moviesViewModel.getSelectedRow()
            if movieCategory.open
                && moviesViewModel.getShouldShowMoviesForGenericTypeCell()
                && !firstRange.contains(indexPath.row)
                && indexPath.row - moviesViewModel.getSelectedRow() - 1 < filteredMovies.count {
                let currentMovieThumbnailRow = indexPath.row - moviesViewModel.getSelectedRow() - 1
                let currentMovie = moviesViewModel.getFilteredMovies()[currentMovieThumbnailRow]
                movieThumbnailsViewModel.movieThumbnailImage(for: currentMovie.poster) { image in
                    DispatchQueue.main.async {
                        if let cell = tableView.cellForRow(at: indexPath) as? MovieThumbnailCell {
                            cell.updateThumbnailImage(image: image)
                        }
                    }
                }
            }
        case 4:
            movieThumbnailsViewModel.movieThumbnailImage(at: indexPath) { image in
                DispatchQueue.main.async {
                    if let cell = tableView.cellForRow(at: indexPath) as? MovieThumbnailCell {
                        cell.updateThumbnailImage(image: image)
                    }
                }
            }
        default:
            break
        }
    }

    // MARK: - Private Helpers

    private func getMoviesAfterTappingOnTheGenericCell(searchText: String, indexPath: IndexPath) {
        moviesViewModel.fetchMoviesAfterTappingOnGenricTypeCell(searchText: searchText, section: indexPath.section)
        moviesViewModel.toggleShouldShowMoviesForGenericTypeCell()
        moviesViewModel.updateCurrentSelectedRow(at: indexPath)
    }
}
