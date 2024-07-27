import Foundation
import UIKit

// MARK: - UITableViewDataSource

extension MovieDetailsView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movie.ratings.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Ratings"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.movieShowRatingsCellID, for: indexPath) as! MovieShowRatingsCell
        cell.configure(rating: movie.ratings[indexPath.row])
        return cell
    }
}
