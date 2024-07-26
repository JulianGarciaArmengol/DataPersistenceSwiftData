//
//  LoginViewController.swift
//  DataPersistenceSwiftData
//
//  Created by julian.garcia on 25/07/24.
//

import Foundation
import UIKit
import Combine

class LoginViewController: UIViewController {
    let loginViewModel = LoginViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.textContentType = .username
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.textContentType = .password
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log in", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign in", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let crashButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Test Crash", for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupBindings()
        
        loginButton.addTarget(self, action: #selector(logInTapped), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        crashButton.addTarget(self, action: #selector(crashButtonTapped), for: .touchUpInside)

    }
    
    @objc func crashButtonTapped() {
        print("muere")
        let numbers = [0]
        let _ = numbers[1]
    }
    
    private func setupViews() {
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(signInButton)
        view.addSubview(crashButton)

        
        NSLayoutConstraint.activate([
            // username text field
            usernameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // password text field
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 12),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // login Button
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // sign in Button
            signInButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 12),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            crashButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            crashButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
        ])
    }
    
    private func setupBindings() {
        loginViewModel.loggedUser
            .sink { user in
                let userListViewController = UserListViewController(
                    viewModel: UserListViewModel(
                        selectedUser: user
                    )
                )
                
                userListViewController.navigationItem.setHidesBackButton(true, animated: false)
                self.navigationController?.pushViewController(userListViewController, animated: true)
                self.navigationController?.viewControllers.remove(at: 0)
            }.store(in: &cancellables)
    }
    
    
    @objc private func logInTapped() {
        guard let username = usernameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        loginViewModel.loginWith(userName: username, password: password)
    }
    
    @objc private func signInTapped() {
        let viewController = SignInViewController()
        
        if let sheetController = viewController.sheetPresentationController {
            sheetController.detents = [.large()]
        }
        
        self.present(viewController, animated: true)
    }
}
