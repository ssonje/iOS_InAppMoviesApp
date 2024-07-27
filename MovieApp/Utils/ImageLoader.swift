import Foundation
import UIKit

private let _imageCache = NSCache<AnyObject, AnyObject>()

/// Caches the images after loading the images
public class ImageLoader: NSObject {

    // MARK: - Properties

    private var imageCache = _imageCache

    // MARK: - API's

    func loadImage(with url: URL, completion: @escaping (UIImage?) -> ()) {
        let urlString = url.absoluteString

        // Check whether image is cached or not, if yes, return cached image
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            completion(imageFromCache)
            print("[ImageLoader] Returning image with urlString: \(urlString) from cache.")
            return
        }

        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else {
                print("[ImageLoader] Self shouldn't be nil.")
                completion(nil)
                return
            }

            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else {
                    print("[ImageLoader] Failed to get UIImage from the Image URL.")
                    completion(nil)
                    return
                }

                // Save the image into the cache
                self.imageCache.setObject(image, forKey: urlString as AnyObject)

                // Update the image property of this view model
                DispatchQueue.main.async {
                    completion(image)
                    print("[ImageLoader] Image Cached Successfully.")
                }
            } catch {
                print("[ImageLoader] Operation for getting image from the URL and saving image into the cache is failed with error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}
