//
//  MainScanViewModel.swift
//  TestTask
//
//  Created by Green on 17.11.2022.
//

import Foundation

protocol MainScanViewModelProtocol {
//    var photosCount: Int { get }
}

final class MainScanViewModel {

    var isError: ((Error) -> Void)?
    var isLoading: ((Bool) -> Void)?

    let mainScanServiceQueue =
    DispatchQueue(label: "MainScanServiceQueue")

    private let model: ScanDocument
    private let useCase: ScanDocument

    init(withModel model: ScanDocument, withUsecase useCase: ScanDocument) {
        self.model = model
        self.useCase = useCase
    }
}

extension MainScanViewModel: MainScanViewModelProtocol {
    
}
