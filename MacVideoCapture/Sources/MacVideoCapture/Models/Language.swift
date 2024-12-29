import Foundation

enum Language: String {
    case english = "en"
    case arabic = "ar"
    
    static var current: Language {
        get { Language(rawValue: UserDefaults.standard.string(forKey: "currentLanguage") ?? "en") ?? .english }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: "currentLanguage") }
    }
}
