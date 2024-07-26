//
//  UserListViewModel.swift
//  DataPersistenceSwiftData
//
//  Created by julian.garcia on 25/07/24.
//

import Foundation
import Combine

@MainActor
final class UserListViewModel {
    var userStore: UserStore = UserStore.shared
    
    var selectedUser: User?
    
    var users = CurrentValueSubject<[User], Never>([])
    
    init(selectedUser: User) {
        self.selectedUser = selectedUser
    }
    
    func loadUsers() {
        let result = userStore.getUsers()
        
        switch result {
        case .success(let users):
            //users.forEach { print($0.name) }
            self.users.send(users)
        case .failure(let error):
            print(error)
        }
    }
    
    func updateUserWith(name: String) {
        guard let selectedUser else { return }
        userStore.updateUser(user: selectedUser, newName: name)
        loadUsers()
    }
    
    func deleteUser(_ user: User) {
        userStore.deleteUser(user)
        loadUsers()
    }
    
}
