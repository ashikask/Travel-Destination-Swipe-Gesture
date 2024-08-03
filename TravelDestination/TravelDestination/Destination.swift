//
//  Destination.swift
//  TravelDestination
//
//  Created by ashika kalmady on 8/2/24.
//

import Foundation

/// Model to represent a destination
struct Destination: Identifiable, Equatable {
    let id = UUID()
    let name: String
    var imageName: String
    var showHeart: Bool = false
    var showSadFace: Bool = false
    var isWishListed: Bool = false
}
