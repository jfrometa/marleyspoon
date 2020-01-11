import UIKit
import Kingfisher
import Contentful

extension UIImageView {

    func setImageToNaturalHeight(fromAsset asset: Asset,
                                 additionalOptions: [ImageOption] = [],
                                 heightConstraint: NSLayoutConstraint? = nil) {
        
        guard let width = asset.file?.details?.imageInfo?.width else { return }
        guard let height = asset.file?.details?.imageInfo?.height else { return }

        let imageOptions: [ImageOption] = [
            .formatAs(.jpg(withQuality: .asPercent(100))),
            .width(UInt(width)),
            .height(UInt(height)),
        ] + additionalOptions

        do {
            let url = try asset.url(with: imageOptions)
            self.kf.indicatorType = .activity
            self.kf.setImage(with: url)
            print("URL --> \(url)")
        } catch {
            NSLog("Error Loading Image: \(error.localizedDescription)")
        }
    }
}
