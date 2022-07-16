//
//  DataController.swift
//  Memoriz
//
//  Created by Oladele Abimbola on 7/7/22.
//

import Foundation
import CoreData

class DataController{
    let persistentContainer: NSPersistentContainer
    
    var viewContext:NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    init(modelName: String){
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion:(()->Void)? = nil){
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else{
                fatalError("\(error?.localizedDescription ?? "cannot load store")")
            }
            self.autoSaveContext()
            completion?()
        }
    }
}

extension DataController{
    func autoSaveContext(interval: TimeInterval = 30){
        print("context saved")

        guard interval > 0 else{
            print("cannot set negative autosave interval")
            return
        }

        if viewContext.hasChanges{
            try? viewContext.save()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveContext(interval: interval)
        }
    }
}
