//
//  RecipiesListViewModel.swift
//  marleyspoonlist
//
//  Created by Jose Frometa on 1/9/20.
//  Copyright © 2020 Jose Frometa. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class RecipiesListViewModel: ViewModelType {
     private let provider: ContentfulManager!
     private let navigator: RecipiesNavigator!
     private let disposeBag = DisposeBag()
    
    init(navigator: RecipiesNavigator, provider: ContentfulManager) {
      self.navigator = navigator
      self.provider = provider
    }
    
     struct Input {
      let trigger: Driver<Void>
    }

    struct Output {
      let data: Driver<[Recipe]>
    }
    
  func transform(input: RecipiesListViewModel.Input) -> RecipiesListViewModel.Output {
    
    let data = provider.getRecepies.asDriver(onErrorJustReturn: [])
    return Output(data: data)
  }
    
}
