//
//  CircleButtonVisual.swift
//  BombDuel
//
//  Created by Kemas Deanova on 21/05/25.
//

import SwiftUI

struct CircleButtonVisual: View {
    var size: Int
    var label: String
    
    var body: some View {
        Text(label)
            .font(Font.custom("ARCADECLASSIC", size: CGFloat(size - (size * 10/100))))
            .foregroundColor(.white)
            .padding(CGFloat(size))
            .background(
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(.primary).opacity(0.4), Color(.primary)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    Circle()
                        .stroke(Color.white.opacity(0.6), lineWidth: CGFloat(size - (size * 65/100)))
                }
            )
            .clipShape(Circle())
            .shadow(color: Color.black.opacity(0.4), radius: 10, x: 5, y: 8)
    }
}

#Preview {
    CircleButtonVisual(size: 30, label: "Button")
}
