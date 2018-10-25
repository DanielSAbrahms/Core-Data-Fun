//
//  Category+CoreDataProperties.swift
//  Core Data Fun
//
//  Created by Gina Sprint on 10/25/18.
//  Copyright © 2018 Gina Sprint. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var name: String?

}
