import UIKit

class HomeViewController: BaseTableViewController {
	override func loadView() {
		super.loadView()
		
		tableView.register(
			HomeViewCell.self,
			forCellReuseIdentifier: HomeViewCell.identifier)
		tableView.tableFooterView = UIView()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "UEC Admin"
	}
}

// MARK: - UITableViewDelegate
extension HomeViewController {
	override func tableView(
		_ tableView: UITableView,
		didSelectRowAt indexPath: IndexPath) {
		let section = Section.allCases[indexPath.section]
		
		switch section {
		case .countries:
			displayTimeZonesViewController()
		case .description:
			break
		case .link:
			break
		}
	}
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
				let identifiers = DataManager.shared.selectedTimeZoneIdentifiers
				return identifiers.isEmpty ? section.placeholder : identifiers.joined(separator: "\n")
			case .description:
				return DataManager.shared.streamDescription ?? section.placeholder
			case .link:
				return DataManager.shared.channelURLString ?? section.placeholder
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
	
	func displayTimeZonesViewController() {
		let controller = TimeZonesViewController()
		controller.delegate = self
		let navController = BaseNavigationController(rootViewController: controller)
		navigationController?.present(navController, animated: true)
	}
}

extension HomeViewController: TimeZonesViewControllerDelegate {
	func didUpdateTimeZones() {
		tableView.reloadData()
	}
}
