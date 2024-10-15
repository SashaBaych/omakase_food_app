import SwiftUI

struct OutputView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(recipe.recipeName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                if let introduction = recipe.introduction {
                    Text(introduction)
                        .font(.body)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Ingredients")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    ForEach(recipe.ingredients, id: \.item) { ingredient in
                        Text("• \(ingredient.quantity ?? "") Unit \(ingredient.unit ?? "") \(ingredient.item)")
                    }
                }
                
                if !recipe.instructions.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Instructions")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        ForEach(recipe.instructions.indices, id: \.self) { index in
                            Text("\(index + 1). \(recipe.instructions[index])")
                        }
                    }
                }
                
                if let optional = recipe.optional, !optional.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Optional")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        ForEach(optional, id: \.self) { item in
                            Text("• \(item)")
                        }
                    }
                }
                
                if let highlights = recipe.nutritionalHighlights, !highlights.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Nutritional Highlights")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        ForEach(highlights, id: \.self) { highlight in
                            Text("• \(highlight)")
                        }
                    }
                }
            }
            .padding()
        }
        .navigationBarTitle("Recipe Details", displayMode: .inline)
    }
}
