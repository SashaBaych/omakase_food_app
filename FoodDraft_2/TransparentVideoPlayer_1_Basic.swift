//import SwiftUI
//import AVKit
//
//struct TransparentVideoPlayerView: View {
//    var body: some View {
//        VideoView()
//            .frame(width: 300, height: 300)
//            .background(Color.clear)
//    }
//}
//
//struct VideoView: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> AVPlayerViewController {
//        let controller = AVPlayerViewController()
//        let url = Bundle.main.url(forResource: "chef_2_encoded", withExtension: "mov")!
//        let player = AVPlayer(url: url)
//        
//        controller.player = player
//        controller.showsPlaybackControls = false
//        controller.view.backgroundColor = .clear // Ensuring the background is clear
//        player.play()
//        
//        return controller
//    }
//
//    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
//}
//
//#Preview {
//    TransparentVideoPlayerView()
//}
