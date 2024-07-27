import Foundation
import UIKit

// MARK: - UIScrollViewDelegate

extension MovieDetailsView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x>0 {
            scrollView.contentOffset.x = 0
        }
    }
}
