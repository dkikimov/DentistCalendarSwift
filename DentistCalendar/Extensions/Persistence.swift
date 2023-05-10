//
//  Persistence.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 14.11.2020.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "DiagnosisModel")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved Error \(error)")
            }
        }
    }
}
