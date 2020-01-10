//
//  Observable+Ext.swift
//  marleyspoonlist
//
//  Created by Jose Frometa on 1/10/20.
//  Copyright © 2020 Jose Frometa. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension ObservableType where E == Bool {
  /// Boolean not operator
  public func not() -> Observable<Bool> {
    return map(!)
  }
}

extension SharedSequenceConvertibleType {
  func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
    return map { _ in }
  }
}

extension ObservableType {
  func catchErrorJustComplete() -> Observable<E> {
    return catchError { _ in
      Observable.empty()
    }
  }

  func asDriverOnErrorJustComplete() -> Driver<E> {
    return asDriver { _ in
      Driver.empty()
    }
  }

  func mapToVoid() -> Observable<Void> {
    return map { _ in }
  }
}

