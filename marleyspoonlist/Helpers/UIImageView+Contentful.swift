import UIKit
import Kingfisher
import Contentful

extension UIImageView {

    func setImageToNaturalHeight(fromAsset asset: Asset,
                                 additionalOptions: [ImageOption] = [],
                                 heightConstraint: NSLayoutConstraint? = nil) {
        
        guard let width = asset.file?.details?.imageInfo?.width else { return }
        guard let height = asset.file?.details?.imageInfo?.height else { return }

        let scale = UIScreen.main.scale
        let viewWidthInPx = Double(frame.width * scale)
        let percentageDifference = viewWidthInPx / width

        let viewHeightInPoints = height * percentageDifference / Double(scale)
        let viewHeightInPx = viewHeightInPoints * Double(scale)

        heightConstraint?.constant = CGFloat(round(viewHeightInPoints))

        let imageOptions: [ImageOption] = [
            .formatAs(.jpg(withQuality: .asPercent(100))),
            .width(UInt(viewWidthInPx)),
            .height(UInt(viewHeightInPx)),
        ] + additionalOptions

        let url = try! asset.url(with: imageOptions)

        self.setImage(with: url)
//        af_setImage(withURL: url,
//                    placeholderImage: nil,
//                    imageTransition: .crossDissolve(0.5),
//                    runImageTransitionIfCached: true)

    }
    
    fileprivate func setImage(with url: URL){
        let resource = ImageResource(downloadURL: url, cacheKey: "\(url)")
        self.kf.indicatorType = .activity
        self.kf.setImage(with: resource)
    }
}
