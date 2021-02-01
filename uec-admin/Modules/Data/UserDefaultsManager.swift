import Foundation

protocol UserDefaultsManagerType: AnyObject {
	func getSelectedCountryIdentifiers() -> [String]
	func getStreamDescription() -> String?
	func getChannelURLString() -> String?
	
	func setSelectedCountryIdentifiers(_ identifiers: [String])
	func setStreamDescription(_ description: String)
	func setChannelURLString(_ urlString: String)
}

class UserDefaultsManager: UserDefaultsManagerType {
	private let userDefaults = UserDefaults.standard
	
	func getSelectedCountryIdentifiers() -> [String] {
		return (userDefaults.array(forKey: DataType.countryIdentifiers.rawValue) as? [String]) ?? []
	}
	
	func getStreamDescription() -> String? {
		return userDefaults.string(forKey: DataType.streamDescription.rawValue)
	}
	
	func getChannelURLString() -> String? {
		return userDefaults.string(forKey: DataType.channelURLString.rawValue)
	}
	
	func setSelectedCountryIdentifiers(_ identifiers: [String]) {
		userDefaults.set(identifiers, forKey: DataType.countryIdentifiers.rawValue)
	}
	
	func setStreamDescription(_ description: String) {
		userDefaults.set(description, forKey: DataType.streamDescription.rawValue)
	}
	
	func setChannelURLString(_ urlString: String) {
		userDefaults.set(urlString, forKey: DataType.channelURLString.rawValue)
	}
}

private extension UserDefaultsManager {
	enum DataType: String {
		case countryIdentifiers
		case streamDescription
		case channelURLString
	}
}
