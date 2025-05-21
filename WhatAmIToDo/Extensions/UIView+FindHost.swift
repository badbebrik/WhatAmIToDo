//
//  UIView+FindHost.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 02.05.2025.
//

import UIKit
extension UIView {
    func findHostingController() -> UIViewController? {
        sequence(first: self) { $0.next }.first { $0 is UIViewController } as? UIViewController
    }
}
