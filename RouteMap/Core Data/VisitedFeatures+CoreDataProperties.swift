//
//  VisitedFeatures+CoreDataProperties.swift
//  VisitedFeatures
//
//  Created by William Finnis on 10/08/2021.
//
//

import Foundation
import CoreData


extension VisitedFeatures {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VisitedFeatures> {
        return NSFetchRequest<VisitedFeatures>(entityName: "VisitedFeatures")
    }

    @NSManaged public var churches: [Int]?
    @NSManaged public var routes: [Int]?

}

extension VisitedFeatures : Identifiable {

}
