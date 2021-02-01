import UIKit

class BaseNavigationController: UINavigationController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .systemBackground
		
		navigationBar.isTranslucent = false
		navigationBar.prefersLargeTitles = true
	}
}
