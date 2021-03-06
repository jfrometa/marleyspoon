//
//  RecipeCellView.swift
//  marleyspoonlist
//
//  Created by Jose Frometa on 1/9/20.
//  Copyright © 2020 Jose Frometa. All rights reserved.
//

import Cartography
import UIKit

class RecipeCellView: UITableViewCell {
  static let id = "RecipeCellView"
  private let screen = UIScreen.main.bounds

  private let lblTitle: UILabel = {
    var title = UILabel()
    title.isEnabled = false
    title.textAlignment = .center
    title.backgroundColor = .clear
    title.numberOfLines = 0
    title.attributedText = "".attributed()
    return title
  }()

  private let ivIcon: UIImageView = {
    let icon = UIImageView()
    icon.backgroundColor = .clear
    return icon
  }()
    
    
  private let container: UIView = {
      let view = UIView()
      view.backgroundColor = UIColor.lightGray
      return view
  }()
   
  var recipe: Recipe? {
    didSet{
        self.lblTitle.attributedText = recipe?.title.attributed(17, .darkerGray)
        
        guard let photo = recipe?.photo else { return }
        self.ivIcon.setImageToNaturalHeight(fromAsset: photo)
    }
  }
    
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setView()
  }

  var onClickListener: (() -> Void)?
  @objc func onPress() {
    guard let onClick = self.onClickListener else { return }
    onClick()
  }
    
  private func setView() {
    
    self.addSubview(container)
    container.addSubview(ivIcon)
    container.addSubview(lblTitle)
    container.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPress)))
    
    constrain(ivIcon, lblTitle, container) { ivIcon, lblTitle, container in
      guard let sv = container.superview else { return }
      
      let imageWidth: CGFloat = screen.width 
      let horizontalMargin: CGFloat = 16
      let verticalMargin: CGFloat = 12
        
      container.top == sv.top
      container.bottom == sv.bottom
      container.leading == sv.leading
      container.trailing == sv.trailing
 
      ivIcon.width == imageWidth
      ivIcon.height == (ivIcon.width * 0.63)
        
      ivIcon.top == container.top
      ivIcon.leading == container.leading
      ivIcon.leading == container.trailing

      lblTitle.top == ivIcon.bottom + verticalMargin
      lblTitle.leading == container.leading + horizontalMargin
      lblTitle.trailing == container.trailing - horizontalMargin
      lblTitle.bottom == container.bottom - verticalMargin
    }
  }
}

