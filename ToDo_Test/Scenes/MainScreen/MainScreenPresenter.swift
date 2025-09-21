//
//  MainScreenPresenter.swift
//  ToDo_Test
//
//  Created by Mustafo on 21/09/25.
//

import Foundation

protocol MainScreenPresenterProtocol: AnyObject {
    func onViewDidLoad()
    func onSetSearchText(_ text: String)
    func onSelect(at index: Int)
    func loadNextPage()
    var rows: [TodoRowDescriptor] { get }
}

final class MainScreenPresenter {
    private var allRowDescriptors: [TodoRowDescriptor] = []
    private var fetchedRowDesctiptors: [TodoRowDescriptor] = []
    private var page = 1
    private let pageSize = 20
    private var searchText = ""
    private var todos: [TodoResponse] = []
    private var users: [UserResponse] = []
    weak var view: MainScreenViewProtocol?
    private let networkMonitor: NetworkMonitor
    private let worker: MainScreenWorkerProtocol
    private let userStorage: UserStorage
    private let coordinator: MainScreenCoordinatorProtocol
    
    init(
        networkMonitor: NetworkMonitor = .shared,
        userStorage: UserStorage = .shared,
        worker: MainScreenWorkerProtocol,
        view: MainScreenViewProtocol,
        coordinator: MainScreenCoordinatorProtocol
    ) {
        self.networkMonitor = networkMonitor
        self.userStorage = userStorage
        self.worker = worker
        self.view = view
        self.coordinator = coordinator
    }
    
}

extension MainScreenPresenter: MainScreenPresenterProtocol {
    func onViewDidLoad() {
        if networkMonitor.isConnected {
            fetchDataFromNetwork()
        } else {
            allRowDescriptors = userStorage.todos
            fetchedRowDesctiptors = Array(allRowDescriptors.prefix(pageSize))
            view?.reload()
        }
    }
    
    func onSetSearchText(_ text: String) {
        searchText = text
        view?.reload()
    }
    
    func onSelect(at index: Int) {
        coordinator.showTodoDetail(rows[index])
    }
    
    func loadNextPage() {
        let start = page * pageSize
        let end = min(start + pageSize, allRowDescriptors.count)
        
        guard start < end else { return } // no more pages
        
        let nextSlice = allRowDescriptors[start..<end]
        fetchedRowDesctiptors.append(contentsOf: nextSlice)
        page += 1
        
        view?.reload()
    }
    
    var rows: [TodoRowDescriptor] {
        searchText.isEmpty ? fetchedRowDesctiptors :
        fetchedRowDesctiptors.filter {
            $0.name.lowercased().contains(searchText.lowercased()) ||
            $0.title.lowercased().contains(searchText.lowercased())
        }
    }
    
    private func fetchDataFromNetwork() {
        let dispatchGroup = DispatchGroup()
        fetchTodos(in: dispatchGroup)
        fetchUsers(in: dispatchGroup)
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.createRows()
        }
    }
    
    private func fetchTodos(in group: DispatchGroup) {
        group.enter()
        worker.fetchTodos { [weak self] result in
            switch result {
            case let .success(response):
                self?.todos = response
            case let .failure(error):
                debugPrint("Error while fetching todo: \(error.localizedDescription)")
            }
            group.leave()
        }
    }
    
    private func fetchUsers(in group: DispatchGroup) {
        group.enter()
        worker.fetchUsers { [weak self] result in
            switch result {
            case let .success(response):
                self?.users = response
            case let .failure(error):
                debugPrint("Error while fetching users: \(error.localizedDescription)")
            }
            group.leave()
        }
    }
    
    private func createRows() {
        allRowDescriptors = todos.compactMap { [weak self] response in
            if let user = self?.users.first(where: { response.userId == $0.id }) {
                return TodoRowDescriptor(
                    id: response.userId,
                    title: response.title,
                    name: user.name,
                    username: user.username,
                    email: user.email,
                    city: user.address.city,
                    website: user.website
                )
            }
            return nil
        }
        userStorage.todos = allRowDescriptors
        fetchedRowDesctiptors = Array(allRowDescriptors.prefix(pageSize))
        view?.reload()
    }
}
