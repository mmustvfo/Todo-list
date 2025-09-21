//
//  DetailInfoCoordinator.swift
//  ToDo_Test
//
//  Created by Mustafo on 22/09/25.
//

import UIKit

protocol DetailInfoCoordinatorProtocol: AnyObject {
    func finish() 
}

final class DetailInfoCoordinator: Coordinator {
    var children: [Coordinator] = []
    private let descriptor: TodoRowDescriptor
    private let navigationController: UINavigationController
    private let onFinish: () -> Void
    
    init(
        descriptor: TodoRowDescriptor,
        navigationController: UINavigationController,
        onFinish: @escaping () -> Void
    ) {
        self.descriptor = descriptor
        self.navigationController = navigationController
        self.onFinish = onFinish
    }
    
    
    func start() {
        let view = DetailInfoViewController()
        let presenter = DetailInfoPresenter(
            descriptor: descriptor,
            view: view,
            coordinator: self
        )
        
        view.presenter = presenter
        
        navigationController.pushViewController(view, animated: true)
    }
}

extension DetailInfoCoordinator: DetailInfoCoordinatorProtocol {
    func finish() {
        onFinish()
    }
}
