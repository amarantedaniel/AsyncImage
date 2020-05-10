import Combine
import UIKit

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var url: URL?
    private let cache: ImageCache
    private let service: ImageFetchingService
    private var cancellables = Set<AnyCancellable>()

    init(cache: ImageCache = DefaultImageCache.shared,
         service: ImageFetchingService = DefaultImageFetchingService()) {
        self.cache = cache
        self.service = service
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
        service
            .fetch(url: url)
            .sink(receiveValue: { [weak self] image in
                self?.image = image
                self?.cache.set(url: url, image: image)
            })
            .store(in: &cancellables)
    }
}
