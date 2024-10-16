import SwiftUI

@main
struct LLMEvalApp: App {
    @StateObject private var evaluator = SimplifiedLLMEvaluator()
    @State private var showOutput = false
    @State private var showAnimation = false
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ZStack {
                    if showAnimation {
                        AnimationView(isGenerating: $evaluator.isGenerating,
                                      showOutput: $showOutput,
                                      animations: evaluator.animations,
                                      onCancel: {
                                          showAnimation = false
                                          evaluator.isGenerating = false
                                          // Add any other necessary state resets here
                                      })
                            .transition(.opacity)
                    } else {
                        ChatInputView { userPrompt in
                            Task {
                                showAnimation = true
                                await evaluator.runChefAndParser(userPrompt: userPrompt)
                                showAnimation = false
                                showOutput = true
                            }
                        }
                        .navigationTitle("Omakase Chef")
                        .transition(.opacity)
                    }
                }
                .animation(.easeInOut, value: showAnimation)
                .onChange(of: showOutput) { oldValue, newValue in
                    if newValue {
                        showAnimation = false
                    }
                }
                .navigationDestination(isPresented: $showOutput) {
                    if let recipe = evaluator.recipe {
                        OutputView(recipe: recipe)
                    } else {
                        Text("Failed to generate recipe")
                    }
                }
            }
            .onAppear {
                Task {
                    await evaluator.loadModels()
                    evaluator.loadAnimations()
                    print("Loaded animations in App: \(evaluator.animations)")
                }
            }
        }
    }
}
