//
//  SectionHeader.swift
//  TestTask
//
//  Created by Green on 17.11.2022.
//

import UIKit

struct HeaderContext {
    var title: String
    var font: UIFont
    var textColor: UIColor
    var headerAlpha: CGFloat
}

class SectionHeader: UICollectionReusableView {
    
    static let reuseId = String(describing: SectionHeader.self)
    private let previewTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTitle() {
        previewTitle.setTamic()
        self.addSubview(previewTitle)
        
        NSLayoutConstraint.activate([
            previewTitle.topAnchor.constraint(equalTo: self.topAnchor),
            previewTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            previewTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            previewTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func configureHeader(_ context: HeaderContext) {
        previewTitle.alpha = context.headerAlpha
        previewTitle.text = context.title
        previewTitle.font = context.font
        previewTitle.textColor = context.textColor
    }
}
