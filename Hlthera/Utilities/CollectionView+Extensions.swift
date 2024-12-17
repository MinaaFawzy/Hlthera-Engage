//
//  CollectionView+Extensions.swift
//  Hlthera
//
//  Created by Bishoy Badea [Pharma] on 21/03/2023.
//  Copyright © 2023 Fluper. All rights reserved.
//

import UIKit

extension UICollectionViewFlowLayout {
    open override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        LocalizationManager.shared.getLanguage() == .Arabic
    }
}


