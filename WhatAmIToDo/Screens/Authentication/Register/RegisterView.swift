//
//  RegisterView.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import SwiftUI

struct RegisterView: View {

    @StateObject var viewModel: RegisterViewModel

    var body: some View {
        Text("Register Screen")
            .font(.largeTitle)
            .fontWeight(.bold)
    }
}

#Preview {
    RegisterView(viewModel: .init(router: RegisterRouter.mock))
}
