import AsyncImage
import SwiftUI

struct ContentView: View {
    @State var text = "https://picsum.photos/200/300"
    var body: some View {
        VStack(alignment: .center) {
            AsyncImage(URL(string: text),
                       placeholder: { Text("URL is nil or invalid") },
                       activityIndicator: { Text("Loading...") })
            Spacer()
            TextField("Add a url", text: $text)
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
