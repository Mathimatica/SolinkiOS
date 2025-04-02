import SwiftUI
import AVKit

// Protocol to define the common interface for all card types
protocol CardData: Identifiable {
    var id: UUID { get }
    var type: CardType { get }
}

indirect enum CardType {
    case imageText(ImageData)
    case video(VideoData)
    case custom(CustomData)
}

struct ImageData: CardData { // Added Identifiable conformance
    let id = UUID()
    let title: String
    let text: String
    let imageUrl: String
    
    var type: CardType { .imageText(self) } // Computed property

    init(title: String, text: String, imageUrl: String) {
        self.title = title
        self.text = text
        self.imageUrl = imageUrl
    }
}

struct VideoData: CardData { // Added Identifiable conformance
    let id = UUID()
    let videoURL: URL
    
    var type: CardType { .video(self) } // Computed property

    init(videoURL: URL) {
        self.videoURL = videoURL
    }
}

struct CustomData: CardData { // Added Identifiable conformance
    let id = UUID()
    var type: CardType { .custom(self) } // Computed property
    let customMessage: String

    init(customMessage: String) {
        self.customMessage = customMessage
    }
}

struct CardView: View {
    let cardData: any CardData

    var body: some View {
        switch cardData.type {
        case .imageText(let imageData):
            ImageTextCardView(data: imageData)
        case .video(let videoData):
            VideoCardView(data: videoData)
        case .custom(let customData):
            CustomCardView(data: customData)
        }
    }
}

struct ImageTextCardView: View {
    let data: ImageData

    var body: some View {
        VStack {
            Text(data.title)
                .font(.headline)
            SLImage(imageURLString: data.imageUrl).cornerRadius(8)
            Text(data.text)
                .font(.body)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}

struct VideoCardView: View {
    let data: VideoData

    var body: some View {
        VideoPlayer(player: AVPlayer(url: data.videoURL))
            .frame(height: 200)
            .cornerRadius(8)
            .shadow(radius: 4)
    }
}

struct CustomCardView: View {
    let data: CustomData

    var body: some View {
        Text(data.customMessage)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.yellow)
            .cornerRadius(8)
            .shadow(radius: 4)
    }
}

struct CardsView: View {
    let cards: [any CardData] = [
        ImageData(title: "Sunset", text: "Beautiful sunset over the ocean.", imageUrl: "https://picsum.photos/200"),
        VideoData(videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!),
        CustomData(customMessage: "This is a custom card!"),
        ImageData(title: "Mountains", text: "Majestic mountains in the distance.", imageUrl: "https://picsum.photos/200")
    ]

    var body: some View {
        List(cards, id:\.id) { card in
            CardView(cardData: card)
                .listRowSeparator(.hidden) // Remove separators
                //.listRowInsets(EdgeInsets()) // Remove default padding
        }
        .listStyle(PlainListStyle()) // Keep it plain
        //.edgesIgnoringSafeArea(.all) // Ensure full screen usage
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CardsView()
    }
}
