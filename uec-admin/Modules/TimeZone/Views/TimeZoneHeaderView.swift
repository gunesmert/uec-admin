import UIKit
import SnapKit

protocol TimeZoneHeaderViewDelegate: AnyObject {
	func timeZoneHeaderView(_ view: TimeZoneHeaderView, didSelect date: Date)
}

class TimeZoneHeaderView: UITableViewHeaderFooterView {
	weak var delegate: TimeZoneHeaderViewDelegate?
	var index: Int = 0
	
	let timeZoneLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.preferredFont(forTextStyle: .subheadline)
		label.textColor = UIColor.darkText.withAlphaComponent(0.7)
		label.textAlignment = .right
		label.numberOfLines = 0
		
		return label
	}()
	
	let stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.spacing = 8
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.distribution = .fillEqually
		
		return stackView
	}()
	
	let datePicker: UIDatePicker = {
		let datePicker = UIDatePicker()
		datePicker.datePickerMode = .dateAndTime
		datePicker.preferredDatePickerStyle = .compact
		datePicker.addTarget(
			self,
			action: #selector(dateValueChanged),
			for: .valueChanged)
		
		return datePicker
	}()
	
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		
		contentView.addSubview(stackView)
		stackView.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview().inset(8)
			make.leading.trailing.equalToSuperview().inset(16)
		}
		
		stackView.addArrangedSubview(datePicker)
		stackView.addArrangedSubview(timeZoneLabel)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc private func dateValueChanged() {
		delegate?.timeZoneHeaderView(self, didSelect: datePicker.date)
	}
}
