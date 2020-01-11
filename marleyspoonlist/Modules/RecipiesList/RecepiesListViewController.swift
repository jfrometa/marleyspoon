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
    private let _view = RecipiesView()
    private let disposebag = DisposeBag()
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<RecipiesSection>(
         configureCell: { [weak self] _, _, indexPath, recipe in
           guard let _self = self else { return UITableViewCell() }
           
           let cell = _self._view
               .tableView
               .dequeueReusableCell(withIdentifier: RecipeCellView.id,
                                  for: indexPath) as! RecipeCellView
           
           cell.recipe = recipe
           cell.onClickListener = { _self.viewModel.navigator.goToRecipeDetails(recipe) }
           return cell
         }
       )
    
    init(with model: RecipiesListViewModel) {
        self.viewModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.bindViewModel()
    }
    
    private func setTitle(title: String, color: UIColor = .black) {
        let navigationBarLabel = UILabel()
        navigationBarLabel.attributedText = title.attributed(22)
        navigationItem.titleView = navigationBarLabel
      }
    
    private func setupView(){
        setTitle(title: "Marley Spoon")
        self.view.backgroundColor = .lightGray
        self._view.backgroundColor = .lightGray
        self.view.addSubview(self._view)
        
        constrain(_view) {
            guard  let sv = $0.superview else { return }
            $0.top == sv.safeAreaLayoutGuide.topMargin
            $0.bottom == sv.safeAreaLayoutGuide.bottomMargin
            $0.leading == sv.safeAreaLayoutGuide.leadingMargin
            $0.trailing == sv.safeAreaLayoutGuide.trailingMargin
        }
    }
    
    private func bindViewModel(){
        _view.tableView.rx.setDelegate(self).disposed(by: disposebag)
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
          .mapToVoid()
          .asDriverOnErrorJustComplete()

        let pull = _view.tableView.refreshControl!.rx
          .controlEvent(.valueChanged)
          .asDriver()
       
        let input = RecipiesListViewModel
          .Input(trigger: Driver.merge(viewWillAppear, pull))

        let output = viewModel.transform(input: input)

        output.fetching
          .drive(_view.tableView.refreshControl!.rx.isRefreshing)
          .disposed(by: disposebag)

        output.data
          .distinctUntilChanged { $0.count == $1.count }
          .map { [weak self] recipies in
            guard let _self = self else { return self?.dataSource.sectionModels ?? [] }
            if recipies.count == 0 { return [] }
              
            var notSoHappyButFitRecipies = RecipiesSection(header: "The Fitness Stuff",
                                                           items: [Recipe]())
            var happyRecipies =  RecipiesSection(header: "The Gordito Stuff",
                                                  items: [Recipe]())
            recipies
                .sorted(by: { guard let r1 = $0.calories, let r2 = $1.calories
                    else { return false }
                    return r1 > r2
                }) .filter { $0.calories != nil }
                .forEach {
                    ($0.calories! >= 500) ?
                    happyRecipies.items.append($0) : notSoHappyButFitRecipies.items.append($0)
                }
            
            var currentDataSource = _self.dataSource.sectionModels
               
            notSoHappyButFitRecipies.items.count > 0 ?
                currentDataSource.append(notSoHappyButFitRecipies) : nil
              
            happyRecipies.items.count > 0 ?
                currentDataSource.append(happyRecipies) : nil
  
            return currentDataSource
        }
        .drive(_view.tableView.rx.items(dataSource: self.dataSource))
        .disposed(by: disposebag)
    }
}

extension RecepiesListViewController: UITableViewDelegate {
  func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = getHeader { $0.attributedText = dataSource[section].header.attributed(26) }
    header.backgroundColor = ((section == 0) ? .pink : .yellow)
    return header
  }
  
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    
  func getHeader(with label: (UILabel) -> Void) -> UIView {
    let header = UIView()
    let title = UILabel()

    header.addSubview(title)
    header.backgroundColor = .white
    
    constrain(header, title) { header, title in
      title.top == header.top
      title.centerX == header.centerX
      title.bottom == header.bottom
    }

    label(title)
    return header
  }
}


