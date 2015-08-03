
import UIKit

extension UICollectionView {

    func rmdn_takeSnapshot() -> UIImage {
        let oldFrame = self.frame

        // make the frame's size bigger before taking a snapshot
        // source : http://stackoverflow.com/a/14376719/851515

        var frame = self.frame
        frame.size.height = self.contentSize.height
        self.frame = frame

        UIGraphicsBeginImageContextWithOptions(self.frame.size, self.opaque, 0)
        self.layer.renderInContext(UIGraphicsGetCurrentContext())
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.frame = oldFrame

        return screenshot
    }

}
