//
//  PhotoResponse.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-02-26.
//

import Foundation

struct PhotoResponse: Codable{
    let photos: [Photo]
}

struct Photo: Codable {
    let id: Int
    let photographer: String
    let url: String
    let src: ImageSources
}

struct ImageSources: Codable {
    let original: String
    let medium: String
    let small: String
}
