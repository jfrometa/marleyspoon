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
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.bindViewModel()
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
    
    private func bindViewModel(){
        let dataSource = RxTableViewSectionedReloadDataSource<RecipiesSection>(
          configureCell: { [weak self] _, _, indexPath, recipe in
            guard let _self = self else { return UITableViewCell() }
            
            let cell = self?._view
                .tableView
                .dequeueReusableCell(withIdentifier: RecipeCellView.id, for: indexPath) as! RecipeCellView
            
            cell.recipe = recipe
            cell.onClickListener = { _self.viewModel.navigator.goToRecipeDetails(recipe) }
            return cell
          }
        )
        
        dataSoruceRef = dataSource

        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        let pull = _view.tableView.refreshControl!.rx
          .controlEvent(.valueChanged)
          .asDriver()
       
        let input = RecipiesListViewModel
          .Input(trigger: Driver.merge(viewWillAppear, pull))

        let output = viewModel.transform(input: input)

//        output.fetching
//          .drive(_view.tableView.refreshControl!.rx.isRefreshing)
//          .disposed(by: disposebag)

        _view.tableView.rx.setDelegate(self).disposed(by: disposebag)
        output.data.map { recipies in
          if recipies.count == 0 { return [] }

          // get all unique titles
            let dateTitle = recipies.compactMap { $0.tags?.first }

          // format the new data
          var recipeMap: [RecipiesSection] = dateTitle.map {
            title -> RecipiesSection in
            let recipiesByName = recipies
              .filter { (details) -> Bool in
                guard let tag = details.tags?.first else { return false }
                return tag.name == title.name
              }

            return RecipiesSection(header: title.name!, items: recipiesByName)
          }

          var currentDataSource: [RecipiesSection] = dataSource.sectionModels
          if let currentLast = dataSource.sectionModels.last {
            // find out if it has items to append
            let hasItemsForLastSection = recipeMap.contains(where: { (section) -> Bool in
              currentLast.header == section.header
            })

            if hasItemsForLastSection {
              // append to last section
              let movementsIndex = recipeMap
                .lastIndex(where: { $0.header == currentLast.header })

              let dataSourceIndex = currentDataSource
                .lastIndex(where: { $0.header == currentLast.header })

              var mutableList: [RecipiesSection.Item] = []
              mutableList.append(contentsOf: currentLast.items)
              mutableList.append(contentsOf: recipeMap[movementsIndex!].items)

              currentDataSource[dataSourceIndex!].items = mutableList

              // remove appended map
              _ = recipeMap.remove(at: movementsIndex!)

              // add next sections
              if !recipeMap.isEmpty {
                recipeMap.forEach { currentDataSource.append($0) }
              }

            } else {
              currentDataSource.append(contentsOf: recipeMap)
            }
          } else {
            currentDataSource.append(contentsOf: recipeMap)
          }
          return currentDataSource
        }
        .drive(_view.tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposebag)
        
    }
}

extension RecepiesListViewController: UITableViewDelegate {
  func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return setHeaderForSection(section: section)
  }

  func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
    return 64
  }

  func tableView(_: UITableView, estimatedHeightForHeaderInSection _: Int) -> CGFloat {
    return 64
  }

  func getHeaderViewLabel(with label: (UILabel) -> Void) -> UIView {
    let header = UIView()
    let lblTitle = UILabel()

    header.addSubview(lblTitle)
    header.backgroundColor = .white
    constrain(header, lblTitle) {
      h, l in

      l.top == h.top + 8
      l.leading == h.leading + 17
      l.bottom == h.bottom - 8
    }

    label(lblTitle)
    return header
  }

  func setheaderTitle(title: UILabel, section: Int) {
    title.attributedText = dataSoruceRef?[section].header.attributed()
  }

  func setHeaderForSection(section: Int) -> UIView {
    return getHeaderViewLabel { lblTitle in
      setheaderTitle(title: lblTitle, section: section)
    }
  }
}


