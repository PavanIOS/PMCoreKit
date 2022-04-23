//
//  EmptyCollectionViewCell.swift
//  GPLibraryExample
//
//  Created by Rahul K. on 03/01/20.
//  Copyright © 2020 sn99. All rights reserved.
//

import UIKit

public class EmptyCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var bgView: CustomView!
    @IBOutlet weak var textLabel: CustomLabel!
    @IBOutlet weak var bgViewBottomHeight: NSLayoutConstraint!
    
    
    static let cellId = "EmptyCollectionViewCell"
    
    var cornerRadius : CGFloat = 0 {
        didSet{
            layer.cornerRadius = self.cornerRadius
            clipsToBounds = true
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bgView.backgroundColor = .clear
        
    }
    
    
    
    public override var isSelected: Bool {
        didSet {
           // self.setSelected(selected: isSelected)
        }
    }
    
    var cellSelected : Bool = false {
        didSet {
             self.setSelected(selected: cellSelected)
        }
    }
    
    func setSelected(selected:Bool){
        
        if selected {
            self.backgroundColor = Colors.themeColor
            self.textLabel.textColor = .white
        }else{
            self.backgroundColor = Colors.unSelected_gray
            self.textLabel.textColor = .black
        }
    }
    
    
    
    func setupShadow(){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.masksToBounds = false
    }
    
    
    func updateUI(_ bgColor:UIColor,_ font:UIFont){
        var inverseColor = Colors.white
        if bgColor.isLight {
            inverseColor = .black
        }
        self.backgroundColor = bgColor
        self.textLabel.textColor = inverseColor
        self.textLabel.font = font
    }
    
    func enableBgView(){
        bgViewBottomHeight.constant = 5
    }
    
}
