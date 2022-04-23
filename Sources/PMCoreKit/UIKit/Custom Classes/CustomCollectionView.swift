


import UIKit

class CustomCollectionView: UICollectionView {
    var registerCells =    [String]()
    
    var headerCells = [String]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetup()
    }
    
    func initialSetup(){
        registerCells.append("EmptyCollectionViewCell")
        registerCells.append("PhotoCollectionViewCell")
        registerCells.append("DashboardCollectionCell")
        registerCells.append("ImageGridCollectionViewCell")
        registerCells.append("HomeCollectionViewCell")
        
        for cellId in registerCells {
            registerNewCell(cellId: cellId)
        }
        
        registerHerderCells()
        
        self.accessibilityHint = "0"
        self.accessibilityIdentifier = "0"
    }
    
    func registerHerderCells(){
        headerCells.append("EmptyCollectionViewCell")
        
        for cellId in headerCells {
            self.register(UINib(nibName: cellId, bundle: nil), forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: cellId)
        }
    }
    
    func setupAlignment(_ vertical:VerticalAlignment,_ horizontal:HorizontalAlignment,_ spacing:CGFloat){
        let alignedFlowLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: horizontal, verticalAlignment: vertical)
        alignedFlowLayout.minimumLineSpacing = spacing
        alignedFlowLayout.minimumInteritemSpacing = spacing
        alignedFlowLayout.scrollDirection = .horizontal
        self.collectionViewLayout = alignedFlowLayout
        self.accessibilityHint = "0"
    }
    
    func registerNewCell(cellId:String){
        self.register(UINib(nibName: cellId , bundle: nil), forCellWithReuseIdentifier: cellId)
    }
    
}



class SelfSizedCollectionView: CustomCollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return collectionViewLayout.collectionViewContentSize
    }
}


