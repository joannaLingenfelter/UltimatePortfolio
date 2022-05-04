//
//  SelectSomethingView.swift
//  UltimatePortfolio
//
//  Created by Joanna Lingenfelter on 2/21/22.
//

import SwiftUI

struct SelectSomethingView: View {
    var body: some View {
        Text(Strings.selectSomethingToBegin.key)
            .italic()
            .foregroundColor(.secondary)
    }
}

struct SelectSomethingView_Previews: PreviewProvider {
    static var previews: some View {
        SelectSomethingView()
    }
}
