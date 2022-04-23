//
//  CustomDetailTableViewCell.swift
//  INCEIS
//
//  Created by sn99 on 17/06/20.
//

import UIKit

class CustomDetailTableViewCell: CustomTableViewCell {
    
    @IBOutlet weak var stackView: CustomStackView!
    @IBOutlet weak var textLbl: CustomLabel!
    @IBOutlet weak var detailTxtLbl: CustomLabel!
    
    
    static let cellId = "CustomDetailTableViewCell"
    
    
    var spacing : UIEdgeInsets? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        initCell()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if let spacer = spacing {
            contentView.frame = contentView.frame.inset(by: spacer)
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func initCell(){
        textLbl.numberOfLines = 0
        textLbl.lineBreakMode = .byWordWrapping
        
        
        detailTxtLbl.textAlignment = .left
        detailTxtLbl.numberOfLines = 0
        detailTxtLbl.lineBreakMode = .byWordWrapping
    }
    
    func setupDetailCell(){
        self.stackView.axis = .vertical
        textLbl.textAlignment = .left
        detailTxtLbl.textAlignment = .left
        
    }
    
    func setupRightDetailCell(){
        self.stackView.axis = .horizontal
        textLbl.textAlignment = .left
        detailTxtLbl.textAlignment = .right
    }
    
    func setAsNormalCell(){
        textLbl.textColor = .black
        detailTxtLbl.textColor = .black
        textLbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        detailTxtLbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    
    func setAsDetailCell(){
        textLbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        detailTxtLbl.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        textLbl?.textColor = .black
        detailTxtLbl.textColor = .darkGray
    }
    
}
