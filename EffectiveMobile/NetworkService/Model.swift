//
//  RawNote.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 14.11.2024.
//

import Foundation

struct RawTaskList: Codable {
    let todos: [RawTask]
    let total, skip, limit: Int
}

struct RawTask: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userID: Int
}
