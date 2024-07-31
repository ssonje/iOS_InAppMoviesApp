
import Foundation
import UIKit

// MARK: - UITableViewDelegate

extension MovieDashboardViewController: UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return movieCategoryViewModel.numberOfMovieCategories()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if moviesViewModel.shouldShowMoviesForSearchText {
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
                    updateMovieCategoryWhenTapOnIt(at: indexPath)
                } else {
                    if moviesViewModel.shouldShowMoviesForGenericTypeCell {
                        if shouldShowMoviesForGenericTypeCell(for: indexPath) {
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
                            didSelectYearsSectionCell(at: indexPath)
                        case 1:
                            didSelectGenresSectionCell(at: indexPath)
                        case 2:
                            didSelectDirectorsSectionCell(at: indexPath)
                        case 3:
                            didSelectActorsSectionCell(at: indexPath)
                        default:
                            didSelectAllmoviesSectionCell(at: indexPath)
                        }
                    }
                }
            } else {
                updateMovieCategoryWhenTapOnOtherCategoryOrItsCells(at: index)
            }
        }

        // Update required sections
        // TODO: We can optimise this by updating the section on which the user is tapping on
        let sections = IndexSet.init(integersIn: 0..<movieCategories)
        tableView.reloadSections(sections, with: .none)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0, 1, 2, 3:
            if shouldShowMoviesForGenericTypeCell(for: indexPath) {
                fetchMovieThubnailForCategoriesOtherThanAllMovies(tableView, at: indexPath)
            }
        case 4:
            fetchMovieThubnailForAllMovies(tableView, at: indexPath)
        default:
            break
        }
    }

    // MARK: - Private Helpers

    private func shouldShowMoviesForGenericTypeCell(for indexPath: IndexPath) -> Bool {
        let movieCategory = movieCategoryViewModel.movieCategoriesForRow(at: indexPath.section)
        let filteredMovieThumbnails = moviesViewModel.getMovieThumbnailsForFilteredMovies()
        let firstRange = 0...moviesViewModel.getSelectedRow()
        return movieCategory.open
            && moviesViewModel.shouldShowMoviesForGenericTypeCell
            && !firstRange.contains(indexPath.row)
            && indexPath.row - moviesViewModel.getSelectedRow() - 1 < filteredMovieThumbnails.count
    }

    private func getMoviesAfterTappingOnTheGenericCell(searchText: String, indexPath: IndexPath) {
        moviesViewModel.fetchMoviesAfterTappingOnGenricTypeCell(searchText: searchText, section: indexPath.section)
        moviesViewModel.toggleShouldShowMoviesForGenericTypeCell()
        moviesViewModel.updateCurrentSelectedRow(at: indexPath)
    }

    private func fetchMovieThubnailForCategoriesOtherThanAllMovies(_ tableView: UITableView, at indexPath: IndexPath) {
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

    private func fetchMovieThubnailForAllMovies(_ tableView: UITableView, at indexPath: IndexPath) {
        movieThumbnailsViewModel.movieThumbnailImage(at: indexPath) { image in
            DispatchQueue.main.async {
                if let cell = tableView.cellForRow(at: indexPath) as? MovieThumbnailCell {
                    cell.updateThumbnailImage(image: image)
                }
            }
        }
    }

    private func didSelectYearsSectionCell(at indexPath: IndexPath) {
        let searchText = moviesViewModel.getUniqueYears()[indexPath.row - 1]
        getMoviesAfterTappingOnTheGenericCell(searchText: searchText, indexPath: indexPath)
    }

    private func didSelectGenresSectionCell(at indexPath: IndexPath) {
        let searchText = moviesViewModel.getUniqueGenres()[indexPath.row - 1]
        getMoviesAfterTappingOnTheGenericCell(searchText: searchText, indexPath: indexPath)
    }

    private func didSelectDirectorsSectionCell(at indexPath: IndexPath) {
        let searchText = moviesViewModel.getUniqueDirectors()[indexPath.row - 1]
        getMoviesAfterTappingOnTheGenericCell(searchText: searchText, indexPath: indexPath)
    }

    private func didSelectActorsSectionCell(at indexPath: IndexPath) {
        let searchText = moviesViewModel.getUniqueActors()[indexPath.row - 1]
        getMoviesAfterTappingOnTheGenericCell(searchText: searchText, indexPath: indexPath)
    }

    private func didSelectAllmoviesSectionCell(at indexPath: IndexPath) {
        let movieDetailsViewController = MovieDetailsViewController(
            movie: moviesViewModel.movieForRow(at: indexPath),
            movieThumbnailsViewModel: movieThumbnailsViewModel)
        navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }

    private func updateMovieCategoryWhenTapOnOtherCategoryOrItsCells(at index: Int) {
        var movieCategory = movieCategoryViewModel.movieCategoriesForRow(at: index)
        if movieCategory.open {
            movieCategory.open = false
            movieCategoryViewModel.updateMovieCategory(at: index, with: movieCategory)

            if moviesViewModel.shouldShowMoviesForGenericTypeCell {
                moviesViewModel.toggleShouldShowMoviesForGenericTypeCell()
            }
        }
    }

    private func updateMovieCategoryWhenTapOnIt(at indexPath: IndexPath) {
        var movieCategory = movieCategoryViewModel.movieCategoriesForRow(at: indexPath.section)
        if movieCategory.open {
            movieCategory.open = false
            movieCategoryViewModel.updateMovieCategory(at: indexPath.section, with: movieCategory)
        } else {
            movieCategory.open = true
            movieCategoryViewModel.updateMovieCategory(at: indexPath.section, with: movieCategory)
        }
    }
}
