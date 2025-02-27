//
//  NetworkError.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-02-26.
//

import Foundation

enum NetworkError: Error {
    case httpError(Int, String?)
    case unknownError(String)
}
