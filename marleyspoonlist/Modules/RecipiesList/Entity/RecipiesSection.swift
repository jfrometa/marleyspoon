//
//  RecipeSections.swift
//  marleyspoonlist
//
//  Created by Jose Frometa on 1/9/20.
//  Copyright © 2020 Jose Frometa. All rights reserved.
//


import RxDataSources

struct RecipiesSection{
  var header: String
  var items: [Item]
}

extension RecipiesSection: SectionModelType {
  typealias Item = Recipe

  init(original: RecipiesSection, items: [Item]) {
    self = original
    self.items = items
  }
}
