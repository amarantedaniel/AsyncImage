import UIKit

protocol ImageCache {
    func get(url: URL) -> UIImage?
    func set(url: URL, image: UIImage?)
}

class DefaultImageCache: ImageCache {
    static var shared = DefaultImageCache()
    private init() {}
    private var cache: [URL: UIImage] = [:]

    func get(url: URL) -> UIImage? {
        return cache[url]
    }

    func set(url: URL, image: UIImage?) {
        cache[url] = image
    }
}
