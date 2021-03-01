import UIKit
import SnapKit

protocol TimeZonesViewControllerDelegate: AnyObject {
	func didUpdateTimeZones()
}

class TimeZonesViewController: BaseTableViewController {
	weak var delegate: TimeZonesViewControllerDelegate?
	
	private let viewModel = TimeZonesViewModel()
	
	private lazy var searchBar: UISearchBar = {
		let bar = UISearchBar()
		bar.searchBarStyle = .prominent
		bar.placeholder = "Ne baktın?"
		bar.delegate = self
		return bar
	}()
	
	private let rightNavigationButton: UIButton = {
		let button = UIButton(type: .custom)
		button.setTitleColor(.systemBlue, for: .normal)
		return button
	}()
	
	override init() {
		super.init()
		
		let dnc = NotificationCenter.default
		
		dnc.addObserver(
			self,
			selector: #selector(didReceiveKeyboardWillShowNotification(_:)),
			name: UIResponder.keyboardWillShowNotification,
			object: nil)
		
		dnc.addObserver(
			self,
			selector: #selector(didReceiveKeyboardWillHideNotification(_:)),
			name: UIResponder.keyboardWillHideNotification,
			object: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
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
		navigationController?.navigationBar.prefersLargeTitles = false
		
		view.addSubview(searchBar)
		searchBar.snp.makeConstraints { make in
			make.leading.top.trailing.equalToSuperview()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Time Zones"
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNavigationButton)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		searchBar.layoutIfNeeded()
		updateSearchBarVisibility()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		guard !viewModel.isEditing,
			  let sectionIndex = viewModel.currentTimeZoneIndex else { return }
		
		tableView.scrollToRow(
			at: IndexPath(row: 0, section: sectionIndex),
			at: .top,
			animated: true)
	}
	
	private func updateNavigationButtonTitle() {
		let title = viewModel.isEditing ? "Save" : "Edit"
		rightNavigationButton.setTitle(title, for: .normal)
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNavigationButton)
	}
	
	@objc private func rightNavigationButtonTapped(_ button: UIButton) {
		viewModel.toggleEditMode()
		searchBar.text = ""
		updateNavigationButtonTitle()
		updateSearchBarVisibility()
		tableView.reloadData()
		
		if viewModel.isEditing {
			searchBar.becomeFirstResponder()
		} else {
			view.endEditing(true)
		}
	}
	
	private func updateSearchBarVisibility() {
		var insets = tableView.contentInset
		insets.top = viewModel.isEditing ? searchBar.frame.size.height : 0
		
		tableView.contentInset = insets
		tableView.scrollIndicatorInsets = insets
		
		searchBar.isHidden = !viewModel.isEditing
	}
	
	@objc func didReceiveKeyboardWillShowNotification(
		_ notification: Notification) {
		if !(self.isViewLoaded && self.view.window != nil) { return }
		if UIApplication.shared.applicationState != .active { return }

		var insets = tableView.contentInset

		guard let userInfo = (notification as NSNotification).userInfo else {
			return
		}

		guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
			return
		}

		let keyboardHeight = keyboardFrame.cgRectValue.size.height
		insets.bottom = keyboardHeight
		tableView.scrollIndicatorInsets = insets
		tableView.contentInset = insets
	}
	
	@objc func didReceiveKeyboardWillHideNotification(
		_ notification: Notification) {
		if !(self.isViewLoaded && self.view.window != nil) { return }
		if UIApplication.shared.applicationState != .active { return }

		var insets = tableView.contentInset
		insets.bottom = view.safeAreaInsets.bottom
		tableView.scrollIndicatorInsets = insets
		tableView.contentInset = insets
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
		let formattedTimeZoneIdentifier = customTimeZone.formattedTimeZoneIdentifier
		let flagRepresentation = customTimeZone.decodableTimeZone.code.flagRepresentation
		
		cell.titleLabel.text = "\(flagRepresentation) \(formattedTimeZoneIdentifier)"
		
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

extension TimeZonesViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
		
		viewModel.currentFilterText = trimmedText
		tableView.reloadData()
	}
}
