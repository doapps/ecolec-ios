//
//  CategoriesCollectionViewCell.swift
//  Ecolec
//
//  Created by Nicolas on 6/1/19.
//  Copyright © 2019 Nicolas. All rights reserved.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            nameLabel.textColor = isSelected ? .blue : .black
        }
    }
    
}
