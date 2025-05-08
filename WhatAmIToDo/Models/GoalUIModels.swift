import Foundation
import SwiftUI

// MARK: - Goal List UI Models
struct GoalListItem: Identifiable, Hashable {
    static func == (lhs: GoalListItem, rhs: GoalListItem) -> Bool {
        lhs.id == rhs.id
    }

    let id: UUID
    let title: String
    let description: String?
    let status: GoalStatus
    let progress: Int
    let hoursPerWeek: Int
    let updatedAt: Date
    let createdAt: Date
    let nextTask: NextTask?
    let color: Color
    
    init(from listGoalItem: ListGoalItem) {
        self.id = listGoalItem.id
        self.title = listGoalItem.title
        self.description = listGoalItem.description
        self.status = GoalStatus(rawValue: listGoalItem.status) ?? .active
        self.progress = listGoalItem.progress
        self.hoursPerWeek = listGoalItem.hoursPerWeek ?? 0
        self.updatedAt = listGoalItem.updatedAt ?? Date()
        self.createdAt = listGoalItem.createdAt ?? Date()
        self.nextTask = listGoalItem.nextTask.map { NextTask(from: $0) }
        self.color = GoalStatus(rawValue: listGoalItem.status)?.color ?? .blue
    }
    
    struct NextTask: Hashable {
        let id: UUID
        let title: String
        let dueDate: Date?
        
        init(from nextTask: ListGoalItem.NextTask) {
            self.id = nextTask.id
            self.title = nextTask.title
            self.dueDate = nextTask.dueDate
        }
    }
}

// MARK: - Goal Detail UI Models
struct GoalDetailItem: Identifiable {
    let id: UUID
    let title: String
    let description: String?
    let status: GoalStatus
    let hoursPerWeek: Int
    let estimatedTime: Int?
    let progress: Int
    let createdAt: Date?
    let updatedAt: Date?
    let phases: [PhaseDetailItem]?
    
    init(from goalResponse: GoalResponse) {
        self.id = goalResponse.id
        self.title = goalResponse.title
        self.description = goalResponse.description
        self.status = GoalStatus(rawValue: goalResponse.status) ?? .active
        self.hoursPerWeek = goalResponse.hoursPerWeek ?? 0
        self.estimatedTime = goalResponse.estimatedTime
        self.progress = goalResponse.progress
        self.createdAt = goalResponse.createdAt
        self.updatedAt = goalResponse.updatedAt
        self.phases = goalResponse.phases?.map { PhaseDetailItem(from: $0) }
    }
}

struct PhaseDetailItem: Identifiable {
    let id: UUID
    let title: String
    let description: String?
    let status: PhaseStatus
    let progress: Int
    let order: Int
    let tasks: [TaskDetailItem]?
    
    init(from phaseResponse: PhaseResponse) {
        self.id = phaseResponse.id
        self.title = phaseResponse.title
        self.description = phaseResponse.description
        self.status = PhaseStatus(rawValue: phaseResponse.status) ?? .pending
        self.progress = phaseResponse.progress
        self.order = phaseResponse.order
        self.tasks = phaseResponse.tasks?.map { TaskDetailItem(from: $0) }
    }
}

struct TaskDetailItem: Identifiable {
    let id: UUID
    let title: String
    let description: String?
    let status: TaskStatus
    let estimatedTime: Int?
    let completedAt: Date?
    
    init(from taskResponse: TaskResponse) {
        self.id = taskResponse.id ?? UUID()
        self.title = taskResponse.title
        self.description = taskResponse.description
        self.status = TaskStatus(rawValue: taskResponse.status) ?? .pending
        self.estimatedTime = taskResponse.estimatedTime
        self.completedAt = taskResponse.completedAt
    }
}

// MARK: - Status Enums
enum GoalStatus: String {
    case planning = "planning"
    case active = "active"
    case completed = "completed"
    case paused = "paused"

    var color: Color {
        switch self {
        case .active: return .blue
        case .completed: return .green
        case .paused: return .orange
        case .planning: return .gray
        }
    }
    
    var icon: String {
        switch self {
        case .active: return "play.circle.fill"
        case .completed: return "checkmark.circle.fill"
        case .paused: return "pause.circle.fill"
        case .planning: return "archivebox.fill"
        }
    }
}

enum PhaseStatus: String {
    case pending = "pending"
    case inProgress = "in_progress"
    case completed = "completed"
    
    var color: Color {
        switch self {
        case .pending: return .gray
        case .inProgress: return .blue
        case .completed: return .green
        }
    }
}

enum TaskStatus: String {
    case pending = "pending"
    case inProgress = "in_progress"
    case completed = "completed"
    
    var color: Color {
        switch self {
        case .pending: return .gray
        case .inProgress: return .blue
        case .completed: return .green
        }
    }
} 
