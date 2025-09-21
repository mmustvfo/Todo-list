//
//  MainScreenViewController.swift
//  ToDo_Test
//
//  Created by Mustafo on 21/09/25.
//

import UIKit

protocol MainScreenViewProtocol: AnyObject {
    func reload()
}

final class MainScreenViewController: UIViewController {
    var presenter: MainScreenPresenterProtocol?
    
    private let searchController = UISearchController()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        setSearch()
        setupUI()
        setupLayout()
        setupNavigation()
        presenter?.onViewDidLoad()
    }
    
    private func setDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setSearch() {
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    private func setupUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigation() {
        navigationController?.navigationBar.backgroundColor = .white
    }
}

extension MainScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.rows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = presenter?.rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = .none
        var configuration = cell.defaultContentConfiguration()
        configuration.text = row?.name
        configuration.secondaryText = row?.title
        cell.contentConfiguration = configuration
        return cell
    }
}

extension MainScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.onSelect(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (presenter?.rows.count ?? 0) - 1 {
            presenter?.loadNextPage()
        }
    }
}

extension MainScreenViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        presenter?.onSetSearchText(searchController.searchBar.text ?? "")
    }
}

extension MainScreenViewController: MainScreenViewProtocol {
    func reload() {
        tableView.reloadData()
    }
}
