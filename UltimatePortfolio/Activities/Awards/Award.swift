//
//  Award.swift
//  UltimatePortfolio
//
//  Created by Joanna Lingenfelter on 2/21/22.
//

import Foundation

struct Award: Decodable, Identifiable {
    var id: String { name }

    let name: String
    let description: String
    let color: String
    let criterion: String
    let value: Int
    let image: String

    static let allAwards = Bundle.main.decode([Award].self, from: "Awards.json")
    static let example = allAwards[0]
}
