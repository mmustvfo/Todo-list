//
//  DetailInfoViewController.swift
//  ToDo_Test
//
//  Created by Mustafo on 22/09/25.
//

import UIKit

protocol DetailInfoViewProtocol: AnyObject {
    func reload() 
}

final class DetailInfoViewController: UIViewController {
    var presenter: DetailInfoPresenterProtocol?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDataSource()
        setupUI()
        setupLayout()
        presenter?.onViewDidLoad()
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
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setDataSource() {
        tableView.dataSource = self
    }
}

extension DetailInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.rows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let descriptor = presenter?.rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = .none
        var configuration = cell.defaultContentConfiguration()
        configuration.text = descriptor?.key
        configuration.secondaryText = descriptor?.value
        cell.contentConfiguration = configuration
        return cell
    }
}

extension DetailInfoViewController: DetailInfoViewProtocol {
    func reload() {
        tableView.reloadData()
    }
}
