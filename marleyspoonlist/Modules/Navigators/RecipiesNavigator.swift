//
//  RecipiesNavigator.swift
//  marleyspoonlist
//
//  Created by Jose Frometa on 1/9/20.
//  Copyright © 2020 Jose Frometa. All rights reserved.
//

import UIKit

protocol RecipiesNavigator {
    func goToRecipies(with viewModel: RecipiesListViewModel)
    func goToRecipeDetails(_ recipe: Recipe)
}

class DefaultRecipiesNavigator: RecipiesNavigator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
      self.navigationController = navigationController
    }
    
    func goToRecipies(with viewModel: RecipiesListViewModel) {
         let navigator = self
         let model = RecipiesListViewModel(navigator: navigator, provider: ContentfulManager.shared)
         let vc = RecepiesListViewController(with: model)
         navigationController.pushViewController(vc, animated: true)
    }
    
    func goToRecipeDetails(_ recipe: Recipe) {
        print("goToRecipeDetails : \(recipe)")
    }
}
