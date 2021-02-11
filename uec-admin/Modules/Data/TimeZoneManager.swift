import Foundation

struct DecodableTimeZone: Decodable {
	let name: String
	let code: String
}

struct CustomTimeZone: Decodable {
	let decodableTimeZone: DecodableTimeZone
	let timeZone: TimeZone
	let abbreviation: String
	
	init?(decodableTimeZone: DecodableTimeZone) {
		guard let timeZone = TimeZone(identifier: decodableTimeZone.name),
			  let abbreviation = timeZone.abbreviation() else { return nil }
		
		self.decodableTimeZone = decodableTimeZone
		self.timeZone = timeZone
		self.abbreviation = abbreviation
	}
}

protocol TimeZoneManagerType: AnyObject {
	var availableTimeZones: [CustomTimeZone] { get }
}

class TimeZoneManager: TimeZoneManagerType {
	let availableTimeZones: [CustomTimeZone]
	
	init() {
		let bundle = Bundle(for: TimeZoneManager.self)
		guard let path = bundle.path(forResource: "timezones", ofType: "json"),
			  let data = FileManager.default.contents(atPath: path) else {
			availableTimeZones = []
			return
		}
		
		do {
			let decoder = JSONDecoder()
			availableTimeZones = try decoder.decode([DecodableTimeZone].self, from: data).map { CustomTimeZone(decodableTimeZone: $0) }.compactMap { $0 }
		} catch let error {
			print(error)
			availableTimeZones = []
		}
	}
}
