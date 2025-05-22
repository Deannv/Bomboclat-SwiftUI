//
//  AdrianGameplayView.swift
//  BombDuel
//
//  Created by Adrian Yusufa Rachman on 22/05/25.
//

import SwiftUI

struct AdrianGameplayView: View {
    var body: some View {
        ZStack {
            Color(red: 0.99, green: 0.49, blue: 0.02)
                .ignoresSafeArea(edges: .all)
            Image("blur-cloud")
                .scaledToFit()
                .offset(x: 0, y: -200)
            
            Image("blur-cloud")
                .scaledToFit()
                .offset(x: -90, y: 200)
            
            TrainTrackView()
            
            ZStack{
                
            }
           
        }
    }
}


struct TrainTrackView: View {
    let imageWidth: CGFloat = 25 // Set this to your actual image width
    let screenWidth = UIScreen.main.bounds.width
    let imageCount: Int // Number of images needed to cover the screen

    init() {
        // Calculate how many images are needed to cover the screen
        self.imageCount = Int(ceil(screenWidth / imageWidth)) + 3
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<imageCount, id: \.self) { _ in
                Image("TrainTracks")
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageWidth)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}




#Preview {
    AdrianGameplayView()
}
