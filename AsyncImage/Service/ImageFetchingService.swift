import Combine
import UIKit

protocol ImageFetchingService {
    func fetch(url: URL) -> AnyPublisher<UIImage?, Never>
}
