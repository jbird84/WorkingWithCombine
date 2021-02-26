//
//  User.swift
//  WorkingWithCombine
//
//  Created by Kinney Kare on 2/25/21.
//

import Foundation
import SwiftUI

struct User: Decodable, Identifiable {
    let name: String
    let id: Int
}
