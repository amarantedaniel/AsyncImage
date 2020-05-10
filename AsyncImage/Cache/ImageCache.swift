import UIKit

protocol ImageCache {
    func get(url: URL) -> UIImage?
    func set(url: URL, image: UIImage?)
}
