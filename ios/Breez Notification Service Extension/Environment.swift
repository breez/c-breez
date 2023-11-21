import Foundation

public enum Environment {
    enum Keys {
        static let glApiKey = "API_KEY"
        static let glKey = "GL_KEY"
        static let glCert = "GL_CERT"
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
    
    static let glKey: String = {
        guard let glKeyStr = Environment.infoDictionary [Keys.glKey] as? String else {
            fatalError("GL_KEY not set in plist")
        }
        return glKeyStr
    }()
    
    static let glCert: String = {
        guard let glCertStr = Environment.infoDictionary [Keys.glCert] as? String else {
            fatalError("GL_CERT not set in plist")
        }
        return glCertStr
    }()
}
