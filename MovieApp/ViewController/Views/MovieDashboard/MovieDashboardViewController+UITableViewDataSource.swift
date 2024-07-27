import Foundation
import UIKit

// MARK: - UITableViewDataSource

extension MovieDashboardViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let movieCategory = movieCategoryViewModel.movieCategoriesForRow(at: section)
        if moviesViewModel.getShouldShowMoviesForSearchText() {
            switch section {
            case 4:
                return moviesViewModel.getMovieThumbnailsForSearchedMovies().count
            default:
                return 0
            }
        } else {
            switch section {
            case 0:
                var totalMovies = movieCategory.open ? moviesViewModel.getUniqueYears().count + 1 : 1
                totalMovies += movieCategory.open && moviesViewModel.getShouldShowMoviesForGenericTypeCell()
                ? moviesViewModel.getFilteredMovies().count
                : 0
                return totalMovies
            case 1:
                var totalMovies = movieCategory.open ? moviesViewModel.getUniqueGenres().count + 1 : 1
                totalMovies += movieCategory.open && moviesViewModel.getShouldShowMoviesForGenericTypeCell()
                ? moviesViewModel.getFilteredMovies().count
                : 0
                return totalMovies
            case 2:
                var totalMovies = movieCategory.open ? moviesViewModel.getUniqueDirectors().count + 1 : 1
                totalMovies += movieCategory.open && moviesViewModel.getShouldShowMoviesForGenericTypeCell()
                ? moviesViewModel.getFilteredMovies().count
                : 0
                return totalMovies
            case 3:
                var totalMovies = movieCategory.open ? moviesViewModel.getUniqueActors().count + 1 : 1
                totalMovies += movieCategory.open && moviesViewModel.getShouldShowMoviesForGenericTypeCell()
                ? moviesViewModel.getFilteredMovies().count
                : 0
                return totalMovies
            case 4:
                return movieCategory.open ? moviesViewModel.getMovieThumbnailsForMovies().count : 1
            default:
                return 1
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieCategory = movieCategoryViewModel.movieCategoriesForRow(at: indexPath.section)
        if indexPath.row == 0 && !moviesViewModel.getShouldShowMoviesForSearchText() {
            let cell = tableView.dequeueReusableCell(withIdentifier: Self.movieCategoryCellID, for: indexPath) as! MovieCategoryCell
            cell.configure(movieCategory: movieCategory)
            return cell
        } else {
            let filteredMovies = moviesViewModel.getMovieThumbnailsForFilteredMovies()
            let firstRange = 0...moviesViewModel.getSelectedRow()
            if movieCategory.open
                && moviesViewModel.getShouldShowMoviesForGenericTypeCell()
                && !firstRange.contains(indexPath.row)
                && indexPath.row <= indexPath.section + filteredMovies.count + moviesViewModel.getSelectedRow() {
                switch indexPath.section {
                case 0, 1, 2, 3:
                    let cell = tableView.dequeueReusableCell(withIdentifier: Self.movieThumbnailCellID, for: indexPath) as! MovieThumbnailCell
                    let movieThumbnail = filteredMovies[indexPath.row-moviesViewModel.getSelectedRow()-1]
                    cell.configure(movieThumbnail: movieThumbnail)
                    return cell
                default:
                    return UITableViewCell()
                }
            } else {
                let currentDataRow: Int
                if moviesViewModel.getShouldShowMoviesForGenericTypeCell() {
                    currentDataRow = firstRange.contains(indexPath.row)
                    ? indexPath.row - 1
                    : indexPath.row - filteredMovies.count - 1
                } else {
                    currentDataRow = indexPath.row - 1
                }

                switch indexPath.section {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: Self.movieGenericTypeCellID_Years, for: indexPath) as! MovieGenericTypeCell
                    cell.configure(data: moviesViewModel.getUniqueYears()[currentDataRow])
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: Self.movieGenericTypeCellID_Genres, for: indexPath) as! MovieGenericTypeCell
                    cell.configure(data: moviesViewModel.getUniqueGenres()[currentDataRow])
                    return cell
                case 2:
                    let cell = tableView.dequeueReusableCell(withIdentifier: Self.movieGenericTypeCellID_Directors, for: indexPath) as! MovieGenericTypeCell
                    cell.configure(data: moviesViewModel.getUniqueDirectors()[currentDataRow])
                    return cell
                case 3:
                    let cell = tableView.dequeueReusableCell(withIdentifier: Self.movieGenericTypeCellID_Actors, for: indexPath) as! MovieGenericTypeCell
                    cell.configure(data: moviesViewModel.getUniqueActors()[currentDataRow])
                    return cell
                case 4:
                    let cell = tableView.dequeueReusableCell(withIdentifier: Self.movieThumbnailCellID, for: indexPath) as! MovieThumbnailCell
                    let movieThumbnail = movieThumbnailsViewModel.movieThumbnailForRow(at: indexPath)
                    cell.configure(movieThumbnail: movieThumbnail)
                    return cell
                default:
                    return UITableViewCell()
                }
            }
        }
    }
}
