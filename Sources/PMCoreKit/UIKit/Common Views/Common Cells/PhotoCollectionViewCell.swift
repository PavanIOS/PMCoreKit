//
//  PhotoCollectionViewCell.swift
//  GPLibraryExample
//
//  Created by sn99 on 17/12/19.
//  Copyright © 2019 sn99. All rights reserved.
//

import UIKit

public class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: CustomImageView!
    
    static let cellId = "PhotoCollectionViewCell"
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
