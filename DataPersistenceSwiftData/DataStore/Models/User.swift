//
//  User.swift
//  DataPersistenceSwiftData
//
//  Created by julian.garcia on 25/07/24.
//
import Foundation
import SwiftData

@Model
class User {
    @Attribute(.unique) var id: UUID
    var name: String
    var password: String
    var mail: String
    
    init(name: String, password: String, mail: String) {
        self.id = UUID()
        self.name = name
        self.password = password
        self.mail = mail
    }
}
