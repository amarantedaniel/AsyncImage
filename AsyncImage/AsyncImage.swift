import Combine
import SwiftUI

public struct AsyncImage<Placeholder: View>: View {
    @ObservedObject private var loader = ImageLoader()
    let placeholder: Placeholder

    public init(_ url: URL?, @ViewBuilder placeholder: () -> Placeholder) {
        self.placeholder = placeholder()
        loader.url = url
    }

    public var body: some View {
        switch (loader.image, loader.url) {
        case let (image?, _):
            return AnyView(Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit))
        case (nil, _?):
            return AnyView(placeholder)
        case (nil, nil):
            return AnyView(placeholder)
        }
    }
}

private class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var url: URL?
    private var cancellables = Set<AnyCancellable>()

    init() {
        $url
            .removeDuplicates()
            .compactMap { $0 }
            .sink { [weak self] url in
                if let image = ImageCache.get(key: url) {
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
            .sink(receiveValue: { image in
                self.image = image
                ImageCache.set(key: url, image: image)
            })
            .store(in: &cancellables)
    }
}

private enum ImageCache {
    private static var cache: [URL: UIImage] = [:]

    static func get(key: URL) -> UIImage? {
        return cache[key]
    }

    static func set(key: URL, image: UIImage?) {
        cache[key] = image
    }
}
