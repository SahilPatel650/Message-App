//
//  DatabaseManager.swift
//  Message
//
//  Created by Sahil Patel on 11/24/20.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    public func test() {
        
    }
}
