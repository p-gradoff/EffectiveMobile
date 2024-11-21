//
//  RawNote.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 14.11.2024.
//

import Foundation

// MARK: - network model for loading data

struct RawTaskList: Codable {
    let todos: [RawTask]
    let total, skip, limit: Int
}

struct RawTask: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
