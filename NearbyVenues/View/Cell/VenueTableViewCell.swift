//
//  VenueTableViewCell.swift
//  NearbyVenues
//
//  Created by Bogumiła Kochańska-Nawojczyk on 19/11/2019.
//

import UIKit

final class VenueTableViewCell: UITableViewCell {
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var addressStackView: UIStackView!
    @IBOutlet private var distanceLabel: UILabel!

    private var addressLabels: [UILabel] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        removeAddressViews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        distanceLabel.text = nil
        removeAddressViews()
    }

    func configure(presentable: VenuePresentableData) {
        nameLabel.text = presentable.name
        distanceLabel.text = presentable.distance

        presentable.address.forEach {
            let addressLabel = UILabel()
            addressLabel.font = UIFont.systemFont(ofSize: 15)
            addressLabel.textColor = .black
            addressLabel.numberOfLines = 0
            addressLabel.text = $0
            addressLabels.append(addressLabel)
            addressStackView.addArrangedSubview(addressLabel)
        }
        layoutSubviews()
    }

    private func removeAddressViews() {
        addressStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        addressLabels = []
    }
}
