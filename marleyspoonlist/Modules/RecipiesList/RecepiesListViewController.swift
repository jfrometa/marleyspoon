//
//  ViewController.swift
//  marleyspoonlist
//
//  Created by Jose Frometa on 1/7/20.
//  Copyright © 2020 Jose Frometa. All rights reserved.
//

import UIKit
import Contentful
import RxSwift
import RxCocoa
import RxDataSources
import Cartography

class RecepiesListViewController: UIViewController {
    private let viewModel: RecipiesListViewModel!
    private let disposebag = DisposeBag()
    private let _view = RecipiesView()
    
    private var dataSoruceRef: RxTableViewSectionedReloadDataSource<RecipiesSection>?
    
    init(with model: RecipiesListViewModel) {
        self.viewModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.setupView()
    }
    
    private func setupView(){
        self.view.backgroundColor = .clear
        self._view.backgroundColor = .blue
        self.view.addSubview(self._view)
        
        constrain(_view) {
            guard  let sv = $0.superview else { return }
            $0.top == sv.safeAreaLayoutGuide.topMargin
            $0.bottom == sv.safeAreaLayoutGuide.bottomMargin
            $0.leading == sv.safeAreaLayoutGuide.leadingMargin
            $0.trailing == sv.safeAreaLayoutGuide.trailingMargin
        }
    }
}




