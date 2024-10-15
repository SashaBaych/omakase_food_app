//import SwiftUI
//import Lottie
//
//struct AnimationView: View {
//    @Binding var isGenerating: Bool
//    @Binding var showOutput: Bool
//    let animations: [String]
//    @State private var currentAnimation: String = ""
//    @State private var timer: Timer? = nil
//    @State private var rotation: Double = 0
//    
//    var body: some View {
//        ZStack {
//            Color.white.edgesIgnoringSafeArea(.all)
//            
//            VStack {
//                if !animations.isEmpty {
//                    LottieView(animationName: currentAnimation)
//                        .frame(width: 300, height: 300)
//                        .id(currentAnimation)
//                    Text("Cooking in progress...")
//                        .font(.headline)
//                        .foregroundColor(.orange)
//                } else {
//                    Text("No animations available")
//                        .frame(width: 300, height: 300)
//                }
//                
//                // Skeuomorphic "Stop Cooking" button
//                Button(action: {
//                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0.3)) {
//                        rotation += 180
//                    }
//                    stopAnimationCycle()
//                    isGenerating = false
//                    showOutput = false
//                }) {
//                    ZStack {
//                        Circle()
//                            .fill(LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.2), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
//                            .shadow(color: .gray, radius: 5, x: 2, y: 2)
//                            .frame(width: 100, height: 100)
//                        
//                        Circle()
//                            .stroke(Color.red, lineWidth: 4)
//                            .frame(width: 90, height: 90)
//                        
//                        VStack {
//                            Image(systemName: "timer")
//                                .font(.system(size: 30))
//                                .foregroundColor(.red)
//                            Text("Stop")
//                                .font(.caption)
//                                .fontWeight(.bold)
//                                .foregroundColor(.red)
//                        }
//                        
//                        Rectangle()
//                            .fill(Color.red)
//                            .frame(width: 4, height: 40)
//                            .offset(y: -20)
//                            .rotationEffect(.degrees(rotation))
//                    }
//                }
//                .buttonStyle(PlainButtonStyle())
//            }
//        }
//        .onAppear {
//            startAnimationCycle()
//        }
//        .onDisappear {
//            stopAnimationCycle()
//        }
//    }
//    
//    private func startAnimationCycle() {
//        // ... (keep existing startAnimationCycle logic)
//    }
//    
//    private func stopAnimationCycle() {
//        // ... (keep existing stopAnimationCycle logic)
//    }
//}
