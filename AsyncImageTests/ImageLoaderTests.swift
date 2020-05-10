@testable import AsyncImage
import Combine
import XCTest

class ImageLoaderTests: XCTestCase {
    private var cache: FakeCache!
    private var service: MockImageFetchingService!
    private var sut: ImageLoader!

    override func setUp() {
        cache = FakeCache()
        service = MockImageFetchingService()
        sut = ImageLoader(cache: cache, service: service)
    }

    func testImageLoader_WhenServiceReturnsAnImage_ShouldHaveImage() {
        // given
        let image = UIImage(systemName: "heart.fill")
        let url = URL(string: "http://example.com/image.png")!
        service.publisher = Result<UIImage?, Never>.success(image).publisher

        // when
        sut.url = url

        // then
        XCTAssertEqual(service.calls, [url])
        XCTAssertEqual(sut.image, image)
    }

    func testImageLoader_WhenServiceReturnsAnImage_ShouldSaveImageOnCache() {
        // given
        let image = UIImage(systemName: "heart.fill")
        let url = URL(string: "http://example.com/image.png")!
        service.publisher = Result<UIImage?, Never>.success(image).publisher

        // when
        sut.url = url

        // then
        XCTAssertEqual(service.calls, [url])
        XCTAssertEqual(cache.cache[url], image)
        XCTAssertEqual(cache.cache.count, 1)
    }

    func testImageLoader_WhenServiceReturnsAnImage_ShouldRetrieveImageFromCache() {
        // given
        let image = UIImage(systemName: "heart.fill")
        let url = URL(string: "http://example.com/image.png")!
        cache.set(url: url, image: image)

        // when
        sut.url = url

        // then
        XCTAssertEqual(service.calls, [])
        XCTAssertEqual(sut.image, image)
    }

    func testImageLoader_WhenUrlIsNull_ShouldNotDoAnything() {
        // when
        sut.url = nil

        // then
        XCTAssertEqual(service.calls, [])
        XCTAssertEqual(cache.cache, [:])
        XCTAssertNil(sut.image)
    }

    func testImageLoader_WhenReturnedImageIsNil_ShouldSetImageToNil() {
        // given
        let url = URL(string: "http://example.com/image.png")!
        service.publisher = Result<UIImage?, Never>.success(nil).publisher

        // when
        sut.url = url
        
        // then
        XCTAssertEqual(service.calls, [url])
        XCTAssertEqual(cache.cache[url], nil)
        XCTAssertNil(sut.image)
    }
}

private class FakeCache: ImageCache {
    var cache: [URL: UIImage] = [:]

    func get(url: URL) -> UIImage? {
        return cache[url]
    }

    func set(url: URL, image: UIImage?) {
        cache[url] = image
    }
}

private class MockImageFetchingService: ImageFetchingService {
    var publisher: Result<UIImage?, Never>.Publisher?
    private(set) var calls: [URL] = []
    func fetch(url: URL) -> AnyPublisher<UIImage?, Never> {
        calls.append(url)
        return publisher!.eraseToAnyPublisher()
    }
}
