import Foundation
import UIKit

// MARK: - UITableViewDataSource

extension MovieDashboardViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if moviesViewModel.shouldShowMoviesForSearchText {
            switch section {
            case 4:
                return moviesViewModel.getMovieThumbnailsForSearchedMovies().count
            default:
                return 0
            }
        } else {
            let movieCategory = movieCategoryViewModel.movieCategoriesForRow(at: section)
            switch section {
            case 0:
                return getTotalMoviesForUniqueYears(for: section, movieCategory: movieCategory)
            case 1:
                return getTotalMoviesForUniqueGenres(for: section, movieCategory: movieCategory)
            case 2:
                return getTotalMoviesForUniqueDirectors(for: section, movieCategory: movieCategory)
            case 3:
                return getTotalMoviesForUniqueActors(for: section, movieCategory: movieCategory)
            case 4:
                return getTotalMoviesForAllMovies(for: section, movieCategory: movieCategory)
            default:
                return 1
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 && !moviesViewModel.shouldShowMoviesForSearchText {
            return getMovieCategoryCell(at: indexPath)
        } else {
            if shouldShowMoviesForGenericTypeCell(at: indexPath) {
                switch indexPath.section {
                case 0, 1, 2, 3:
                    let currentDataRow = indexPath.row - moviesViewModel.getSelectedRow() - 1
                    let filteredMovieThumbnails = moviesViewModel.getMovieThumbnailsForFilteredMovies()
                    return getCellForMovieThumbnail(at: indexPath, with: currentDataRow, filteredMovieThumbnails: filteredMovieThumbnails)
                default:
                    return UITableViewCell()
                }
            } else {
                let currentDataRow: Int = getCurrentDataRow(at: indexPath)
                switch indexPath.section {
                case 0:
                    return getCellForUniqueYears(at: indexPath, with: currentDataRow)
                case 1:
                    return getCellForUniqueGenres(at: indexPath, with: currentDataRow)
                case 2:
                    return getCellForUniqueDirectors(at: indexPath, with: currentDataRow)
                case 3:
                    return getCellForUniqueActors(at: indexPath, with: currentDataRow)
                case 4:
                    return getCellForMovieThumbnail(at: indexPath)
                default:
                    return UITableViewCell()
                }
            }
        }
    }

    // MARK: - Private Helpers for numberOfRowsInSection

    private func getTotalMoviesForUniqueYears(for section: Int, movieCategory: MovieCategory) -> Int {
        let movieCategory = movieCategoryViewModel.movieCategoriesForRow(at: section)
        var totalMovies = 1
        if movieCategory.open {
            totalMovies += moviesViewModel.getUniqueYears().count

            if moviesViewModel.shouldShowMoviesForGenericTypeCell {
                totalMovies += moviesViewModel.getFilteredMovies().count
            }
        }
        return totalMovies
    }

    private func getTotalMoviesForUniqueGenres(for section: Int, movieCategory: MovieCategory) -> Int {
        let movieCategory = movieCategoryViewModel.movieCategoriesForRow(at: section)
        var totalMovies = 1
        if movieCategory.open {
            totalMovies += moviesViewModel.getUniqueGenres().count

            if moviesViewModel.shouldShowMoviesForGenericTypeCell {
                totalMovies += moviesViewModel.getFilteredMovies().count
            }
        }
        return totalMovies
    }

    private func getTotalMoviesForUniqueDirectors(for section: Int, movieCategory: MovieCategory) -> Int {
        let movieCategory = movieCategoryViewModel.movieCategoriesForRow(at: section)
        var totalMovies = 1
        if movieCategory.open {
            totalMovies += moviesViewModel.getUniqueDirectors().count

            if moviesViewModel.shouldShowMoviesForGenericTypeCell {
                totalMovies += moviesViewModel.getFilteredMovies().count
            }
        }
        return totalMovies
    }

    private func getTotalMoviesForUniqueActors(for section: Int, movieCategory: MovieCategory) -> Int {
        let movieCategory = movieCategoryViewModel.movieCategoriesForRow(at: section)
        var totalMovies = 1
        if movieCategory.open {
            totalMovies += moviesViewModel.getUniqueActors().count

            if moviesViewModel.shouldShowMoviesForGenericTypeCell {
                totalMovies += moviesViewModel.getFilteredMovies().count
            }
        }
        return totalMovies
    }

    private func getTotalMoviesForAllMovies(for section: Int, movieCategory: MovieCategory) -> Int {
        return movieCategory.open ? moviesViewModel.getMovieThumbnailsForMovies().count : 1
    }

    // MARK: - Private Helpers for cellForRowAt

    private func shouldShowMoviesForGenericTypeCell(at indexPath: IndexPath) -> Bool {
        let movieCategory = movieCategoryViewModel.movieCategoriesForRow(at: indexPath.section)
        let filteredMovieThumbnails = moviesViewModel.getMovieThumbnailsForFilteredMovies()
        let firstRange = 0...moviesViewModel.getSelectedRow()
        return movieCategory.open
            && moviesViewModel.shouldShowMoviesForGenericTypeCell
            && !firstRange.contains(indexPath.row)
            && indexPath.row - moviesViewModel.getSelectedRow() - 1 < filteredMovieThumbnails.count
    }

    private func getCurrentDataRow(at indexPath: IndexPath) -> Int {
        let filteredMovies = moviesViewModel.getMovieThumbnailsForFilteredMovies()
        let firstRange = 0...moviesViewModel.getSelectedRow()
        let currentDataRow: Int
        if moviesViewModel.shouldShowMoviesForGenericTypeCell {
            currentDataRow = firstRange.contains(indexPath.row)
            ? indexPath.row - 1
            : indexPath.row - filteredMovies.count - 1
        } else {
            currentDataRow = indexPath.row - 1
        }
        return currentDataRow
    }

    private func getCellForUniqueYears(at indexPath: IndexPath, with currentDataRow: Int) -> MovieGenericTypeCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.movieGenericTypeCellID_Years, for: indexPath) as! MovieGenericTypeCell
        cell.configure(data: moviesViewModel.getUniqueYears()[currentDataRow])
        return cell
    }

    private func getCellForUniqueGenres(at indexPath: IndexPath, with currentDataRow: Int) -> MovieGenericTypeCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.movieGenericTypeCellID_Genres, for: indexPath) as! MovieGenericTypeCell
        cell.configure(data: moviesViewModel.getUniqueGenres()[currentDataRow])
        return cell
    }

    private func getCellForUniqueDirectors(at indexPath: IndexPath, with currentDataRow: Int) -> MovieGenericTypeCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.movieGenericTypeCellID_Directors, for: indexPath) as! MovieGenericTypeCell
        cell.configure(data: moviesViewModel.getUniqueDirectors()[currentDataRow])
        return cell
    }

    private func getCellForUniqueActors(at indexPath: IndexPath, with currentDataRow: Int) -> MovieGenericTypeCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.movieGenericTypeCellID_Actors, for: indexPath) as! MovieGenericTypeCell
        cell.configure(data: moviesViewModel.getUniqueActors()[currentDataRow])
        return cell
    }

    private func getCellForMovieThumbnail(at indexPath: IndexPath) -> MovieThumbnailCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.movieThumbnailCellID, for: indexPath) as! MovieThumbnailCell
        let movieThumbnail: MovieThumbnail = moviesViewModel.shouldShowMoviesForSearchText
        ? moviesViewModel.getMovieThumbnailsForSearchedMovies()[indexPath.row]
        : movieThumbnailsViewModel.movieThumbnailForRow(at: indexPath)
        cell.configure(movieThumbnail: movieThumbnail)
        return cell
    }

    private func getCellForMovieThumbnail(at indexPath: IndexPath, with currentDataRow: Int, filteredMovieThumbnails: [MovieThumbnail]) -> MovieThumbnailCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.movieThumbnailCellID, for: indexPath) as! MovieThumbnailCell
        let movieThumbnail = filteredMovieThumbnails[currentDataRow]
        cell.configure(movieThumbnail: movieThumbnail)
        return cell
    }

    private func getMovieCategoryCell(at indexPath: IndexPath) -> MovieCategoryCell {
        let movieCategory = movieCategoryViewModel.movieCategoriesForRow(at: indexPath.section)
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.movieCategoryCellID, for: indexPath) as! MovieCategoryCell
        cell.configure(movieCategory: movieCategory)
        return cell
    }
}
