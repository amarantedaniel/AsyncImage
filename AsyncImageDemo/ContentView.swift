import AsyncImage
import SwiftUI

struct ContentView: View {
    var body: some View {
        AsyncImage(URL(string: "https://picsum.photos/200/300"),
                   placeholder: { Text("No Image") },
                   activityIndicator: { Text("Loading...") })
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
