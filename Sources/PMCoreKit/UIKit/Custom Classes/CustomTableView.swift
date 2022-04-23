

import UIKit

public class CustomTableView: UITableView {
    
    
    public enum EffectEnum {
        case roll
        case LeftAndRight
    }
    
    
    var registerCells = [String]()
    var registerHeaders = [String]()
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetup()
    }
    
    func initialSetup(){
        
        
        self.registerTableCells()
        self.registerHeaderViews()
        self.tableFooterView = UIView()
        self.alwaysBounceHorizontal = false
        self.keyboardDismissMode = .interactive
    }
    
    
    func registerTableCells(){
        registerCells.append("CustomDetailTableViewCell")
        registerCells.append("DetailTableViewCell")
        registerCells.append("EmptyTableViewCell")
        registerCells.append("RightDetailTableViewCell")
        registerCells.append(LogoTableViewCell.cellId)
        registerCells.append(InputStackTableViewCell.cellId)
        
        
        for cellId in registerCells {
            registerNewCell(cellId: cellId)
        }
    }
    
    func registerHeaderViews(){
        registerHeaders = registerCells
        for headerId in registerHeaders {
            self.register(UINib(nibName: headerId, bundle: nil), forHeaderFooterViewReuseIdentifier: headerId)
        }
    }
    
    func registerNewCell(cellId:String){
       self.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    func registerNewHeaderView(headerId:String){
        self.register(UINib(nibName: headerId, bundle: nil), forHeaderFooterViewReuseIdentifier: headerId)
    }
    
    
    func removeGroupTableTopMargin(_ topHeight: CGFloat = 0){
        var frame = CGRect.zero
        
        if topHeight > 0 {
            frame.size.height = topHeight
        }else{
            frame.size.height = .leastNormalMagnitude
        }
        
        self.tableHeaderView = UIView(frame: frame)
    }
    
    func reloadRow(_ section:Int,_ row:Int,_ animation:RowAnimation = RowAnimation.none) {
        let indexPath = IndexPath(row: row, section: section)
        self.reloadRows(at: [indexPath], with: animation)
    }
    
    func applyLargeTitlesFix() {
        let originalInset = self.contentInset
        self.contentInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 0)
        DispatchQueue.main.async { [weak self] in
            self?.contentInset = originalInset
        }
    }
    
    
    func dynamicRowSize(_ estHeight:CGFloat = 100){
        self.estimatedRowHeight = estHeight
        self.rowHeight = UITableView.automaticDimension
    }
    
    func dynamicSectionHeaderSize(_ estHeight:CGFloat=100){
        self.estimatedSectionHeaderHeight = estHeight
        self.sectionHeaderHeight = UITableView.automaticDimension
    }
    
    func dynamicSectionFooterSize(_ estHeight:CGFloat=100){
        self.estimatedSectionFooterHeight = estHeight
        self.sectionFooterHeight = UITableView.automaticDimension
    }
    
    
    
    public func reloadData(_ effect: EffectEnum) {
        self.reloadData()
        
        switch effect {
        case .roll:
            roll()
            break
        case .LeftAndRight:
            leftAndRightMove()
            break
        }
        
    }
    
    private func roll() {
        let cells = self.visibleCells
        
        let tableViewHeight = self.bounds.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        
        for cell in cells {
            UIView.animate(withDuration: 2, delay: Double(delayCounter) * 0.035, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    private func leftAndRightMove() {
        let cells = self.visibleCells
        
        let tableViewWidth = self.bounds.width
        
        var alternateFlag = false
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: alternateFlag ? tableViewWidth : tableViewWidth * -1, y: 0)
            alternateFlag = !alternateFlag
        }
        
        var delayCounter = 0
        
        for cell in cells {
            UIView.animate(withDuration: 2, delay: Double(delayCounter) * 0.035, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    
}


public class SelfSizedTableView: CustomTableView {
    
    override open var contentSize: CGSize {
        didSet { // basically the contentSize gets changed each time a cell is added
            // --> the intrinsicContentSize gets also changed leading to smooth size update
            if oldValue != contentSize {
                invalidateIntrinsicContentSize()
            }
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        self.isScrollEnabled = false
        return CGSize(width: contentSize.width, height: contentSize.height)
    }
    
}



public extension UITableView {
    
    func isLastSection(section:Int) -> Bool{
        let totalSections = self.numberOfSections
        
        if section == totalSections - 1 {
            return true
        }
        return false
    }
    
    func isLastRow(indexPath:IndexPath) -> Bool {
        let totalRows = self.numberOfRows(inSection: indexPath.section)
        
        if indexPath.row == totalRows - 1 {
            return true
        }
        return false
    }
}
