import SwiftUI
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

#Preview {
    ChatInputView { message in
        print("Message submitted: \(message)")
    }
}

