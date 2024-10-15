import SwiftUI

struct Recipe: Codable {
    let recipeName: String
    let introduction: String?
    let ingredients: [Ingredient]
    let preparationTime: TimeValue?
    let cookingTime: TimeValue?
    let totalTime: TimeValue?
    let instructions: [String]
    let optional: [String]?
    let nutritionalHighlights: [String]?
}

struct Ingredient: Codable {
    let item: String
    let quantity: String?
    let unit: String?
}

struct TimeValue: Codable {
    let value: String
    let unit: String
    
    var intValue: Int? {
        return Int(value.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
}

class RecipeParser {
    static func parse(jsonString: String) -> Recipe? {
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Error: Unable to convert string to data")
            return nil
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let recipe = try decoder.decode(Recipe.self, from: jsonData)
            print("Successfully parsed recipe:")
            print("Name: \(recipe.recipeName)")
            if let prepTime = recipe.preparationTime {
                print("Prep Time: \(prepTime.value) \(prepTime.unit)")
            }
            if let cookTime = recipe.cookingTime {
                print("Cook Time: \(cookTime.value) \(cookTime.unit)")
            }
            if let totalTime = recipe.totalTime {
                print("Total Time: \(totalTime.value) \(totalTime.unit)")
            }
            return recipe
        } catch {
            print("Error decoding JSON: \(error)")
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .keyNotFound(let key, _):
                    print("Key not found: \(key.stringValue)")
                case .valueNotFound(let type, _):
                    print("Value not found: \(type)")
                case .typeMismatch(let type, _):
                    print("Type mismatch: \(type)")
                case .dataCorrupted(let context):
                    print("Data corrupted: \(context.debugDescription)")
                @unknown default:
                    print("Unknown decoding error")
                }
            }
            
            // Attempt to parse partial data
            if let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                print("Partial parsing results:")
                if let recipeName = jsonObject["recipeName"] as? String {
                    print("Recipe Name: \(recipeName)")
                    // Create a minimal Recipe object with available data
                    return Recipe(
                        recipeName: recipeName,
                        introduction: jsonObject["introduction"] as? String,
                        ingredients: parseIngredients(from: jsonObject["ingredients"]),
                        preparationTime: parseTimeValue(from: jsonObject["preparationTime"]),
                        cookingTime: parseTimeValue(from: jsonObject["cookingTime"]),
                        totalTime: parseTimeValue(from: jsonObject["totalTime"]),
                        instructions: jsonObject["instructions"] as? [String] ?? [],
                        optional: jsonObject["optional"] as? [String],
                        nutritionalHighlights: jsonObject["nutritionalHighlights"] as? [String]
                    )
                }
            }
        }
        
        return nil
    }
    
    private static func parseIngredients(from ingredientsData: Any?) -> [Ingredient] {
        guard let ingredientsArray = ingredientsData as? [[String: Any]] else {
            return []
        }
        
        return ingredientsArray.compactMap { ingredientDict in
            guard let item = ingredientDict["item"] as? String else {
                return nil
            }
            let quantity = ingredientDict["quantity"] as? String
            let unit = ingredientDict["unit"] as? String
            return Ingredient(item: item, quantity: quantity, unit: unit)
        }
    }
    
    private static func parseTimeValue(from timeData: Any?) -> TimeValue? {
        guard let timeDict = timeData as? [String: Any],
              let value = timeDict["value"] as? String,
              let unit = timeDict["unit"] as? String else {
            return nil
        }
        return TimeValue(value: value, unit: unit)
    }
}
