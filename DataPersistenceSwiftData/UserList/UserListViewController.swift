//
//  ViewController.swift
//  DataPersistenceSwiftData
//
//  Created by julian.garcia on 25/07/24.
//

import UIKit
import Combine

enum Section {
    case users
}

class UserListViewController: UIViewController {
    var viewModel: UserListViewModel
    
    init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var dataSource: UITableViewDiffableDataSource<Section, User>!
    
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        tableView.delegate = self
        
        setupViews()
        createDataSource()
        setupBindings()
        viewModel.loadUsers()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "logout",
            style: .plain,
            target: self,
            action: #selector(logOutTapped)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "edit",
            style: .plain,
            target: self,
            action: #selector(editTapped)
        )
        
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func createDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, User>(tableView: tableView) {
            tableView,
            indexPath,
            user in

            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            var content = cell.defaultContentConfiguration()
            content.text = user.name
            
            cell.contentConfiguration = content
            
            return cell
        }
        
        tableView.dataSource = dataSource
    }
    
    private func updateDataSource(_ users: [User]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, User>()
        snapshot.appendSections([.users])
        snapshot.appendItems(users)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func setupBindings() {
        viewModel.users
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink {[weak self] users in
                self?.updateDataSource(users)
                //self?.tableView.reloadData()
            }.store(in: &cancellables)
    }
    
    
    @objc private func logOutTapped() {
        // navigate to list view controller
        let loginViewController = LoginViewController()
        loginViewController.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(loginViewController, animated: true)
        self.navigationController?.viewControllers.remove(at: 0)
    }
    
    @objc private func editTapped() {
        let ac = UIAlertController(title: "Edit name", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(
            title: "Done",
            style: .default
        ) { [unowned ac, weak self] _ in
            guard let self else { return }
            
            let newName = ac.textFields![0].text!
            
            self.viewModel.updateUserWith(name: newName)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        
        present(ac, animated: true)
    }
}

extension UserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") {[weak self] _, _, completionHandler in
            
            if let user = self?.viewModel.users.value[indexPath.row] {
                self?.viewModel.deleteUser(user)
            }
            
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
