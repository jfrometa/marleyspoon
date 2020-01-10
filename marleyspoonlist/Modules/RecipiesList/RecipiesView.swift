//
//  RecipiesView.swift
//  marleyspoonlist
//
//  Created by Jose Frometa on 1/9/20.
//  Copyright © 2020 Jose Frometa. All rights reserved.
//

import Cartography
import UIKit

class RecipiesView: UIView {
    let tableView = UITableView(frame: .zero, style: .plain)
    
    init() {
      super.init(frame: CGRect.zero)
      self.setView()
    }

    required init?(coder _: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
      self.backgroundColor = .clear
      tableView.refreshControl = UIRefreshControl()
      tableView.backgroundColor = .white
      tableView.tag = 2
      tableView.separatorStyle = .none
      tableView.register(RecipeCellView.self, forCellReuseIdentifier: RecipeCellView.id)
      tableView.allowsSelection = false
      tableView.bounces = true

      addSubview(tableView)

      constrain(tableView) { list in
        guard let sv = list.superview else { return }
        list.top == sv.top
        list.leading == sv.leading
        list.trailing == sv.trailing
        list.bottom == sv.bottom
      }
    }
}


