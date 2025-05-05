//
//  LocalNavigationCoordinator.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 03.05.2025.
//

import SwiftUI

final class LocalNavigationCoordinator: NavigationCoordinator {
    @Binding private var path: NavigationPath

    init(path: Binding<NavigationPath>) {
        _path = path
    }

    func push(_ router: any Routable) {
        path.append(AnyRoutable(router))
    }

    func popLast() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
