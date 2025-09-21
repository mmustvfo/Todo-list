//
//  MainScreenCoordinator.swift
//  ToDo_Test
//
//  Created by Mustafo on 21/09/25.
//

import UIKit

protocol MainScreenCoordinatorProtocol {
    func showTodoDetail(_ descriptor: TodoRowDescriptor)
}

final class MainScreenCoordinator: Coordinator {
    var children: [Coordinator] = []
    private let navigationController = UINavigationController()
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        window.rootViewController = navigationController
        window.overrideUserInterfaceStyle = .light
        window.makeKeyAndVisible()
        
        let worker = MainScreenWorker()
        let view = MainScreenViewController()
        let presenter = MainScreenPresenter(
            worker: worker,
            view: view,
            coordinator: self
        )
        view.presenter = presenter
        
        navigationController.setViewControllers([view], animated: true)
    }
}

extension MainScreenCoordinator: MainScreenCoordinatorProtocol {
    func showTodoDetail(_ descriptor: TodoRowDescriptor) {
        let coordinator = DetailInfoCoordinator(
            descriptor: descriptor,
            navigationController: navigationController
        ) { [weak self] in
            self?.children.removeAll(where: { $0 is DetailInfoCoordinator })
        }
        children.append(coordinator)
        coordinator.start()
    }
}
