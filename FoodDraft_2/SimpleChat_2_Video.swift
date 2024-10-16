import SwiftUI
import AVKit
import UIKit

struct ChatBubble: View {
    let bubbleMessage: String
    let isUser: Bool

    var body: some View {
        HStack {
            if isUser {
                Spacer()
            }
            Text(bubbleMessage)
                .padding(10)
                .background(isUser ? Color.blue : Color.pink.opacity(0.2))
                .foregroundColor(isUser ? .white : .black)
                .cornerRadius(15)
                .padding(isUser ? .trailing : .leading, 16)
                .frame(maxWidth: 250, alignment: isUser ? .trailing : .leading)
            if !isUser {
                Spacer()
            }
        }
        .padding(isUser ? .leading : .trailing, 50)
        .padding(.vertical, 5)
    }
}



struct ExpandingTextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var height: CGFloat
    let maxHeight: CGFloat

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.backgroundColor = UIColor.systemGray6
        textView.delegate = context.coordinator
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        DispatchQueue.main.async {
            let size = uiView.sizeThatFits(CGSize(width: uiView.frame.width, height: CGFloat.greatestFiniteMagnitude))
            if self.height != size.height {
                self.height = min(size.height, maxHeight)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: ExpandingTextView

        init(_ parent: ExpandingTextView) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}


struct ChatInputView: View {
    @State private var message: String = ""
    @State private var textViewHeight: CGFloat = 40
    let maxHeight: CGFloat = 300
    var onSubmit: (String) -> Void

    var body: some View {
        ZStack {
            Color.white
                .cornerRadius(30)
                .shadow(radius: 5)

            VStack {
                ChatBubble(bubbleMessage: "So what have you got?", isUser: false)

                Spacer()

                HStack(alignment: .bottom) {
                    ExpandingTextView(text: $message, height: $textViewHeight, maxHeight: maxHeight)
                        .frame(height: textViewHeight)
                        .background(Color(.systemGray6))
                        .cornerRadius(23)
                        .padding(.leading, 16)

                    Button(action: {
                        onSubmit(message)
                        message = ""
                    }) {
                        Image(systemName: "fork.knife")
                            .font(.system(size: 30))
                            .foregroundColor(.orange)
                    }
                    .padding(.trailing, 16)
                    .padding(.bottom, 5)
                }
                .padding(.bottom, 10)
            }
            .padding()
        }
        .frame(width: 350, height: 200 + max(0, textViewHeight - 40))
        .background(Color.clear)
        .animation(.default, value: textViewHeight)
    }
}



struct CombinedVideoChatView: View {
    @StateObject private var videoManager = VideoManager()
    @State private var chatMessage: String = ""
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all) // Background color
            
            VStack {
                HStack(spacing: 20) {
                    // Left side: Video Player
                    VStack {
                        Spacer()
                        TransparentVideoPlayerView(videoManager: videoManager)
                            .frame(width: 400, height: 400)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Right side: Chat
                    VStack {
                        Spacer()
                        ChatInputView { message in
                            print("Message submitted: \(message)")
                            // Here you would typically handle sending the message
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
        }
    }
}


// Existing TransparentVideoPlayerView, modified to accept videoManager as a parameter
struct TransparentVideoPlayerView: View {
    @ObservedObject var videoManager: VideoManager
    
    var body: some View {
        VideoView(player: videoManager.player)
            .frame(width: 400, height: 400)
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
    CombinedVideoChatView()
}
