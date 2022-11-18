//
//  MainScanCollectionViewCell.swift
//  TestTask
//
//  Created by Green on 17.11.2022.
//

import UIKit

enum EditState {
    case editing
    case normal
}

final class MainScanCollectionViewCell: UICollectionViewCell, CellConfiguring {
    
    private let previewImage = UIImageView()
    private let containerView = UIView()
    private let checkButton = UIButton(type: .system)
    private var editState: EditState?
    static var reuseID = String(describing: MainScanCollectionViewCell.self)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        previewImage.image = nil
    }
    
    private var viewModel: MainScanCollectionViewCellViewModelProtocol? {
        didSet {
            DispatchQueue.main.async {
                guard let viewModel = self.viewModel else { return }
                self.configureViewWith(viewModel)
            }
        }
    }
    
    /// setup cell function
    private func setupCell() {
        previewImage.setTamic()
        containerView.setTamic()
        checkButton.setTamic()
        
        self.addSubview(containerView)
        containerView.addSubview(previewImage)
        containerView.addSubview(checkButton)
        
        self.previewImage.layer.cornerRadius = 5
        self.previewImage.layer.borderColor = #colorLiteral(red: 0.8309500217, green: 0.9430729747, blue: 0.8926538229, alpha: 1)
        self.previewImage.layer.borderWidth = 1
        
        let image = R.image.uncheck()
        checkButton.setImage(image, for: .normal)
    }
    
    /// setup cells constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            previewImage.topAnchor.constraint(equalTo: containerView.topAnchor),
            previewImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            previewImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            previewImage.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            
            checkButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 9),
            checkButton.topAnchor.constraint(equalTo: self.topAnchor, constant: -9)
        ])
    }
    
    private func configureViewWith(_ viewModel: MainScanCollectionViewCellViewModelProtocol) {
        self.setNeedsLayout()
    }
    
    /// configure cell from data source
    /// - Parameter value: any type value
    func configure<U>(value: U) where U: Hashable {
        self.previewImage.image = UIImage()
        self.previewImage.backgroundColor = .systemFill
        self.setNeedsLayout()
    }
    
    /// draw function that contain animation logic for self
    /// - Parameter rect: CGRect
    override func draw(_ rect: CGRect) {
        guard let editState = editState, editState == .editing else {
            self.containerView.layer.removeAllAnimations()
            AnimationsService.startCheckButtonAnimation(alpha: 0, view: checkButton)
            return
        }
        let values: [CGFloat] = [0, 0.01 * 5.0, 0, 0.01 * -5.0, 0]
        AnimationsService.animateRotate(values: values, duration: 1.5, view: self.containerView)
        AnimationsService.startCheckButtonAnimation(alpha: 1, view: checkButton)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupConstraints()
        addObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeEditState),
                                               name: .changeEditingMode,
                                               object: nil)
    }
    
    @objc
    private func changeEditState() {
        self.editState = (self.editState != nil && self.editState == .editing) ? .normal : .editing
        self.draw(CGRect())
    }
}
