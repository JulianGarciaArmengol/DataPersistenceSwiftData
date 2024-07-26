//
//  LoginViewModel.swift
//  DataPersistenceSwiftData
//
//  Created by julian.garcia on 25/07/24.
//

import Foundation
import Combine
import FirebaseCrashlytics

@MainActor
final class LoginViewModel {
    private let userStore = UserStore.shared
    
    let loggedUser = PassthroughSubject<User, Never>()
    
    func loginWith(userName: String, password: String) {
        let result = userStore.getUserBy(userName: userName, password: password)
        
        switch result {
        case .success(let user):
            loggedUser.send(user)
        case .failure(let error):
            Crashlytics.crashlytics().log("User failed to log in")
            fatalError("No user")
        }
    }
}
