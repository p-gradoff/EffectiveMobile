//
//  EditData.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 20.11.2024.
//

import Foundation

// MARK: - structure for storing table view fields and their options

enum EditDataRequestCollection {
    case edit
    case share
    case remove
}

struct EditData {
    let text: String
    let imageName: String
    let type: EditDataRequestCollection
    
    static func getEditData() -> [EditData] {
        [
            EditData(text: "Редактировать", imageName: "square.and.pencil", type: .edit),
            EditData(text: "Поделиться", imageName: "square.and.arrow.up", type: .share),
            EditData(text: "Удалить", imageName: "trash", type: .remove)
        ]
    }
}
