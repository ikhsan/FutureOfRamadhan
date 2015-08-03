
import UIKit

extension UIImage {

    func rmdn_saveImageWithName(name: String) -> String {
        guard let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first,
            let image = UIImagePNGRepresentation(self) else {
                return ""
        }

        let filepath = documentPath.stringByAppendingPathComponent("\(name).png")
        let success = image.writeToFile(filepath, atomically: true)
        return success ? filepath : ""
    }

}
