//
//  JSONData+CoreDataProperties.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 19.05.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension JSONData {

    @NSManaged var dateBirth: String?
    @NSManaged var email: String?
    @NSManaged var login: String?
    @NSManaged var occupation: String?
    @NSManaged var password: String?
    @NSManaged var sex: String?
    @NSManaged var step2Bottom: String?
    @NSManaged var step2MidBottom: String?
    @NSManaged var step2MidUp: String?
    @NSManaged var step2Up: String?
    @NSManaged var target: String?
    @NSManaged var firstEntrance: String?

}
