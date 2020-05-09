import Combine
import UIKit

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var url: URL?
    private var cache: ImageCache
    private var cancellables = Set<AnyCancellable>()

    init(cache: ImageCache = DefaultImageCache.shared) {
        self.cache = cache
        $url
            .removeDuplicates()
            .compactMap { $0 }
            .sink { [weak self] url in
                if let image = cache.get(url: url) {
                    self?.image = image
                } else {
                    self?.load(url: url)
                }
            }
            .store(in: &cancellables)
    }

    func load(url: URL) {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] image in
                self?.image = image
                self?.cache.set(url: url, image: image)
            })
            .store(in: &cancellables)
    }
}
