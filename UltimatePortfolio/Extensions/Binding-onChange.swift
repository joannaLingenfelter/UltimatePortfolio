//
//  Binding-onChange.swift
//  UltimatePortfolio
//
//  Created by Joanna Lingenfelter on 2/9/22.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping (() -> Void)) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}
