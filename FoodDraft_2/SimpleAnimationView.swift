import SwiftUI
import Lottie

struct AnimationView: View {
    @Binding var isGenerating: Bool
    @Binding var showOutput: Bool
    let animations: [String]
    @State private var currentAnimation: String = ""
    @State private var timer: Timer? = nil
    var onCancel: (() -> Void)?  // New callback property
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                if !animations.isEmpty {
                    LottieView(animationName: currentAnimation)
                        .frame(width: 400, height: 400)
                        .id(currentAnimation) // Force view update when animation changes
        
                } else {
                    Text("No animations available")
                        .frame(width: 400, height: 400)
                }
                
                Button("Stop Cooking") {
                    stopAnimationCycle()
                    isGenerating = false
                    showOutput = false
                    onCancel?()  // Call the callback when cancel is pressed
                }
                .padding()
                .background(Color.mint)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .onAppear {
            startAnimationCycle()
        }
        .onDisappear {
            stopAnimationCycle()
        }
    }
    
    private func startAnimationCycle() {
        guard !animations.isEmpty else { return }
        
        // Set initial animation
        currentAnimation = animations.randomElement() ?? animations[0]
        print("Initial animation: \(currentAnimation)")
        
        // Start timer to change animation every 5 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            var newAnimation: String
            repeat {
                newAnimation = animations.randomElement() ?? animations[0]
            } while newAnimation == currentAnimation && animations.count > 1
            
            currentAnimation = newAnimation
            print("Switched to animation: \(currentAnimation)")
        }
    }
    
    private func stopAnimationCycle() {
        timer?.invalidate()
        timer = nil
        print("Animation cycle stopped")
    }
}
