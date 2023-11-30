import Foundation

public enum Environment {
    enum Keys {
        static let glApiKey = "API_KEY"
    }
   
    ///Get variables
    static func glApiKey() throws -> String {
        guard let glApiKeyStr = Bundle.main.object(forInfoDictionaryKey: Keys.glApiKey) as? String else {
            throw SdkError.Generic(message: "api key not found")
        }
        return glApiKeyStr
    }
}
