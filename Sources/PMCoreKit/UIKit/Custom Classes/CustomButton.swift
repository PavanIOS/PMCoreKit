

import UIKit

public class CustomButton: TextImageButton {
    
    
    var isAnimating: Bool = false
    
    var activityViewColor: UIColor! {
        get {
            return activityView.color
        }
        set {
            activityView.color = newValue
        }
    }
    
    private let activityView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.isUserInteractionEnabled = false
        view.isHidden = true
        return view
    }()
    
    
    var enableButton: Bool = true {
        didSet {
            self.isEnabled = enableButton
            self.alpha = enableButton ? 1.0 : 0.5
        }
    }
    
    var cornerRadius : CGFloat = 0 {
        didSet {
            self.setCornerRadius(cornerRadius)
            if let gradientLayer = gradient {
                gradientLayer.cornerRadius = cornerRadius
            }
        }
    }
    
    var buttonTitle: String {
        get {
            return currentTitle ?? self.buttonTitle
        }
        set {
            self.setTitle(newValue, for: .normal)
        }
    }
    
    var titleColor: UIColor = UIColor.lightGray {
        didSet {
            self.setTitleColor(titleColor, for: .normal)
        }
    }
    var buttonImage: UIImage  = ImageNames.emptyImage {
        didSet {
            self.setImage(buttonImage, for: .normal)
        }
    }
    var shadowColor: UIColor = UIColor.clear{
        didSet{
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
    var shadowOpacity: Float = 0{
        didSet{
            self.layer.shadowOpacity = shadowOpacity
        }
    }
    var shadowOffset: CGSize = CGSize.zero{
        didSet{
            self.layer.shadowOffset = shadowOffset
        }
    }
    var shadowRadius: CGFloat = 0{
        didSet{
            self.layer.shadowRadius = shadowRadius
        }
    }
    var numberOfLines: Int  = 0 {
        didSet {
            self.titleLabel?.numberOfLines = numberOfLines
        }
    }
    
    var attributedTitle: NSAttributedString  = NSAttributedString(string: "") {
        didSet {
            self.setAttributedTitle(attributedTitle, for: .normal)
        }
    }
    var titleFont: UIFont = UIFont.systemFont(ofSize: 17, weight: .medium){
        didSet{
            self.titleLabel?.font = titleFont
        }
    }
    
    var section = 0
    var row = 0
    var item = 0
    var thumbData = ""
    var data = ""
    var animateEnabled = true
    var id = ""
    
    public override func awakeFromNib() {
        initSetup()
    }
    
    func initSetup(){
        setupSendButton()
        startAnimatingPressActions()
    }
    
    private func startAnimatingPressActions() {
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }
    
    @objc private func animateDown(sender: UIButton) {
        if animateEnabled {
            animate(sender, transform1: CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95))
            
        }
    }
    
    @objc private func animateUp(sender: UIButton) {
        if animateEnabled {
            animate(sender, transform1: .identity)
        }
    }
    
    private func animate(_ button: UIButton, transform1: CGAffineTransform) {
        
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut],
                       animations: {
                        button.transform = transform1
                       }, completion: nil)
    }
    
    
    
    func alignTextBelow(_ spacing: CGFloat = 6.0) {
        if let image = self.imageView?.image , let titleText = self.currentTitle {
            let imageSize: CGSize = image.size
            self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
            let labelString = NSString(string: titleText)
            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font as Any])
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        }
    }
    
    
    
    var gradient: CAGradientLayer?
    
    func setupButtonGradient(_ UIColor:[UIColor],_ horizontal:Bool){
        gradient?.removeFromSuperlayer()
        gradient = CAGradientLayer()
        guard let gradient = gradient else { return }
        var cgUIColor = [CGColor]()
        for color in UIColor {
            cgUIColor.append(color.cgColor)
        }
        gradient.frame = self.layer.bounds
        gradient.UIColor = cgUIColor
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = horizontal ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 1)
        gradient.cornerRadius = self.cornerRadius
        self.layer.insertSublayer(gradient, below: self.imageView?.layer)
        
    }
    
    
    func setLeftImage(_ image:UIImage,_ spacing:CGFloat,_ text:String){
        self.buttonImage = image
        self.imagePosition = .left
        self.spacing = spacing
        self.buttonTitle = text
    }
    
    func setRightImage(_ image:UIImage,_ spacing:CGFloat,_ text:String){
        self.buttonImage = image
        self.imagePosition = .right
        self.spacing = spacing
        self.buttonTitle = text
    }
    
    func addRightImage(_ image:UIImage,_ offset:CGFloat,_ color:UIColor) {
        self.buttonImage = image
        self.tintColor = color
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.imageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        self.imageView?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -offset).isActive = true
    }
    
    func addLeftImage(_ image:UIImage,_ offset:CGFloat,_ color:UIColor? = nil) {
        self.buttonImage = image
        self.tintColor = color
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.imageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        self.imageView?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -offset).isActive = true
    }
    
    
}

public extension CustomButton {
    
    private func setupSendButton() {
        addSubview(activityView)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        activityView.frame = bounds
    }
    
    /// Starts the animation of the activity view, hiding other elements
    open func startAnimating() {
        guard !isAnimating else { return }
        defer { isAnimating = true }
        activityView.startAnimating()
        activityView.isHidden = false
        // Setting isHidden doesn't hide the elements
        titleLabel?.alpha = 0
        imageView?.layer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
    }
    
    /// Stops the animation of the activity view, shows other elements
    open func stopAnimating() {
        guard isAnimating else { return }
        defer { isAnimating = false }
        activityView.stopAnimating()
        activityView.isHidden = true
        titleLabel?.alpha = 1
        imageView?.layer.transform = CATransform3DIdentity
    }
}





public class TextImageButton: UIButton {
    
    /// Represents horizontal side for the imagePosition attribute
    enum Side: Int {
        case left, right
    }
    
    /// The spacing between the button image and the button title
    var spacing: CGFloat = 0.0 as CGFloat {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    /// The side of the button to display the image on
    var imagePosition: Side = Side.left {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// IBInspectable accessor for imagePosition
    open var imageOnRight: Bool {
        get {
            return imagePosition == .right
        }
        set {
            imagePosition = newValue ? .right : .left
        }
    }
    
    // MARK: - Spacing
    
    private var enableSpacingAdjustments = 0
    
    override open var contentEdgeInsets: UIEdgeInsets {
        get {
            let adjustment = (enableSpacingAdjustments > 0) ? (spacing/2) : 0
            return super.contentEdgeInsets.adjust(left: adjustment, right: adjustment)
        }
        set(contentEdgeInsets) { super.contentEdgeInsets = contentEdgeInsets }
    }
    
    override open var titleEdgeInsets: UIEdgeInsets {
        get {
            let adjustment = (enableSpacingAdjustments > 0) ? (spacing/2) : 0
            return super.titleEdgeInsets.adjust(left: adjustment, right: -adjustment)
        }
        set(titleEdgeInsets) { super.titleEdgeInsets = titleEdgeInsets }
    }
    
    override open var imageEdgeInsets: UIEdgeInsets {
        get {
            let adjustment = (enableSpacingAdjustments > 0) ? (spacing/2) : 0
            return super.imageEdgeInsets.adjust(left: -adjustment, right: adjustment)
        }
        set(imageEdgeInsets) { super.imageEdgeInsets = imageEdgeInsets }
    }
    
    public override var intrinsicContentSize: CGSize {
        enableSpacingAdjustments += 1
        let contentSize = super.intrinsicContentSize
        enableSpacingAdjustments -= 1
        
        return contentSize
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        enableSpacingAdjustments += 1
        let size = super.sizeThatFits(size)
        enableSpacingAdjustments -= 1
        
        return size
    }
    
    public override func contentRect(forBounds bounds: CGRect) -> CGRect {
        enableSpacingAdjustments += 1
        let contentRect = super.contentRect(forBounds: bounds)
        enableSpacingAdjustments -= 1
        
        return contentRect
    }
    
    
    // MARK: - Image Side
    
    open override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        enableSpacingAdjustments += 1
        var titleRect = super.titleRect(forContentRect: contentRect)
        let imageRect = super.imageRect(forContentRect: contentRect)
        enableSpacingAdjustments -= 1
        
        if imagePosition == .right {
            titleRect.origin.x = imageRect.minX
        }
        
        return titleRect
    }
    
    open override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        enableSpacingAdjustments += 1
        let titleRect = super.titleRect(forContentRect: contentRect)
        var imageRect = super.imageRect(forContentRect: contentRect)
        enableSpacingAdjustments -= 1
        
        if imagePosition == .right {
            imageRect.origin.x = titleRect.maxX - imageRect.width
        }
        
        return imageRect
    }
}


public extension UIEdgeInsets {
    
    func adjust(left: CGFloat, right: CGFloat) -> UIEdgeInsets {
        var edgeInsets = self
        edgeInsets.left += left
        edgeInsets.right += right
        
        return edgeInsets
    }
    
}


public extension CustomButton {
    
    func commonButton(_ text:String,_ color:UIColor) {
        self.buttonTitle = text
        self.titleColor = color
    }
}
