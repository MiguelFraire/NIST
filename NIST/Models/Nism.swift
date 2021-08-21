//
//  Nism.swift
//  NIST
//
//  Created by Miguel Fraire on 7/30/21.
//

// Nasa Image Search Model

//   let nism = try? newJSONDecoder().decode(Nism.self, from: jsonData)

import Foundation

// MARK: - Nism
struct Nism:Codable {
    let collection: Collection
}

// MARK: - Collection
struct Collection:Codable {
    let items: [Item]
    let metadata: Metadata
}

// MARK: - Item
struct Item:Codable, Hashable {
    let data: [Datum]
    let links: [Link]
}

// MARK: - Datum
struct Datum:Codable, Hashable {
    let title: String
    let dateCreated: String
    let center, mediaType: String
    var photographer, location, description508: String?
}

// MARK: - Link
struct Link:Codable, Hashable {
    let href: String
}

// MARK: - Metadata
struct Metadata:Codable {
    let totalHits: Int
}
