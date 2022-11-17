//
//  MainScanViewSetup.swift
//  TestTask
//
//  Created by Green on 17.11.2022.
//

import Foundation

enum Section: Int, CaseIterable {
    case list
}

protocol CellConfiguring: NSObjectProtocol {
    func configure<U: Hashable>(value: U)
    static var reuseID: String { get set }
}
