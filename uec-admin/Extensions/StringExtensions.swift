import Foundation

extension String {
	var flagRepresentation: String {
		return self
			.unicodeScalars
			.map({ 127397 + $0.value })
			.compactMap(UnicodeScalar.init)
			.map(String.init)
			.joined()
	}
}
