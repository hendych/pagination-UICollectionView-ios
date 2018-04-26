//
//  CustomCollectionViewCell.swift
//  pagination-collectionview
//
//  Created by Hendy Christianto on 26/04/18.
//  Copyright © 2018 Hendy Christianto. All rights reserved.
//

import Foundation
import UIKit


class CustomCollectionViewCell: UICollectionViewCell {
    static func getSize() -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    static func reuseIdentifier() -> String {
        return "CustomCollectionViewCell"
    }
}
