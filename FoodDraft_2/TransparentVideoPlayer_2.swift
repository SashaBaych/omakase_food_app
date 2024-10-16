import SwiftUI
import AVKit

struct TransparentVideoPlayerView: View {
    @StateObject private var videoManager = VideoManager()
    @State private var currentVideoID = UUID()
    
    var body: some View {
        VideoView(player: videoManager.player)
            .frame(width: 300, height: 300)
            .background(Color.clear)
            .transition(.opacity)
            .id(currentVideoID)
            .onAppear {
                videoManager.loadVideos()
                videoManager.playRandomVideo()
            }
            .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)) { _ in
                playNextVideo()
            }
    }
    
    private func playNextVideo() {
        withAnimation(.easeInOut(duration: 0.5)) {
            currentVideoID = UUID()
        }
        videoManager.playRandomVideo()
    }
}

class VideoManager: ObservableObject {
    @Published var player = AVPlayer()
    private var videos: [URL] = []
    private var currentVideoIndex = 0
    
    init() {
        player.volume = 0
        player.actionAtItemEnd = .none
    }
    
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
        currentVideoIndex = Int.random(in: 0..<videos.count)
        playVideo(at: currentVideoIndex)
    }
    
    private func playVideo(at index: Int) {
        let videoURL = videos[index]
        let playerItem = AVPlayerItem(url: videoURL)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
}

struct VideoView: UIViewControllerRepresentable {
    let player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        controller.view.backgroundColor = .clear
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}

#Preview {
    TransparentVideoPlayerView()
}
