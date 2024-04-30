//
//  ReferenceManager.swift
//  SpilledUITest
//
//  Created by Aron Tiselius on 2024-04-30.
//

import Foundation

class ReferenceManager: ObservableObject {
    static let shared = ReferenceManager() // Singleton instance
    
    @Published var references: [Reference] = [
        Reference(name: "Plastic card", image: "creditcard", area: 0.004624, removeable: false),
        Reference(name: "Snus tin", image: "circle.circle", area: 0.015393804, removeable: false),
        Reference(name: "Fuel pump", image: "fuelpump", area: 2.2, removeable: false)
    ]
    
    private init() {} // Private initializer to enforce singleton
    
    func addReference(_ reference: Reference) {
        references.append(reference)
    }
    
    func removeReference(_ reference: Reference){
        if let index = references.firstIndex(of: reference) {
            references.remove(at: index) // array is now ["world"]
        }
    }
    
    func nameExists(referenceName: String) -> Bool{
        var nameExists = false
        for ref in references {
            if ref.name == referenceName{
                nameExists = true
            }
        }
        return nameExists
    }
    
}
