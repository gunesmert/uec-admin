import UIKit

protocol TimeZonesViewControllerDelegate: AnyObject {
	func didUpdateTimeZones()
}

class TimeZonesViewController: BaseTableViewController {
	weak var delegate: TimeZonesViewControllerDelegate?
	
	private let viewModel = TimeZonesViewModel()
	
	private let rightNavigationButton: UIButton = {
		let button = UIButton(type: .custom)
		button.setTitleColor(.systemBlue, for: .normal)
		return button
	}()
	
	override func loadView() {
		super.loadView()
		
		tableView.register(
			TimeZoneCell.self,
			forCellReuseIdentifier: TimeZoneCell.identifier)
		tableView.register(
			TimeZoneHeaderView.self,
			forHeaderFooterViewReuseIdentifier: TimeZoneHeaderView.identifier)
		tableView.tableFooterView = UIView()
		
		rightNavigationButton.addTarget(
			self,
			action: #selector(rightNavigationButtonTapped(_:)),
			for: .touchUpInside)
		
		updateNavigationButtonTitle()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Time Zones"
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNavigationButton)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		guard !viewModel.isEditing,
			  let sectionIndex = viewModel.currentTimeZoneIndex else { return }
		
//		tableView.scrollToRow(
//			at: IndexPath(row: 0, section: sectionIndex),
//			at: .top,
//			animated: true)
	}
	
	private func updateNavigationButtonTitle() {
		let title = viewModel.isEditing ? "Save" : "Edit"
		rightNavigationButton.setTitle(title, for: .normal)
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNavigationButton)
	}
	
	@objc private func rightNavigationButtonTapped(_ button: UIButton) {
		viewModel.toggleEditMode()
		updateNavigationButtonTitle()
		tableView.reloadData()
	}
}

// MARK: - UITableViewDelegate
extension TimeZonesViewController {
	override func tableView(
		_ tableView: UITableView,
		didSelectRowAt indexPath: IndexPath) {
		guard viewModel.isEditing else { return }
		
		let timeZones = viewModel.visibleSections[indexPath.section].timeZones
		let customTimeZone = timeZones[indexPath.row]
		let identifier = customTimeZone.timeZone.identifier
		
		viewModel.didSelectTimeZone(identifier)
		delegate?.didUpdateTimeZones()
		tableView.reloadData()
	}
}

// MARK: - UITableViewDataSource
extension TimeZonesViewController {
	func tableView(
		_ tableView: UITableView,
		viewForHeaderInSection section: Int) -> UIView? {
		guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TimeZoneHeaderView.identifier) as? TimeZoneHeaderView else { return nil }
		view.delegate = self
		view.index = section
		
		let tableSection = viewModel.visibleSections[section]
		view.timeZoneLabel.text = tableSection.abbreviation
		
		if !viewModel.isEditing {
			view.datePicker.timeZone = TimeZone(abbreviation: tableSection.abbreviation)
			view.datePicker.date = viewModel.selectedDate
		}
		
		view.datePicker.isHidden = viewModel.isEditing
		
		return view
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return viewModel.visibleSections.count
	}
	
	override func tableView(
		_ tableView: UITableView,
		numberOfRowsInSection section: Int) -> Int {
		return viewModel.visibleSections[section].timeZones.count
	}
	
	override func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: TimeZoneCell.identifier,
				for: indexPath) as? TimeZoneCell else {
			return UITableViewCell()
		}
		
		let timeZones = viewModel.visibleSections[indexPath.section].timeZones
		let customTimeZone = timeZones[indexPath.row]
		let identifier = customTimeZone.timeZone.identifier
		let flagRepresentation = customTimeZone.decodableTimeZone.code.flagRepresentation
		
		cell.titleLabel.text = "\(flagRepresentation) \(identifier)"
		
		if viewModel.isEditing,  viewModel.selectedTimeZoneIdentifiers.contains(identifier) {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}
		
		return cell
	}
}

extension TimeZonesViewController: TimeZoneHeaderViewDelegate {
	func timeZoneHeaderView(_ view: TimeZoneHeaderView, didSelect date: Date) {
		viewModel.didSelect(date, at: view.index)
		tableView.reloadData()
	}
}
