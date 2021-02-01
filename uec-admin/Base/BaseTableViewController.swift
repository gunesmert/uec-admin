import UIKit
import SnapKit

class BaseTableViewController: BaseViewController {
	lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.backgroundColor = .systemBackground
		tableView.delegate = self
		tableView.dataSource = self
		tableView.keyboardDismissMode = .interactive
		tableView.separatorInset = .zero
		
		return tableView
	}()
	
	// MARK: - View Lifecycle
	override func loadView() {
		super.loadView()
		
		view.addSubview(tableView)
		view.sendSubviewToBack(tableView)
		
		tableView.snp.makeConstraints { (maker) in
			maker.edges.equalToSuperview()
		}
	}
}

// MARK: - UITableViewDelegate
extension BaseTableViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
}

// MARK: - UITableViewDataSource
extension BaseTableViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 0
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
}

