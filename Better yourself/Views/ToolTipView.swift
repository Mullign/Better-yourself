//
//  ToolTipView.swift
//  A Better Day Workshop
//
//  Created by Chris Ching on 2024-10-22.
//

import SwiftUI

struct ToolTipView: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .foregroundStyle(Color.blue)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.blue, lineWidth: 1)
                    .background(Color("light-blue"))
            }
    }
}

#Preview {
    ToolTipView(text: "Hello, World!")
}
