import Foundation

public enum Environment {
    enum Keys {
        static let glApiKey = "API_KEY"
    }

    ///Get info.plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Info.plist file not found")
        }
        return dict
    }()

    ///Get variables
    static let glApiKey: String = {
        guard let glApiKeyStr = Environment.infoDictionary [Keys.glApiKey] as? String else {
            fatalError("API_KEY not set in plist")
        }
        return glApiKeyStr
    }()
}
