//
//  ViewController.swift
//  TestTask
//
//  Created by Green on 16.11.2022.
//

import AVFoundation
import Rswift
import UIKit

final class MainScanViewController: UIViewController {
    // MARK: - Private ui properties
    private var scrollView: UIScrollView?
    private var collectionView: UICollectionView?
    private var contentView: UIView?
    private var longPressGesture: UILongPressGestureRecognizer?
    private var mainTabBar: TabBarViewController {
        return (self.tabBarController as? TabBarViewController) ?? TabBarViewController()
    }
    
    // MARK: ViewModel - Buisness Logic
    var viewModel: MainScanViewModel?
    
    // MARK: - Internal properties
    var dataSource: UICollectionViewDiffableDataSource<Section, ScanDocument>?
    var snapShot = NSDiffableDataSourceSnapshot<Section, ScanDocument>()
    
    // MARK: - Private properties
    var editState: EditState?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionViewDataSource()
        reloadData()
        setDelegate()
    }
}

// MARK: - UI
private extension MainScanViewController {
    
    /// main func that contains all functions for setup view
    private func setupUI() {
        setupNavigationBar()
        setupScrollView()
        setupCollectionView()
    }
}

// MARK: - Naviagation
private extension MainScanViewController {
    
    /// setup naviagation bar
    private func setupNavigationBar() {
        self.title = "Scans"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(settingsAction))
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc
    private func settingsAction() {
        self.makeTapticResponse(style: .soft)
    }
}

// MARK: - ScrollView
private extension MainScanViewController {
    /// scroll view setup
    private func setupScrollView() {
        self.view.backgroundColor = .white
        self.scrollView = UIScrollView()
        guard let scrollView = self.scrollView else { return }
        scrollView.setTamic()
        scrollView.backgroundColor = .clear
        
        self.view.addSubview(scrollView)
        
        contentView = UIView()
        guard let contentView = self.contentView else { return }
        contentView.setTamic()
        
        scrollView.addSubview(contentView)
        scrollViewConstraints(scrollView: scrollView, contentView: contentView)
    }
    
    /// scroll view constraints setup
    /// - Parameters:
    ///   - scrollView: source scroll view
    ///   - contentView: source content view
    private func scrollViewConstraints(scrollView: UIScrollView, contentView: UIView) {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),
            contentView.heightAnchor.constraint(equalToConstant: 1500)
        ])
    }
}

// MARK: - Collection View Layout
private extension MainScanViewController {
    
    /// setup compositional collection view layout
    /// - Returns: UICollectionViewLayout
    private func setupCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) ->
            NSCollectionLayoutSection? in
            guard let section = Section(rawValue: sectionIndex)
            else { fatalError("Unknown section") }
            switch section {
            case .list:
                return self.setupLayout()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
        
    }
    /// setup collection view layout
    /// - Returns: NSCollectionLayoutSection
    private func setupLayout() -> NSCollectionLayoutSection {
        // itemSize -> item -> groupSize -> groups -> section
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(116), heightDimension: .estimated(143))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16)
        let sectionHeader = createHeaderSection()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
}

// MARK: - Collection view setup
extension MainScanViewController {
    
    /// create header sections func
    /// - Returns: NSCollectionLayoutBoundarySupplementaryItem
    private func createHeaderSection() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .estimated(1))
        let elementKindsection = UICollectionView.elementKindSectionHeader
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                        elementKind: elementKindsection,
                                                                        alignment: .top)
        return sectionHeader
    }
    
    /// setup collection view
    private func setupCollectionView() {
        let size = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        collectionView = UICollectionView(frame: CGRect(origin: .zero, size: size),
                                          collectionViewLayout: setupCompositionalLayout())
        collectionView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView?.backgroundColor = .clear
        collectionView?.register(MainScanCollectionViewCell.self,
                                 forCellWithReuseIdentifier: MainScanCollectionViewCell.reuseID)
        collectionView?.register(SectionHeader.self, forSupplementaryViewOfKind:
                                    UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: SectionHeader.reuseId)
        scrollView?.addSubview(collectionView ?? UICollectionView())
        collectionView?.delegate = self
        setupLongPressGesture()
    }
    
    /// long press gesture setup
    private func setupLongPressGesture() {
        self.longPressGesture = UILongPressGestureRecognizer()
        guard let longPressGesture = self.longPressGesture else { return }
        longPressGesture.delegate = self
        longPressGesture.minimumPressDuration = 0.3
        collectionView?.addGestureRecognizer(longPressGesture)
    }
    
    /// create snapshot
    /// - Returns: NSDiffableDataSourceSnapshot<Section, ScanDocument>
    func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, ScanDocument> {
        return NSDiffableDataSourceSnapshot<Section, ScanDocument>()
    }
    
    /// reload data function
    func reloadData() {
        var snapShot = createSnapshot()
        snapShot.appendSections([.list])
        snapShot.appendItems([ScanDocument(), ScanDocument()], toSection: .list)
        dataSource?.apply(snapShot, animatingDifferences: true)
    }
}

// MARK: - Collection View DataSource
extension MainScanViewController {
    /// setup collection view data source
    private func setupCollectionViewDataSource() {
        // swiftlint:disable all
        /// setup collection view cells
        dataSource = UICollectionViewDiffableDataSource<Section, ScanDocument>(collectionView:
                                                                                collectionView ?? UICollectionView()) {
            (collectionView, indexPath, data) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            switch section {
            case .list:
                return self.configureCell(collectionView: collectionView, cellType: MainScanCollectionViewCell.self,
                                          model: data,
                                          indexPath: indexPath)
            }
        }
        /// setup collection view header
        self.dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                      withReuseIdentifier: SectionHeader.reuseId,
                                                                                      for: indexPath) as? SectionHeader else {
                fatalError()
            }
            guard let _ = Section(rawValue: indexPath.section) else {
                fatalError()
            }
            
            let context = HeaderContext(title: R.string.localizable.firstHeader("\(indexPath.section)"),
                                        font: R.font.sfProDisplayRegular(size: 17) ?? UIFont(),
                                        textColor: .black,
                                        headerAlpha: 1)
            sectionHeader.configureHeader(context)
            return sectionHeader
        }
    }
}
// MARK: - Collection View Delegate
extension MainScanViewController: UICollectionViewDelegate {
    /// collection view delegate method
    /// - Parameters:
    ///   - collectionView: source collection view
    ///   - indexPath: index path at selected row
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

// MARK: - Gesture Delegate
extension MainScanViewController: UIGestureRecognizerDelegate {
    
    /// handle gesture event
    /// - Parameter gestureRecognizer: UIGestureRecognizer
    /// - Returns: Bool
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard editState != .editing else { return false }
        NotificationCenter.default.post(name: .changeEditingMode, object: nil)
        self.makeTapticResponse(style: .heavy)
        animateTabBar()
        self.editState = .editing
        return true
    }
}

// MARK: - TabBarDelegate
extension MainScanViewController: TabBarProtocolDelegate {
    
    /// set delegates on viewController
    func setDelegate() {
        mainTabBar.tabBarDelegate = self
    }
    
    /// activate/deactive editing mode with animate
    func editButtonIsTapped() {
        self.editState = (self.editState != nil && self.editState == .editing) ? .normal : .editing
        NotificationCenter.default.post(name: .changeEditingMode, object: nil)
        guard editState == .normal else {
            self.animateTabBar()
            return
        }
        UIView.animate(withDuration: 0.2) {
            self.mainTabBar.editButton?.layer.removeAllAnimations()
            self.mainTabBar.addGroupButton?.isHidden = false
            self.mainTabBar.addFileButton?.isHidden = false
            self.mainTabBar.addGroupButton?.alpha = 1
            self.mainTabBar.addFileButton?.alpha = 1
        }
    }
}

// MARK: - Animations
extension MainScanViewController {
    /// start animate when editing mode is active
    private func animateTabBar() {
        UIView.animate(withDuration: 0.2) {
            self.mainTabBar.addGroupButton?.alpha = 0
            self.mainTabBar.addFileButton?.alpha = 0
            self.mainTabBar.editButton?.alpha = 0
            let values: [CGFloat] = [0, 0.03 * 5.0, 0, 0.03 * -5.0, 0]
            AnimationsService.animateRotate(values: values,
                                            duration: 1.5, view: self.mainTabBar.editButton!)
        } completion: { _ in
            self.mainTabBar.addGroupButton?.isHidden = true
            self.mainTabBar.addFileButton?.isHidden = true
            UIView.animate(withDuration: 0.1) {
                self.mainTabBar.editButton?.alpha = 1
            }
        }
    }
}
