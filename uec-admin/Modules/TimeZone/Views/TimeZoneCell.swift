import UIKit
import SnapKit

class TimeZoneCell: UITableViewCell {
	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.preferredFont(forTextStyle: .title2)
		label.textColor = .label
		return label
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		selectionStyle = .none
		
		contentView.addSubview(titleLabel)
		titleLabel.snp.makeConstraints { make in
			make.edges.equalToSuperview().inset(16)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
