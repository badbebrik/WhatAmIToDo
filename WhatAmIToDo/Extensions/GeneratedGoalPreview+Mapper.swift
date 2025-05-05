//
//  GeneratedGoalPreview+Mapper.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 03.05.2025.
//

import Foundation

extension GeneratedGoalPreview {
    func asCreateGoalRequest() -> CreateGoalRequest {
        CreateGoalRequest(
            title: title,
            description: description,
            hoursPerWeek: hoursPerWeek,
            estimatedTime: estimatedTime,
            phases: phases.map { phase in
                CreatePhaseRequest(
                    title: phase.title,
                    description: phase.description,
                    order: phase.order,
                    estimatedTime: phase.estimatedTime,
                    tasks: phase.tasks.map { task in
                        CreateTaskRequest(
                            title: task.title,
                            description: task.description,
                            estimatedTime: task.estimatedTime
                        )
                    }
                )
            }
        )
    }
}
