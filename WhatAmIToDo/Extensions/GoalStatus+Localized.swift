//
//  GoalStatus+Localized.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 03.05.2025.
//

import Foundation
import SwiftUI

extension GoalStatus {
    var localizedTitle: LocalizedStringKey {
        switch self {
        case .active:    return "Активна"
        case .completed: return "Завершена"
        case .paused:    return "Пауза"
        case .planning:  return "Готова к планированию"
        }
    }

    var tint: Color { color.opacity(0.1) }
}
