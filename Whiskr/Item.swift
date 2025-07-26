//
//  Item.swift
//  Whiskr
//
//  Created by Vansh Parikh on 2025-07-26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
