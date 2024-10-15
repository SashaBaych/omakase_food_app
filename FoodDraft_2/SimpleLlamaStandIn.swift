import Foundation

@MainActor
class SimplifiedLLMEvaluator: ObservableObject {
    @Published var isGenerating: Bool = false
    @Published var recipe: Recipe?
    @Published var animations: [String] = []

    func loadAnimations() {
        let bundle = Bundle.main
        if let resources = bundle.urls(forResourcesWithExtension: "json", subdirectory: nil) {
            animations = resources.compactMap { url -> String? in
                let filename = url.deletingPathExtension().lastPathComponent
                if filename.starts(with: "Animation - ") {
                    return filename
                }
                return nil
            }
            print("Loaded animations: \(animations)")
        } else {
            print("No .json files found in the bundle")
        }
        
        if animations.isEmpty {
            print("No animation files found matching the expected pattern")
        }
    }

    func loadModels() async {
        // Simulate model loading
        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000) // 2 seconds delay
        print("Models loaded successfully")
    }

    func runChefAndParser(userPrompt: String) async {
        isGenerating = true
        defer { isGenerating = false }

        // Simulate generation delay
        try? await Task.sleep(nanoseconds: 15 * 1_000_000_000) // delay

        let rawOutput = """
        Here is the transformed recipe output in the standardized JSON format:

        ```
        {
          "recipeName": "Pesto Pasta with Tomatoes",
          "introduction": "This recipe is a quick and easy way to enjoy the flavors of Italy. The combination of fresh tomatoes, basil, garlic, and pesto sauce makes for a delicious and healthy pasta dish.",
          "ingredients": [
            {
              "item": "pasta",
              "quantity": "8 oz (225g)",
              "unit": "ounces"
            },
            {
              "item": "tomatoes",
              "quantity": "1/2 cup (120ml)",
              "unit": "cups"
            },
            {
              "item": "basil",
              "quantity": "1/4 cup (30g)",
              "unit": "cups"
            },
            {
              "item": "garlic",
              "quantity": "2 cloves",
              "unit": "cups"
            },
            {
              "item": "pesto sauce",
              "quantity": "1/2 cup (120ml)",
              "unit": "cups"
            },
            {
              "item": "salt",
              "quantity": "to taste",
              "unit": "tablespoons"
            },
            {
              "item": "pepper",
              "quantity": "to taste",
              "unit": "tablespoons"
            }
          ],
          "preparationTime": {
            "value": "10 minutes",
            "unit": "minutes"
          },
          "cookingTime": {
            "value": "15 minutes",
            "unit": "minutes"
          },
          "totalTime": {
            "value": "25 minutes",
            "unit": "minutes"
          },
          "instructions": [
            "Bring a large pot of salted water to a boil. Cook the pasta according to the package instructions until al dente. Reserve 1 cup of pasta water before draining.",
            "In a large skillet, heat the pesto sauce over medium heat. Add the diced tomatoes and cook for 2-3 minutes, or until they start to soften.",
            "Add the minced garlic to the skillet and cook for another minute, stirring constantly to prevent burning.",
            "Add the cooked pasta to the skillet, tossing everything together to combine.",
            "If using Parmesan cheese, sprinkle it over the pasta and toss to combine.",
            "Season with salt and pepper to taste.",
            "Serve immediately, garnished with fresh basil leaves if desired."
          ],
          "optional": [
            "Grilled chicken or shrimp for added protein",
            "Roasted vegetables (e.g., broccoli, carrots) for added fiber and vitamins",
            "A sprinkle of nutritional yeast for a cheesy, nutty flavor"
          ],
          "nutritionalHighlights": [
            "Pesto sauce is rich in antioxidants and has anti-inflammatory properties.",
            "Tomatoes are high in vitamin C and lycopene, an antioxidant that helps protect against cancer.",
            "Pasta is a good source of complex carbohydrates, which provide energy for the body.",
            "Basil is a good source of vitamin K and antioxidants."
          ]
        }
        ```

        I hope this transformed recipe output meets your requirements.
        
        """
        
        let jsonString = parseJsonFromOutput(rawOutput)
        recipe = RecipeParser.parse(jsonString: jsonString)
            
        if let recipe = recipe {
                print("\nParsed Recipe:")
                print("Name: \(recipe.recipeName)")
                print("Introduction: \(recipe.introduction)")
                // ... print other details as needed
        } else {
            print("Failed to parse recipe")
            print(jsonString)
        }
    }
    
    private func parseJsonFromOutput(_ rawOutput: String) -> String {
            guard let startIndex = rawOutput.firstIndex(of: "{"),
                  let endIndex = rawOutput.lastIndex(of: "}") else {
                return "Error: Unable to find JSON content"
            }

            let jsonContent = String(rawOutput[startIndex...endIndex])
            return jsonContent
        }
    
}

