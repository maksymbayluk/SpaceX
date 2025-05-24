//
//  RocketCell.swift
//  SpaceX
//
//  Created by Максим Байлюк on 22.05.2025.
//
import UIKit

final class RocketCell: UITableViewCell {
    static let reuseIdentifier = "RocketCell"

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, detailsLabel])
        stackView.axis = .vertical
        stackView.spacing = 4

        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }

    func configure(with rocket: Rocket) {
        nameLabel.text = rocket.name

        let firstFlight = "First flight: \(rocket.first_flight)"
        let successRate = "Success rate: \(rocket.success_rate_pct)%"
        let height = "Height: \(rocket.height.meters ?? 0)m"
        let diameter = "Diameter: \(rocket.diameter.meters ?? 0)m"
        let mass = "Mass: \(rocket.mass.kgs ?? 0)kg"

        detailsLabel.text = [firstFlight, successRate, height, diameter, mass].joined(separator: "\n")
    }
}
