//
//  RecipeDetailsViewController.swift
//  marleyspoonlist
//
//  Created by Jose Frometa on 1/9/20.
//  Copyright © 2020 Jose Frometa. All rights reserved.
//

import UIKit
import Contentful
import RxSwift
import RxCocoa
import RxDataSources
import Cartography

class RecipieDetailsViewController : UIViewController {
    private let _view : RecipieDetailsView!
    private let disposebag = DisposeBag()
    
    init(_ recipe: Recipe) {
        self._view = RecipieDetailsView(recipe)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setTitle(title: String, color: UIColor = .black) {
           self.navigationController?.navigationBar.tintColor = UIColor.darkerGray;
        
           let navigationBarLabel = UILabel()
           navigationBarLabel.attributedText = title.attributed(22)
           navigationItem.titleView = navigationBarLabel
    }
       
    private func setupView(){
          
        self.setTitle(title: "Recipe Details")
        self.view.backgroundColor = .white
        self._view.backgroundColor = .white
        self.view.addSubview(self._view)
        
        constrain(_view) {
            guard let sv = $0.superview else { return }
            $0.top == sv.safeAreaLayoutGuide.topMargin
            $0.bottom == sv.safeAreaLayoutGuide.bottomMargin
            $0.leading == sv.safeAreaLayoutGuide.leadingMargin
            $0.trailing == sv.safeAreaLayoutGuide.trailingMargin
        }
    }
}
