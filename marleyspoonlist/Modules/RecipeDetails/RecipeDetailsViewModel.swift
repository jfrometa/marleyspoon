//
//  RecipeDetailsViewModel.swift
//  marleyspoonlist
//
//  Created by Jose Frometa on 1/9/20.
//  Copyright © 2020 Jose Frometa. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class RecipieDetailsViewModel: ViewModelType {
     
       struct Input {
        let trigger: Driver<Void>
      }

      struct Output {
        let data: Driver<Void>
      }
      
    func transform(input: RecipieDetailsViewModel.Input) -> RecipieDetailsViewModel.Output {
        let data = input.trigger
        return Output(data: data)
    }
}
