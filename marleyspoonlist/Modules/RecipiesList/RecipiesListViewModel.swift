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
     let navigator: DefaultRecipiesNavigator!
     private let provider: ContentfulManager!
     private let disposeBag = DisposeBag()
    
    init(navigator: DefaultRecipiesNavigator, provider: ContentfulManager) {
      self.navigator = navigator
      self.provider = provider
    }
    
     struct Input {
      let trigger: Driver<Void>
    }

    struct Output {
      let fetching: Driver<Bool>
      let data: Driver<[Recipe]>
    }
    
  func transform(input: RecipiesListViewModel.Input) -> RecipiesListViewModel.Output {
    let fetching = PublishSubject<Bool>()
    
    let data = input.trigger
        .flatMap { [weak self] _ -> Driver<[Recipe]> in
            guard let _self = self else { return  Driver<[Recipe]>.just([])}
            let data = _self.provider
               .getRecepies
               .do(onNext: { _ in
                   fetching.onNext(true)
                }, onError: { _ in
                   fetching.onNext(false)
                }, onCompleted: {
                   fetching.onNext(false)
            })
            .asDriver(onErrorJustReturn: [])
            return data
        }
    return Output(fetching: fetching.asDriverOnErrorJustComplete(), data: data)
  }
}
