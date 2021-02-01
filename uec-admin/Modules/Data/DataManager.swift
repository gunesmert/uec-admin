import Foundation

protocol DataManagerType: AnyObject {
	var selectedCountryIdentifiers: [String] { get }
	var streamDescription: String? { get }
	var channelURLString: String? { get }
}

class DataManager: DataManagerType {
	var selectedCountryIdentifiers: [String] = []
	var streamDescription: String?
	var channelURLString: String?
	
	private let userDefaultsManager = UserDefaultsManager()
	
	init() {
		selectedCountryIdentifiers = userDefaultsManager.getSelectedCountryIdentifiers()
		streamDescription = userDefaultsManager.getStreamDescription()
		channelURLString = userDefaultsManager.getChannelURLString()
	}
}
