//
//  Recipe.swift
//  marleyspoonlist
//
//  Created by Jose Frometa on 1/9/20.
//  Copyright © 2020 Jose Frometa. All rights reserved.
//

import Foundation
import Contentful

final class Recipe: EntryDecodable, FieldKeysQueryable {

    static let contentTypeId: String = "recipe"

    let id: String
    let localeCode: String?
    let updatedAt: Date?
    let createdAt: Date?
    
    let title: String
    var chef: Chef?
    var photo: Asset?
    var tags: [Tag]?
    let calories: Int?
    let description: String?

    var chefName: String {
        return "Chef \(self.chef?.name ?? "")"
    }
    
    var _description: String {
        return "\(self.id) / \(self.title) / \(String(describing: self.chefName)) / \(String(describing: self.calories))"
    }
    
    required init(from decoder: Decoder) throws {
        let sys         = try decoder.sys()
        id              = sys.id
        localeCode      = sys.locale
        updatedAt       = sys.updatedAt
        createdAt       = sys.createdAt

        let fields      = try decoder.contentfulFieldsContainer(keyedBy: Recipe.FieldKeys.self)

        self.title       = try fields.decode(String.self, forKey: .title)
        self.description      = try fields.decodeIfPresent(String.self, forKey: .description)
        self.calories      = try fields.decodeIfPresent(Int.self, forKey: .calories)

        try fields.resolveLink(forKey: .chef, decoder: decoder) { [weak self] chef in
              self?.chef = chef as? Chef
        }
        
        try fields.resolveLinksArray(forKey: .tags, decoder: decoder, callback: { [weak self] tag in
                self?.tags = tag as? [Tag]
        })
        
        try fields.resolveLink(forKey: .photo, decoder: decoder) { [weak self] photo in
            self?.photo = photo as? Asset
        }
        
    }
    internal enum FieldKeys: String, CodingKey {
        case title, chef, tags, photo, calories, description
    }
    }


