//
//  Photo.swift
//  Medittation
//
//  Created by Алина Матюха on 28.11.2022.
//

import Foundation
import RealmSwift

class Photo: Object {
    
    @objc dynamic var photoData: Data?
    @objc dynamic var time: String?
    
}
