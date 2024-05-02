//
//  DataManager.swift
//  Weather
//
//  Created by Berke Parıldar on 2.05.2024.
//

import CoreData

final class DataManager {
    
    private let coreDataStack = CoreDataStack()
    static let shared = DataManager()
    
    func fetchCoordinates() -> [(Double, Double, String)] {
        let context = coreDataStack.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Coordinates")
        var coordinates = [(Double, Double, String)]()
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                let latitude = result.value(forKey: "latitude") as? Double ?? 0.0
                let longitude = result.value(forKey: "longitude") as? Double ?? 0.0
                let name = result.value(forKey: "name") as? String ?? ""
                coordinates.append((latitude, longitude, name))
            }
            return coordinates
        } catch {
            debugPrint("There was an error fetching cart.")
        }
        return coordinates
    }
    
    func addCoordinate(coordinate: (Double, Double, String)) {
        let context = coreDataStack.persistentContainer.viewContext
        let newCoordinate = NSEntityDescription.insertNewObject(forEntityName: "Coordinates", into: context)
        newCoordinate.setValue(coordinate.0, forKey: "latitude")
        newCoordinate.setValue(coordinate.1, forKey: "longitude")
        newCoordinate.setValue(coordinate.2, forKey: "name")
        coreDataStack.saveContext()
    }
}
