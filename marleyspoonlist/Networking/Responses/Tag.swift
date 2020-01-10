//
//  Tag.swift
//  marleyspoonlist
//
//  Created by Jose Frometa on 1/9/20.
//  Copyright © 2020 Jose Frometa. All rights reserved.
//

import Foundation
import Contentful

final class Tag: EntryDecodable, FieldKeysQueryable {
    static let contentTypeId: String = "tag"

    let id: String
    let localeCode: String?
    let updatedAt: Date?
    let createdAt: Date?
    
    let name: String?

    required init(from decoder: Decoder) throws {
        let sys         = try decoder.sys()
        id              = sys.id
        localeCode      = sys.locale
        updatedAt       = sys.updatedAt
        createdAt       = sys.createdAt

        let fields      = try decoder.contentfulFieldsContainer(keyedBy: Tag.FieldKeys.self)
        self.name       = try fields.decodeIfPresent(String.self, forKey: .name)
    }

    internal enum FieldKeys: String, CodingKey {
        case name
    }
}
