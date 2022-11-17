//
//  AnimationsService.swift
//  TestTask
//
//  Created by Green on 17.11.2022.
//

import UIKit

final class AnimationsService {
    // MARK: - Rotate animations
    static func animateRotate(values: [CGFloat], duration: CGFloat, view: UIView) {
        let animateKeyFramae = CAKeyframeAnimation(keyPath: #keyPath(CALayer.transform))
        animateKeyFramae.values = values
        animateKeyFramae.duration = duration
        animateKeyFramae.isAdditive = true
        animateKeyFramae.valueFunction = CAValueFunction(name: .rotateZ)
        animateKeyFramae.repeatCount = .infinity
        view.layer.add(animateKeyFramae, forKey: "spinAnimation")
    }
    
    // MARK: - Change alpha animate
    static func startCheckButtonAnimation(alpha: CGFloat, view: UIView) {
        UIView.animate(withDuration: 0.3) {
            view.alpha = alpha
        }
    }
    
}
