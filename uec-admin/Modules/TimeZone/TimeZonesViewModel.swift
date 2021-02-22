import Foundation

struct TimeZoneSection {
	let abbreviation: String
	let secondsFromGMT: Int
	var timeZones: [CustomTimeZone]
}

class TimeZonesViewModel {
	private let userDefaultsManager = UserDefaultsManager()
	
	var visibleSections: [TimeZoneSection] {
		if isEditing {
			return availableSections
		} else {
			return selectedSections
		}
	}
	
	var availableSections: [TimeZoneSection] = []
	var selectedSections: [TimeZoneSection] = []
	var selectedTimeZoneIdentifiers: [String]
	
	private var currentSections: [TimeZoneSection] {
		return isEditing ? availableSections : selectedSections
	}
	
	var currentTimeZoneIndex: Int?
	var isEditing: Bool = false
	var selectedDate: Date = Date()
	
	init() {
		selectedTimeZoneIdentifiers = DataManager.shared.selectedTimeZoneIdentifiers
		
		let customTimeZones = TimeZoneManager().availableTimeZones
		let dictionary = Dictionary(grouping: customTimeZones, by: { $0.abbreviation })
		
		let date = Date()
		
		for key in dictionary.keys.sorted() {
			guard let timeZones = dictionary[key],
				  let firstTimeZone = timeZones.first else { return }
			
			let section = TimeZoneSection(
				abbreviation: firstTimeZone.abbreviation,
				secondsFromGMT: firstTimeZone.timeZone.secondsFromGMT(for: date),
				timeZones: timeZones.sorted(by: { $0.timeZone.identifier > $1.timeZone.identifier }))
			
			availableSections.append(section)
		}
		
		availableSections = availableSections.sorted(by: { $0.secondsFromGMT > $1.secondsFromGMT })
		
		updateSelectedSections()
	}
	
	private func updateSelectedSections() {
		selectedSections = []
		
		let selectedIdentifiersSet = Set(selectedTimeZoneIdentifiers)
		
		for section in availableSections {
			let identifiers = Set(section.timeZones.compactMap { $0.timeZone.identifier })
			
			let intersectedIdentifiers = identifiers.intersection(selectedIdentifiersSet)
			
			if intersectedIdentifiers.isEmpty { continue }
			
			let timeZones = section.timeZones.filter { intersectedIdentifiers.contains($0.timeZone.identifier) }
			
			selectedSections.append(
				TimeZoneSection(
					abbreviation: section.abbreviation,
					secondsFromGMT: section.secondsFromGMT,
					timeZones: timeZones))
		}
		
		userDefaultsManager.setSelectedTimeZoneIdentifiers(selectedTimeZoneIdentifiers)
		DataManager.shared.reload()
		
		guard let abbreviation = Locale.current.calendar.timeZone.abbreviation() else {
			return
		}
		
		currentTimeZoneIndex = selectedSections.firstIndex {
			$0.abbreviation == abbreviation
		}
	}
	
	func toggleEditMode() {
		isEditing = !isEditing
	}
	
	func didSelectTimeZone(_ identifier: String) {
		if let index = selectedTimeZoneIdentifiers.firstIndex(of: identifier) {
			selectedTimeZoneIdentifiers.remove(at: index)
		} else {
			selectedTimeZoneIdentifiers.append(identifier)
		}
		
		updateSelectedSections()
	}
	
	func didSelect(_ date: Date, at index: Int) {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
		
		let dateString = dateFormatter.string(from: date)
		dateFormatter.timeZone = TimeZone(abbreviation: currentSections[currentTimeZoneIndex!].abbreviation)
		
		if let newDate = dateFormatter.date(from: dateString) {
			selectedDate = newDate
		}
	}
}
