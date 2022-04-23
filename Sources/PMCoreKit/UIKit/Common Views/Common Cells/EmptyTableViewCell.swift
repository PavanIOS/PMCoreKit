//
//  EmptyTableViewCell.swift
//  pms
//
//  Created by pavan M. on 1/28/19.
//  Copyright © 2019 Sekhar n. All rights reserved.
//

import UIKit

class EmptyTableViewCell: CustomTableViewCell {
    
    static let cellId = "EmptyTableViewCell"
    
    
    var spacing : UIEdgeInsets? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.updateCell()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if let spacer = spacing {
            contentView.frame = contentView.frame.inset(by: spacer)
        }
    }
    
    func updateCell(){
        self.imageView?.image = nil
    }
    
    func resetCell(){
        self.selectedBackgroundView = nil
        self.selectionStyle = .default
    }
    func initializeCell(){
        self.textLabel?.numberOfLines = 0
        self.selectionStyle = .none
        self.accessoryType = .none
        self.imageView?.image = nil
        
    }

    
    
    func changeTextColor(_ color:UIColor,_ bgColor:UIColor){
        self.textLabel?.textColor = color
        self.backgroundColor = bgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
