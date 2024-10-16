import SwiftUI
import AVKit

struct TransparentVideoPlayerView: View {
    @StateObject private var videoManager = VideoManager()
    
    var body: some View {
        VideoView(player: videoManager.player)
            .frame(width: 300, height: 300)
            .background(Color.clear)
            .onAppear {
                videoManager.loadVideos()
                videoManager.playRandomVideo()
            }
    }
}

class VideoManager: ObservableObject {
    @Published var player = AVPlayer()
    private var videos: [URL] = []
    
    func loadVideos() {
        let bundle = Bundle.main
        if let resources = bundle.urls(forResourcesWithExtension: "mov", subdirectory: nil) {
            videos = resources.filter { $0.lastPathComponent.starts(with: "chef_") }
            print("Loaded videos: \(videos)")
        } else {
            print("No .mov files found in the bundle")
        }
        
        if videos.isEmpty {
            print("No video files found matching the expected pattern")
        }
    }
    
    func playRandomVideo() {
        guard !videos.isEmpty else { return }
        let randomURL = videos.randomElement()!
        let playerItem = AVPlayerItem(url: randomURL)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerItem, queue: .main) { [weak self] _ in
            self?.playRandomVideo()
        }
    }
}

struct VideoView: UIViewControllerRepresentable {
    let player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.view.backgroundColor = .clear
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}

#Preview {
    TransparentVideoPlayerView()
}
