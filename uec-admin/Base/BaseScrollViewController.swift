import UIKit
import SnapKit

class BaseScrollViewController: BaseViewController {
	public let scrollView: UIScrollView = {
		let view = UIScrollView()
		view.alwaysBounceVertical = true
		view.backgroundColor = .systemBackground
		view.keyboardDismissMode = .interactive
		
		return view
	}()

	public let contentView: UIView = {
		let view = UIView()
		view.backgroundColor = .systemBackground
		
		return view
	}()

	// MARK: - View Lifecycle
	open override func loadView() {
		super.loadView()

		view.addSubview(scrollView)
		scrollView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}

		scrollView.addSubview(contentView)
		contentView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
			make.leading.equalTo(view)
			make.trailing.equalTo(view)
		}
	}
}
