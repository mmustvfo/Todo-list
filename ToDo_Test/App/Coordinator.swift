//
//  Coordinator.swift
//  ToDo_Test
//
//  Created by Mustafo on 21/09/25.
//

import Foundation

protocol Coordinator: AnyObject {
    var children: [Coordinator] { get set }
    
    func start()
}
