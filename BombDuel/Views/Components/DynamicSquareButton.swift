//
//  DynamicSquareButton.swift
//  BombDuel
//
//  Created by Kemas Deanova on 03/06/25.
//

import SwiftUI

struct DynamicSquareButton: View {
    var callback: () -> Void
    var size: Int
    var width: Int = 165
    var label: String
    var body: some View {
        Button(action: {
            callback()
        }) {

            ZStack{

                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: CGFloat(width), height: 65)
                    .background(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.98, green: 0.72, blue: 0.37), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.83, green: 0.57, blue: 0.16), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                        )
                    )
                    .cornerRadius(20)
                    .shadow(color: Color(red: 0.64, green: 0.38, blue: 0.12), radius: 0, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .inset(by: 1)
                            .stroke(Color(red: 0.98, green: 0.87, blue: 0.77), lineWidth: 2)
                    )
                Text(label)
                    .font(Font.custom("ARCADECLASSIC", size: CGFloat(size - (size * 12 / 100))))
                    .foregroundColor(.white)
                    .padding(CGFloat(size))
            }

        }
    }
}

#Preview {
    DynamicSquareButton(callback: {return}, size: 20, label: "Test Label")
}
