//
//  UserStore.swift
//  DataPersistenceSwiftData
//
//  Created by julian.garcia on 25/07/24.
//

import Foundation
import SwiftData

enum UserStoreError: Error {
    case getUsersError
    case getUserError
}

@MainActor
class UserStore {
    static var shared = UserStore()
    
    var container: ModelContainer?
    var context: ModelContext?
    
    private init() {
        do {
            container = try ModelContainer(for: User.self)
            if let container {
                context = ModelContext(container)
            }
        } catch {
            print(error)
        }
    }

    func saveUser(name: String, password: String, mail: String) {
        guard let context else { return }
        
        let newUser = User(name: name, password: password, mail: mail)
        context.insert(newUser)
    }
    
    func getUsers() -> Result<[User], UserStoreError> {
        guard let context else { return .failure(.getUsersError) }
        
        let descriptor = FetchDescriptor<User>(sortBy: [.init(\.name)])
        let result = (try? context.fetch(descriptor)) ?? []
        
        return.success(result)
    }
    
    func getUserBy(userName: String, password: String) -> Result<User, UserStoreError> {
        guard let context else { return .failure(.getUserError) }
        
        var descriptor = FetchDescriptor<User>(
            predicate: #Predicate { $0.name == userName && $0.password == password }
        )
        
        descriptor.fetchLimit = 1
        
        return if let result = try? context.fetch(descriptor).first {
            .success(result)
        } else {
            .failure(.getUserError)
        }
        
        
    }
    
    func updateUser(user: User, newName: String) {
        user.name = newName
    }
    
    func deleteUser(_ user: User) {
        guard let context else { return }
        
        context.delete(user)
    }
}
