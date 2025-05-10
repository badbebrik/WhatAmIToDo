//
//  ScheduleDTO.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 10.05.2025.
//

import Foundation


struct ScheduleDayResponse: Codable {
    let date: String
    let tasks: [ScheduledTaskDTO]
}

struct ScheduledTaskDTO: Codable {
    let id: UUID
    let title: String
    let startTime: String
    let endTime:   String
    let status: String
}

struct StatsResponse: Codable {
    let tasksPlanned: Int
    let tasksCompleted: Int

    lazy var tasksCompletedRatio: Int = {
        tasksCompleted / tasksPlanned
    }()
}

struct MotivationTodayResponse: Codable {
    let motivation: String
}
