//
//  DetailInfoPresenter.swift
//  ToDo_Test
//
//  Created by Mustafo on 22/09/25.
//

import Foundation

protocol DetailInfoPresenterProtocol: AnyObject {
    func onViewDidLoad()
    var rows: [DetailInfoRowDescriptor] { get }
}

final class DetailInfoPresenter {
    var rows: [DetailInfoRowDescriptor] = []
    private let descriptor: TodoRowDescriptor
    weak var view: DetailInfoViewProtocol?
    private let coordinator: DetailInfoCoordinatorProtocol
    
    init(
        descriptor: TodoRowDescriptor,
        view: DetailInfoViewProtocol,
        coordinator: DetailInfoCoordinatorProtocol
    ) {
        self.descriptor = descriptor
        self.view = view
        self.coordinator = coordinator
    }
    
    deinit {
        coordinator.finish()
    }
}

extension DetailInfoPresenter: DetailInfoPresenterProtocol {
    func onViewDidLoad() {
        rows = [
            .init(key: "Name", value: descriptor.name),
            .init(key: "Title", value: descriptor.title),
            .init(key: "Email", value: descriptor.email),
            .init(key: "Username", value: descriptor.username),
            .init(key: "City", value: descriptor.city),
            .init(key: "Website", value: descriptor.website)
        ]
        view?.reload()
    }
}
