//
//  MainScanCollectionViewCell.swift
//  TestTask
//
//  Created by Green on 17.11.2022.
//

import UIKit

class MainScanCollectionViewCell: UICollectionViewCell, CellConfiguring {
    let previewImage = UIImageView()
    let containerView = UIView()
    static var reuseID = String(describing: MainScanCollectionViewCell.self)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        previewImage.image = nil
    }
    
    var viewModel: MainScanCollectionViewCellViewModelProtocol? {
        didSet {
            DispatchQueue.main.async {
                guard let viewModel = self.viewModel else { return }
                self.configureViewWith(viewModel)
            }
        }
    }

    private func setupCell() {
        previewImage.setTamic()
        containerView.setTamic()

        self.addSubview(containerView)
        containerView.addSubview(previewImage)
        self.previewImage.backgroundColor = .systemFill
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            previewImage.topAnchor.constraint(equalTo: containerView.topAnchor),
            previewImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            previewImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            previewImage.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
    }
    
    private func configureViewWith(_ viewModel: MainScanCollectionViewCellViewModelProtocol) {
//        self.previewImage.image = viewModel.im
        self.setNeedsLayout()
//        self.layoutIfNeeded()
    }
    
    func configure<U>(value: U) where U: Hashable {
        self.previewImage.image = UIImage()
        self.previewImage.backgroundColor = .blue
        self.setNeedsLayout()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
