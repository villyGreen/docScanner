//
//  ScanDocumentModel.swift
//  TestTask
//
//  Created by Green on 17.11.2022.
//

import UIKit

struct ScanDocument {
    var previewImage = UIImage()
    var id = UUID()
}

extension ScanDocument: Hashable {
    static func == (lhs: ScanDocument, rhs: ScanDocument) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
