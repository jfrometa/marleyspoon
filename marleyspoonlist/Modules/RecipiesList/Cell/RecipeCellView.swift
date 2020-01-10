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
    title.textAlignment = .left
    title.backgroundColor = .clear
    title.attributedText = "TITLE !@#".attributed()
    return title
  }()

  private let ivIcon: UIImageView = {
    let icon = UIImageView()
    icon.backgroundColor = .clear
    return icon
  }()
    
    
  let container: UIView = {
      let view = UIView()

      view.backgroundColor = UIColor.white
      view.layer.masksToBounds = false
      view.layer.shadowColor = UIColor.black.cgColor
      view.layer.shadowOpacity = 0.1
      view.layer.shadowOffset = CGSize(width: 0, height: 2)
      view.layer.shadowRadius = 2
      view.layer.rasterizationScale = UIScreen.main.scale
      view.layer.cornerRadius = 10
      return view
  }()

  var onClickListener: (() -> Void)?
   
  var recipe: Recipe? {
    didSet{
        self.lblTitle.attributedText = recipe?.title.attributed()
        
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

  @objc func onPress() {
    guard let onClick = self.onClickListener else { return }
    onClick()
  }
    
  private func setView() {
    
    addSubview(container)
    constrain(container) { container in
      guard let sv = container.superview else { return }
      container.height == 65
      container.top == sv.top
      container.bottom == sv.bottom
      container.leading == sv.leading
      container.trailing == sv.trailing
    }

    container.addSubview(ivIcon)
    container.addSubview(lblTitle)
    container.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPress)))
    
    constrain(ivIcon, lblTitle) {  ivIcon, lblTitle in
      guard let sv = ivIcon.superview else { return }
      ivIcon.height == 40
      ivIcon.width == 40
      ivIcon.centerY == sv.centerY
      ivIcon.leading == sv.leading + 16

      lblTitle.top == ivIcon.top + 0.5
      lblTitle.leading == ivIcon.trailing + 5
      lblTitle.trailing == sv.trailing - 16
    }
  }
}

