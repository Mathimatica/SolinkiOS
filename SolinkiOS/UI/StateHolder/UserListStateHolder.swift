//
//  UserListStateHolder.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-02-28.
//

import Foundation


struct UserListItemStateHolder: Equatable, Identifiable {
    let id: UUID
    let name: String
    let imageURL: String
    let processOnClick: ((((Photo) -> Void)) -> Void)
    
    static func == (lhs: UserListItemStateHolder, rhs: UserListItemStateHolder) -> Bool {
            // Compare only the properties you care about
            return lhs.name == rhs.name && lhs.imageURL == rhs.imageURL
            // Note: We skip onClick because functions can't be compared directly
        }
}

struct UserListStateHolder : Equatable {
    let users:[UserListItemStateHolder]
}
