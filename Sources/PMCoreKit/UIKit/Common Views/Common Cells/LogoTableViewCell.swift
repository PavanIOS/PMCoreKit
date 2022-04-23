//
//  LogoTableViewCell.swift
//  GpHealthPlus
//
//  Created by sn99 on 20/05/20.
//

import UIKit


protocol LogoTableViewCellDelegate : AnyObject {
    func didTapCompanyLogo()
}

public class LogoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var companyLogoButton: CustomButton!
    @IBOutlet weak var versionLbl: CustomLabel!
    
    
   // weak var delegate : LogoTableViewCellDelegate?
    
    
    static let cellId = "LogoTableViewCell"
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initCell()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func initCell(){
        self.selectionStyle = .none
        companyLogoButton.titleColor = Colors.themeColor
        companyLogoButton.titleLabel?.textAlignment = .center
        updateData()
    }
    
    func updateData(){
        let attString = NSMutableAttributedString().normal("Product by ").bold("Regent")
        companyLogoButton.setAttributedTitle(attString, for: .normal)
        self.versionLbl.text = getAppVersion()
    }
    
    
    @IBAction func logoClicked(_ sender: CustomButton) {
        let url = ""
        let title = "Regent"
            CommonViewUtilities.openWebView(url,title , nil)
      //  delegate?.didTapCompanyLogo()
    }
    

    
    
}
