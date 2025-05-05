//
//  GeneratedDrafts+Identifiable.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 03.05.2025.
//

import Foundation

extension GeneratedPhaseDraft: Identifiable {
    public var id: Int { order }
}

extension GeneratedTaskDraft: Identifiable {
    public var id: String { title }
}
