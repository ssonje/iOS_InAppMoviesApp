import Foundation
import UIKit

class MovieGenericTypeDetailView: UIView {

    // MARK: - UI Properties

    private lazy var name: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func configure(text: String) {
        name.text = text
        setup()
    }

    // MARK: - Private Helpers

    private func setup() {
        addSubview(name)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: topAnchor),
            name.bottomAnchor.constraint(equalTo: bottomAnchor),
            name.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            name.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
        ])
    }
}
