//
//  RecipieDetailsView.swift
//  marleyspoonlist
//
//  Created by Jose Frometa on 1/9/20.
//  Copyright © 2020 Jose Frometa. All rights reserved.
//

import UIKit
import Cartography

class RecipieDetailsView: UIView {
    private let screen = UIScreen.main.bounds
    
    var recipe: Recipe
    
    let svTags: UIStackView = {
       let stackView = UIStackView()
        stackView.spacing = 8
       stackView.axis = .horizontal
        stackView.alignment = .firstBaseline
      stackView.distribution = .fillProportionally
       return stackView
     }()
    
    private let lblCategory: UILabel = {
         var title = UILabel()
         title.isEnabled = false
         title.textAlignment = .left
         title.backgroundColor = .clear
         title.numberOfLines = 0
         title.attributedText = "TITLE !@#".attributed(26)
         return title
       }()
    
    private let lblTitle: UILabel = {
      var title = UILabel()
      title.isEnabled = false
      title.textAlignment = .center
      title.backgroundColor = .clear
      title.numberOfLines = 6
      title.attributedText = "TITLE !@#".attributed(26)
      return title
    }()
    
    private let lblDescription: UILabel = {
      var title = UILabel()
      title.isEnabled = false
      title.textAlignment = .left
      title.backgroundColor = .clear
      title.numberOfLines = 0
      title.attributedText = "DESCRIPTION !@#".attributed()
      return title
    }()
    
    private let lblChefName: UILabel = {
      var title = UILabel()
      title.isEnabled = false
      title.textAlignment = .left
      title.backgroundColor = .clear
      title.numberOfLines = 0
      title.attributedText = "CHEF !@#".attributed()
      return title
    }()

    private let imageView: UIImageView = {
      let icon = UIImageView()
      icon.backgroundColor = .clear
      return icon
    }()
    
    private let container: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 12
        view.alignment = .fill
        view.distribution = .fillProportionally
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = false
        return view
    }()
    
    init(_ recipe: Recipe) {
      self.recipe = recipe
      super.init(frame: CGRect.zero)

      self.setView(self.recipe)
    }

    required init?(coder _: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    private func setView(_ recipe: Recipe) {
      self.backgroundColor = .clear
      self.addSubview(container)
      self.addSubview(imageView)
        
      self.lblTitle.attributedText = recipe.title.attributed()
      self.lblChefName.attributedText = recipe.chefName.attributed()
      self.lblDescription.attributedText = recipe.description?.attributed()
      
      if let calories = recipe.calories {
        self.lblCategory.attributedText = "Calories: \(calories)".attributed(24, .pink)
      }
        
      if let tags = recipe.tags {  tags.forEach {
            let box = self.getBox(with: $0.name ?? "tag")
            self.svTags.addArrangedSubview(box)
        }
      }
         
      if let photo = recipe.photo {
        self.imageView.setImageToNaturalHeight(fromAsset: photo)
      }
 
      container.addArrangedSubview(lblCategory)
      container.addArrangedSubview(lblTitle)
      container.addArrangedSubview(lblChefName)
      container.addArrangedSubview(lblDescription)
      container.addArrangedSubview(svTags)

      constrain(imageView, container) { imageView, container in
            guard let sv = imageView.superview else { return }
             let imageWidth: CGFloat = screen.width
             let horizontalMargin: CGFloat = 16
             let verticalMargin: CGFloat = 8
             
             imageView.top == sv.top
             imageView.leading == sv.leading
             imageView.trailing == sv.trailing
             imageView.width == imageWidth
             imageView.height == (imageView.width * 0.63)
               
             container.top == imageView.bottom + verticalMargin
             container.leading == sv.leading + horizontalMargin
             container.trailing == sv.trailing - horizontalMargin
             container.bottom <= sv.bottom - horizontalMargin
            
           }
    }
    
    func getBox(with title: String) -> UIView {
       let box = UIView()
       box.backgroundColor = .superLightGray
        
       let tag = UILabel()
       tag.attributedText = title.attributed(15, .darkerGray)
        
       box.addSubview(tag)
       constrain(tag) {
           guard let sv = $0.superview else { return }
            sv.height == 52
            $0.top == sv.top + 8
            $0.bottom == sv.bottom - 12
            $0.leading == sv.leading + 12
            $0.trailing == sv.trailing - 8
        }
        
       return box
    }
}
