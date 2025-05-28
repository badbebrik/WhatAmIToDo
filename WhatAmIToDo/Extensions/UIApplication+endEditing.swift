//
//  Untitled.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 28.05.2025.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
