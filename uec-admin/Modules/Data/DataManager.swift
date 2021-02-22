import Foundation

protocol DataManagerType: AnyObject {
	var selectedTimeZoneIdentifiers: [String] { get }
	var streamDescription: String? { get }
	var channelURLString: String? { get }
}

class DataManager: DataManagerType {
	static let shared = DataManager()
	
	var selectedTimeZoneIdentifiers: [String] = []
	var streamDescription: String?
	var channelURLString: String?
	
	private let userDefaultsManager = UserDefaultsManager()
	
	init() {
		reload()
	}
	
	func reload() {
		selectedTimeZoneIdentifiers = userDefaultsManager.getSelectedTimeZoneIdentifiers()
		streamDescription = userDefaultsManager.getStreamDescription()
		channelURLString = userDefaultsManager.getChannelURLString()
	}
}
