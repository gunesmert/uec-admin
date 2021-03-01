import Foundation

protocol UserDefaultsManagerType: AnyObject {
	func getSelectedTimeZoneIdentifiers() -> [String]
	func getStreamDescription() -> String?
	func getChannelURLString() -> String?
	
	func setSelectedTimeZoneIdentifiers(_ identifiers: [String])
	func setStreamDescription(_ description: String)
	func setChannelURLString(_ urlString: String)
}

class UserDefaultsManager: UserDefaultsManagerType {
	private let userDefaults = UserDefaults.standard
	
	func getSelectedTimeZoneIdentifiers() -> [String] {
		guard let identifiers = userDefaults.array(forKey: DataType.timeZoneIdentifiers.rawValue) as? [String], !identifiers.isEmpty else {
			return [
				"Europe/Amsterdam",
				"Europe/Berlin",
				"Europe/Helsinki",
				"Europe/Sofia",
				"Europe/Istanbul",
				"America/Los_Angeles"
			]
		}
	
		return identifiers
	}
	
	func getStreamDescription() -> String? {
		return userDefaults.string(forKey: DataType.streamDescription.rawValue)
	}
	
	func getChannelURLString() -> String? {
		return userDefaults.string(forKey: DataType.channelURLString.rawValue)
	}
	
	func setSelectedTimeZoneIdentifiers(_ identifiers: [String]) {
		userDefaults.set(identifiers, forKey: DataType.timeZoneIdentifiers.rawValue)
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
		case timeZoneIdentifiers
		case streamDescription
		case channelURLString
	}
}
