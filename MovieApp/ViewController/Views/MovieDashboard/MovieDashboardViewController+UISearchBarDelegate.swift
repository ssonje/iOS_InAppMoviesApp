import Foundation
import UIKit

// MARK: - UISearchBarDelegate

extension MovieDashboardViewController: UISearchBarDelegate {

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            moviesViewModel.fetchQueryResult(searchText: searchText)
            moviesViewModel.toggleShouldShowMoviesForSearchText()
            tableView.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        moviesViewModel.toggleShouldShowMoviesForSearchText()
        tableView.reloadData()
    }
}
