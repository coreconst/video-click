//
//  CoreDataStack.swift
//  video-click Extension
//
//  Created by constantine on 27.06.2024.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    var persistentContainer: NSPersistentContainer!

    private init() {
        initializeCoreDataStack()
    }

    private func initializeCoreDataStack() {
        let container = NSPersistentContainer(name: "Model")
        guard let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.pk.video-click") else {
            fatalError("Failed to obtain App Group URL")
        }
        let storeURL = appGroupURL.appendingPathComponent("Model.sqlite")

        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        self.persistentContainer = container
    }
}
