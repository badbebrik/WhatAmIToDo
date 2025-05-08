import Foundation

// MARK: - Create Goal Models
struct CreateGoalRequest: Codable {
    let title: String
    let description: String?
    let hoursPerWeek: Int
    let estimatedTime: Int?
    let phases: [CreatePhaseRequest]?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case hoursPerWeek = "hours_per_week"
        case estimatedTime = "estimated_time"
        case phases
    }
}

struct CreatePhaseRequest: Codable {
    let title: String
    let description: String?
    let order: Int?
    let estimatedTime: Int?
    let tasks: [CreateTaskRequest]?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case order
        case estimatedTime = "estimatedTime"
        case tasks
    }
}

struct CreateTaskRequest: Codable {
    let title: String
    let description: String?
    let estimatedTime: Int?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case estimatedTime = "estimated_time"
    }
}

struct CreateGoalResponse: Codable {
    let goal: GoalResponse
}

// MARK: - Generate Goal Models
struct GenerateGoalRequest: Codable {
    let title: String
    let description: String?
    let hoursPerWeek: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case hoursPerWeek = "hours_per_week"
    }
}

struct GenerateGoalResponse: Codable {
    let generatedGoal: GeneratedGoalPreview
    
    enum CodingKeys: String, CodingKey {
        case generatedGoal = "generated_goal"
    }
}

struct GeneratedGoalPreview: Codable, Equatable {
    static func == (lhs: GeneratedGoalPreview, rhs: GeneratedGoalPreview) -> Bool {
        lhs.title == rhs.title
    }

    let title: String
    let description: String?
    let hoursPerWeek: Int
    let estimatedTime: Int
    let phases: [GeneratedPhaseDraft]
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case hoursPerWeek = "hours_per_week"
        case estimatedTime = "estimated_time"
        case phases
    }
}

struct GeneratedPhaseDraft: Codable {
    let title: String
    let description: String?
    let estimatedTime: Int
    let order: Int
    let tasks: [GeneratedTaskDraft]
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case estimatedTime = "estimatedTime"
        case order
        case tasks
    }
}

struct GeneratedTaskDraft: Codable {
    let title: String
    let description: String?
    let estimatedTime: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case estimatedTime = "estimated_time"
    }
}

// MARK: - List Goals Models
struct ListGoalsRequest: Codable {
    let limit: Int
    let offset: Int
    let status: String?
}

struct ListGoalsResponse: Codable {
    let goals: [ListGoalItem]
    let meta: Meta
    
    struct Meta: Codable {
        let total: Int
        let limit: Int
        let offset: Int
    }
}

struct ListGoalItem: Codable {
    let id: UUID
    let title: String
    let description: String?
    let status: String
    let progress: Int
    let hoursPerWeek: Int?
    let updatedAt: Date?
    let createdAt: Date?
    let nextTask: NextTask?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case status
        case progress
        case hoursPerWeek = "hours_per_week"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case nextTask = "next_task"
    }
    
    struct NextTask: Codable {
        let id: UUID
        let title: String
        let dueDate: Date?
        
        enum CodingKeys: String, CodingKey {
            case id
            case title
            case dueDate = "due_date"
        }
    }
}

// MARK: - Response Models
struct GetGoalResponse: Codable {
    let goal: GoalResponse
}

struct GoalResponse: Codable {
    let id: UUID
    let userId: Int64?
    let title: String
    let description: String?
    let status: String
    let hoursPerWeek: Int?
    let estimatedTime: Int?
    let progress: Int
    let createdAt: Date?
    let updatedAt: Date?
    let phases: [PhaseResponse]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case title
        case description
        case status
        case hoursPerWeek = "hours_per_week"
        case estimatedTime = "estimated_time"
        case progress
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case phases
    }
}

struct PhaseResponse: Codable {
    let id: UUID
    let goalId: UUID?
    let title: String
    let description: String?
    let status: String
    let progress: Int
    let order: Int
    let createdAt: Date?
    let updatedAt: Date?
    let tasks: [TaskResponse]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case goalId = "goal_id"
        case title
        case description
        case status
        case progress
        case order
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case tasks
    }
}

struct TaskResponse: Codable {
    let id: UUID?
    let goalId: UUID?
    let phaseId: UUID?
    let title: String
    let description: String?
    let status: String
    let estimatedTime: Int?
    let completedAt: Date?
    let createdAt: Date?
    let updatedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case goalId = "goal_id"
        case phaseId = "phase_id"
        case title
        case description
        case status
        case estimatedTime = "estimated_time"
        case completedAt = "completed_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
} 
