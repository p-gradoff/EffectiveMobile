//
//  EditData.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 20.11.2024.
//

import Foundation

enum EditDataRequestCollection {
    case edit, share, remove
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
