import UIKit

class HomeViewController: BaseTableViewController {
	private let dataManager = DataManager()
	
	override func loadView() {
		super.loadView()
		
		tableView.register(
			UITableViewCell.self,
			forCellReuseIdentifier: HomeViewCell.identifier)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "UEC Admin"
	}
}

// MARK: - UITableViewDelegate
extension HomeViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
}

// MARK: - UITableViewDataSource
extension HomeViewController {
	override func numberOfSections(in tableView: UITableView) -> Int {
		return Section.allCases.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	override func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(
			withIdentifier: HomeViewCell.identifier,
			for: indexPath)
		
		let text: String = {
			let section = Section.allCases[indexPath.section]
			
			switch section {
			case .countries:
				let identifiers = dataManager.selectedCountryIdentifiers
				return identifiers.isEmpty ? section.placeholder : identifiers.joined(separator: ", ")
			case .description:
				return dataManager.streamDescription ?? section.placeholder
			case .link:
				return dataManager.channelURLString ?? section.placeholder
			}
		}()
		
		cell.textLabel?.text = text
		return cell
	}
}

private extension HomeViewController {
	enum Section: CaseIterable {
		case countries
		case description
		case link
		
		var placeholder: String {
			switch self {
			case .countries:
				return "+ Add countries & select time"
			case .description:
				return "+ Add description"
			case .link:
				return "+ Add links"
			}
		}
	}
}
