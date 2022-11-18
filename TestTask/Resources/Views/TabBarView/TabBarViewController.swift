//
//  TabBarViewController.swift
//  TestTask
//
//  Created by Green on 16.11.2022.
//

import Rswift
import UIKit

private enum TabBarButton: Int {
    case edit
    case addSection
    case addFile
    
    var image: UIImage? {
        switch self {
        case .edit: return R.image.editButton()
        case .addSection: return R.image.addGroup()
        case .addFile: return R.image.plusButton()
        }
    }
}

final class TabBarViewController: UITabBarController {
    
    var tabBarView: UIView?
    var editButton: UIButton?
    var addGroupButton: UIButton?
    var addFileButton: UIButton?
    var buttonsStackView: UIStackView?
    weak var tabBarDelegate: TabBarProtocolDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        // Do any additional setup after loading the view.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

// MARK: - UI
private extension TabBarViewController {
    private func setupTabBar() {
        self.tabBar.isHidden = true
        let mainScreen = MainScanViewController()
        let navigationViewController = UINavigationController(rootViewController: mainScreen)
        self.viewControllers = [navigationViewController]
        setupTabBarView()
        initButtons()
        setupConstraints()
    }
    
    private func setupConstraints() {
        guard let tabBarView = self.tabBarView,
              let buttonsStackView = self.buttonsStackView,
              let editButton = editButton,
              let addGroupButton = addGroupButton else { return }
        let multValue = ConstantsHelper.tabBarHeightMultValue
        let buttonsConstant = ConstantsHelper.tabBarLeadingAndTrailingConstraint
        let buttonsTopConsraint = ConstantsHelper.tabBarTopConstraint
        let buttonRadius = ConstantsHelper.buttonOpacityRadius
        
        NSLayoutConstraint.activate([
            tabBarView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tabBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tabBarView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: multValue),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: buttonsConstant),
            buttonsStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -buttonsConstant),
            buttonsStackView.topAnchor.constraint(equalTo: tabBarView.topAnchor, constant: buttonsTopConsraint),
            editButton.heightAnchor.constraint(equalToConstant: buttonRadius),
            editButton.widthAnchor.constraint(equalToConstant: buttonRadius),
            addGroupButton.heightAnchor.constraint(equalToConstant: buttonRadius),
            addGroupButton.widthAnchor.constraint(equalToConstant: buttonRadius)
        ])
    }
    
    private func setupButtonsStackView(_ buttons: [UIButton?]) {
        
        guard let views = buttons as? [UIView] else { return }
        buttonsStackView = UIStackView(arrangedSubviews: views)
        buttonsStackView?.setTamic()
        buttonsStackView?.axis = .horizontal
        buttonsStackView?.spacing = 16
        buttonsStackView?.alignment = .center
        buttonsStackView?.distribution = .equalSpacing
        tabBarView?.addSubview(buttonsStackView ?? UIStackView())
    }
    
    private func initButtons() {
        self.addGroupButton = UIButton(type: .system)
        self.editButton = UIButton(type: .system)
        self.addFileButton = UIButton(type: .system)
        
        let buttons = [editButton, addFileButton, addGroupButton]
        setupButton(editButton ?? UIButton(), type: .edit, selector: #selector(editAction))
        setupButton(addFileButton ?? UIButton(), type: .addFile, selector: #selector(addFileAction))
        setupButton(addGroupButton ?? UIButton(), type: .addSection, selector: #selector(addGroup))
        setupButtonsStackView(buttons)
    }
    
    private func setupButton(_ button: UIButton, type: TabBarButton, selector: Selector) {
        let size = ConstantsHelper.tabBarButtonSize
        button.setImage(type.image, for: .normal)
        button.setTamic()
        button.frame = CGRect(origin: .zero, size: CGSize(width: size, height: size))
        button.addTarget(self, action: selector, for: .touchUpInside)
    }
    
    private func setupTabBarView() {
        self.tabBarView = UIView()
        self.tabBarView?.setTamic()
        self.tabBarView?.backgroundColor = .white
        self.view.addSubview(tabBarView ?? UIView())
    }
}

// MARK: - Handlers
private extension TabBarViewController {
    @objc
    private func editAction() {
        self.makeTapticResponse(style: .soft)
        tabBarDelegate?.editButtonIsTapped()
    }
    
    @objc
    private func addFileAction() {
        self.makeTapticResponse(style: .rigid)
    }
    
    @objc
    private func addGroup() {
        self.makeTapticResponse(style: .soft)
    }
}
