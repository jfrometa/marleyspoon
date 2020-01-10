//
//  ContentfulManager.swift
//  marleyspoonlist
//
//  Created by Jose Frometa on 1/9/20.
//  Copyright © 2020 Jose Frometa. All rights reserved.
//

import Foundation
import Contentful
import RxSwift
import RxCocoa

final class ContentfulManager {
    static let shared = ContentfulManager()
    fileprivate let client: Client!
    
    private init() {
        let contentTypeClasses: [EntryDecodable.Type] = [
            Recipe.self,
            Tag.self,
            Chef.self
        ]
        
        self.client = Client(spaceId: "kk2bw5ojx476",
                            environmentId: "master",
                            accessToken: "7ac531648a1b5e1dab6c18b0979f822a5aad0fe5f1109829b8a197eb2be4b84c",
                            contentTypeClasses: contentTypeClasses)
    }
    
    private func getContentTypes() {
        self.client.fetchArray(of: ContentType.self) { (result: Result<HomogeneousArrayResponse<ContentType>>) in
          switch result {
          case .success(let arrayResponse):
           // ["static page", "chef", "tag", "Recipe"]
            let contentTypes = arrayResponse.items
                    .filter{ $0.name != "static page" }
                    .compactMap {
                        $0.fields.compactMap {  "\($0.name)-\(String(describing: $0.itemType))"
                    }
                }

            print(contentTypes)
          case .error(let error):
            print(error)
          }
        }
    }
    
    var getRecepies: Observable<[Recipe]> {
      let recipeObserver =  Observable<[Recipe]>.create { observer in
        let query = Query().where(contentTypeId: "recipe")
         
        self.client.fetchArray(matching: query, then: { (result:Result<HeterogeneousArrayResponse>) in
            switch result {
            case let .success(entry):
                let recipies = entry.items as! [Recipe]
                observer.onNext(recipies)
                observer.onCompleted()
            case let .error(error):
                observer.onError(error)
            }
         })
         return Disposables.create()
       }
      return recipeObserver
    }
}
