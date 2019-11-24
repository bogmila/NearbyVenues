//
//  MessageView.swift
//  NearbyVenues
//
//  Created by Bogumiła Kochańska-Nawojczyk on 24/11/2019.
//

import UIKit

final class MessageView: UIView {
    @IBOutlet private var contentView: UIView!

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var actionButton: UIButton!

    private var action: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func setup(title: String, description: String?, actionTitle: String?, action: (() -> Void)?) {
        titleLabel.text = title
        descriptionLabel.text = description
        actionButton.isHidden = actionTitle == nil
        actionButton.setTitle(actionTitle, for: .normal)
        self.action = action
    }

    @IBAction private func didTapActionButton() {
        action?()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: MessageView.self), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
