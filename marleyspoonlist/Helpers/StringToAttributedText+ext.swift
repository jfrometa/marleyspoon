//
//  StringToAttributedText+ext.swift
//  marleyspoonlist
//
//  Created by Jose Frometa on 1/9/20.
//  Copyright © 2020 Jose Frometa. All rights reserved.
//

import UIKit

extension String {
func attributed(_ size: CGFloat = 16, _ color: UIColor = UIColor.black) -> NSMutableAttributedString {
  return NSMutableAttributedString(string: self, attributes: [
    .font: UIFont.systemFont(ofSize: size),
    .foregroundColor: color,
  ])
}
}
