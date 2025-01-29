//
//  ViewFactory.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import SwiftUI

protocol ViewFactory {
    func makeView() -> AnyView
}

typealias Routable = ViewFactory & Hashable
