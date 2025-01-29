//
//  NavigationCoordinator.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import Foundation

protocol NavigationCoordinator {
    func push(_ path: any Routable)
    func popLast()
    func popToRoot()
}
