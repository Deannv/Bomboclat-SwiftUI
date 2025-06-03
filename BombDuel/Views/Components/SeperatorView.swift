//
//  SeperatorView.swift
//  BombDuel
//
//  Created by Adrian Yusufa Rachman on 02/06/25.
//

import SwiftUI

struct Seperator: View {
    let imageWidth: CGFloat
    let screenWidth: CGFloat
    let imageCount: Int
    let imageName: String?

    init(imageWidth: CGFloat = 25, imageName: String? = nil) {
        self.imageWidth = imageWidth
        self.screenWidth = UIScreen.main.bounds.width
        self.imageCount = Int(ceil(screenWidth / imageWidth)) + 4
        self.imageName = imageName
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<imageCount, id: \.self) { _ in
                if let imageName = imageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageWidth)
                } else {
                    // Default: Black bar
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: imageWidth, height: 2)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    Seperator()
}
