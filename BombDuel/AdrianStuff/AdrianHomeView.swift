////
////  AdrianHomeView.swift
////  BombDuel
////
////  Created by Adrian Yusufa Rachman on 21/05/25.
////
//
//import SwiftUI
//
//struct AdrianHomeView: View {
//    var body: some View {
//        ZStack {
//            Color(red: 0.99, green: 0.49, blue: 0.02)
//                .ignoresSafeArea(edges: .all)
//            Image("blur-cloud")
//                .scaledToFit()
//                .offset(x: 0, y: -200)
//            
//            Image("blur-cloud")
//                .scaledToFit()
//                .offset(x: -90, y: 200)
//                
//            Image("Back-Button")
//                .resizable()
//                .frame(width: 31, height: 31)
//                .offset(x: -160, y: -330)
//        
//            VStack{
//                Spacer()
//                    .frame(height: 80)
//                CharacterView()
////
////
////                Spacer()
////                    .frame(height: 30)
////
//
//                
//                ContinueButton(action: { print("Button tapped!") }, label: "CONTINUE")
//                
//                
//            }
//            
//        }
//    }
//}
//
//struct CharacterView: View {
//    @State private var selectedIndex = 0
//    @State private var selectedCharacterIndex = 0
//    @State private var selectedIndex2 = 0
//
//    let options = ["Single", "Double"]
//    let characterOptions = ["Angel", "Kemas", "Farid", "Javier", "Adrian", "Nanda", "Ravshan"]
//
//    var selectedCharacter: String {
//        characterOptions[selectedCharacterIndex]
//    }
//
//    var body: some View {
//        VStack {
//            // Character images
//            ZStack {
//                Image(selectedCharacter)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 350, height: 350)
//                    .offset(x: selectedIndex == 1 ? -90 : 0)
//                    .scaleEffect(selectedIndex == 1 ? 0.85 : 1.0)
//                    .animation(.spring(response: 0.4, dampingFraction: 0.4), value: selectedIndex)
//
//                // ? character
//                if selectedIndex == 1 {
//                    VStack {
//                        Image("DefaultChara")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 350, height: 350)
//                            .transition(
//                                .asymmetric(
//                                    insertion: .move(edge: .trailing).combined(with: .opacity),
//                                    removal: .move(edge: .trailing).combined(with: .opacity)
//                                )
//                            )
//                            .scaleEffect(0.85)
//                            .animation(.spring(response: 0.6, dampingFraction: 0.1), value: selectedIndex) // animations doesnt work
//                            .offset(x: 90)
//                        
//                    }
//                    .transition(.move(edge: .trailing).combined(with: .opacity)) // doesnt work
//                    .animation(.easeInOut(duration: 0.5), value: selectedIndex) // doesnt work
//                }
//
//            }
//
//            Spacer().frame(height: 30)
//
//            // Single / Double selector
//            SelectorView(options: options, currentIndex: $selectedIndex) { index in
//                print("Selected mode: \(options[index])")
//            }
//
//            // Dynamic selector
//            if selectedIndex == 1 {
//                SelectorView(options: ["CPU", "PvP"], currentIndex: $selectedIndex2) { index in
//                    print("Selected index: \(index)")
//                }
//            } else {
//                SelectorView(options: characterOptions, currentIndex: $selectedCharacterIndex) { index in
//                    print("Selected character: \(characterOptions[index])")
//                }
//            }
//        }
//    }
//}
//
//
//
//struct SelectorView: View {
//    let options: [String]
//    @Binding var currentIndex: Int
//    var onSelectionChanged: ((Int) -> Void)?
//
//    var body: some View {
//        HStack {
//            // Left arrow button
//            Button {
//                currentIndex = (currentIndex - 1 + options.count) % options.count
//                onSelectionChanged?(currentIndex)
//            } label: {
//                Image("arrow-left-svg")
//                    .resizable()
//                    .frame(width: 55, height: 55)
//            }
//            .buttonStyle(PlainButtonStyle())
//
//            // Current selection
//            Text(options[currentIndex])
//                .font(.custom("ARCADECLASSIC", size: 32))
//                .foregroundColor(.white)
//
//            // Right arrow button
//            Button {
//                currentIndex = (currentIndex + 1) % options.count
//                onSelectionChanged?(currentIndex)
//            } label: {
//                Image("arrow-right-svg")
//                    .resizable()
//                    .frame(width: 55, height: 55)
//            }
//            .buttonStyle(PlainButtonStyle())
//        }
//    }
//}
//
//
//
//struct ContinueButton: View {
//    let action: () -> Void
//    let label: String
//
//    var body: some View {
//        Button(action: action) {
//            Rectangle()
//                .foregroundColor(.clear)
//                .frame(width: 194, height: 56.86207)
//                .background(
//                    LinearGradient(
//                        stops: [
//                            Gradient.Stop(color: Color(red: 0.98, green: 0.72, blue: 0.37), location: 0),
//                            Gradient.Stop(color: Color(red: 0.83, green: 0.57, blue: 0.16), location: 1)
//                        ],
//                        startPoint: UnitPoint(x: 0.5, y: 0),
//                        endPoint: UnitPoint(x: 0.5, y: 1)
//                    )
//                )
//                .cornerRadius(20)
//                .shadow(color: Color(red: 0.64, green: 0.38, blue: 0.12), radius: 0, x: 0, y: 4)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 20)
//                        .inset(by: 1)
//                        .stroke(Color(red: 0.98, green: 0.87, blue: 0.77), lineWidth: 2)
//                )
//                .overlay(
//                    Text(label)
//                        .font(.custom("ARCADECLASSIC", size: 20))
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.center)
//                        .foregroundColor(.white)
//                        .frame(width: 98.67242, height: 25.08621)
//                )
//        }
//        .buttonStyle(PlainButtonStyle()) // Prevents default button color/effect
//    }
//}
//
//
//
//
//#Preview {
//    AdrianHomeView()
//}
