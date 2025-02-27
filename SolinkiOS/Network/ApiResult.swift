//
//  ApiResult.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-02-26.
//

import Foundation

enum ApiResult<T> {
    case success(T)
    case error(Int, String?) // Code and message
}
