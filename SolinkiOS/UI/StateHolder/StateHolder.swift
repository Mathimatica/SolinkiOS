//
//  StateHolder.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-02-26.
//

import Foundation

enum StateHolder<T : Equatable> : Equatable{
    case loading
    case success(T)
    case error(String)
}
