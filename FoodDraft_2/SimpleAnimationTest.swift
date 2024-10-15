import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let animationName: String
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView(name: animationName)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

struct CookingAnimation: View {
    var body: some View {
        LottieView(animationName: "Animation - 1728892201590")
            .frame(width: 300, height: 300) // Adjust size as needed
    }
}

#Preview {
    CookingAnimation()
}
