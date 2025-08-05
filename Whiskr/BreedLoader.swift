import Foundation

struct BreedList: Decodable {
    let breeds: [String]
}

class BreedLoader {
    static func loadBreeds() -> [String] {
        guard let url = Bundle.main.url(forResource: "breeds", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(BreedList.self, from: data)
        else {
            print("❌ Failed to load breeds.json")
            return []
        }

        return decoded.breeds
    }
}



