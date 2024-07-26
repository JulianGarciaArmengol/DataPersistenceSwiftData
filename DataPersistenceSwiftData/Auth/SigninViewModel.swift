//
//  SigninViewModel.swift
//  DataPersistenceSwiftData
//
//  Created by julian.garcia on 25/07/24.
//

import Foundation

@MainActor
final class SigninViewModel {
    var userStore = UserStore.shared
    
    func createUserWith(userName: String, password: String) {
        userStore.saveUser(name: userName, password: password, mail: "test@test.com")
    }
}
