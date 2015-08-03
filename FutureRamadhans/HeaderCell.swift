
import UIKit

class HeaderCell : UICollectionReusableView {
    
    var label = UILabel()
    var tapHandler: () -> () = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        configureLabel()
        layoutLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLabel() {
        label.font = UIFont.boldSystemFontOfSize(24)
        label.textAlignment = NSTextAlignment.Center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.userInteractionEnabled = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action:"tap")
        label.addGestureRecognizer(tapRecognizer)
    }
    
    func tap() {
        tapHandler()
    }
    
    func layoutLabel() {
        let views = Dictionary(dictionaryLiteral: ("label", label))
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[label]|", options: NSLayoutFormatOptions.AlignmentMask, metrics: nil, views: views)
        self.addConstraints(hConstraints)
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[label]|", options: NSLayoutFormatOptions.AlignmentMask, metrics: nil, views: views)
        self.addConstraints(vConstraints)
    }
}
