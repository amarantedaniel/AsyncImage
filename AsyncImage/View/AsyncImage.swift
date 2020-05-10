import SwiftUI

public struct AsyncImage<Placeholder: View, ActivityIndicator: View>: View {
    @ObservedObject private var loader: ImageLoader
    let placeholder: Placeholder
    let activityIndicator: ActivityIndicator
    
    public init(_ url: URL?,
                cache: ImageCache,
                @ViewBuilder placeholder: () -> Placeholder,
                @ViewBuilder activityIndicator: () -> ActivityIndicator) {
        self.loader = ImageLoader(cache: cache)
        self.placeholder = placeholder()
        self.activityIndicator = activityIndicator()
        loader.url = url
    }
    
    public init(_ url: URL?,
                @ViewBuilder placeholder: () -> Placeholder,
                @ViewBuilder activityIndicator: () -> ActivityIndicator) {
        self.loader = ImageLoader()
        self.placeholder = placeholder()
        self.activityIndicator = activityIndicator()
        loader.url = url
    }

    public var body: some View {
        switch (loader.image, loader.url) {
        case let (image?, _):
            return AnyView(Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit))
        case (nil, _?):
            return AnyView(activityIndicator)
        case (nil, nil):
            return AnyView(placeholder)
        }
    }
}
