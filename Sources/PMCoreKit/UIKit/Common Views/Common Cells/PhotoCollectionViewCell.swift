//
//  PhotoCollectionViewCell.swift
//  GPLibraryExample
//
//  Created by sn99 on 17/12/19.
//  Copyright © 2019 sn99. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: CustomImageView!
    
    static let cellId = "PhotoCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
