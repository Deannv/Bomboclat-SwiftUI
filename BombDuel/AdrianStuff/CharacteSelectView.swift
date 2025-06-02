//
//  CharacteSelectView.swift // atau CharacterSelectView.swift
//  BombDuel
//
//  Created by Adrian Yusufa Rachman on 23/05/25.
//

import SwiftUI

struct CharacteSelectView: View { // Pastikan nama struct konsisten
    @Environment(\.presentationMode) var presentationMode

    @State private var player1Character: Character?
    @State private var player2Character: Character?
    // selectedIndex tidak terlalu relevan untuk mode di sini, tapi mungkin dipakai CharacterViewForSelectScreen
    @State private var selectedIndexForCarousel = 1 // Indikasi konteks multiplayer untuk carousel
    @State private var selectedCharacterIndex1 = 0
    @State private var selectedCharacterIndex2 = 0
    @State private var navigateToGame = false

    let characterOptions = ["Angel", "Kemas", "Farid", "Javier", "Adrian", "Nanda", "Ravshan", "Charlie", "Emma", "Frea"]

    // Pastikan CharacterViewForSelectScreen sudah punya karakter default yang dipilih saat muncul
    init() {
        // Inisialisasi karakter awal untuk P1 dan P2 saat view dibuat
        // agar tidak nil saat tombol Next ditekan sebelum interaksi carousel
        _player1Character = State(initialValue: Character(name: characterOptions[0], imageName: characterOptions[0], unlockTrophy: 0))
        _player2Character = State(initialValue: Character(name: characterOptions[0], imageName: characterOptions[0], unlockTrophy: 0))
    }

    var body: some View {
        NavigationStack {
            ZStack{
                BackGroundImg() // Menggunakan BackGroundImg dari HomeView.swift

                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image("Back-Button") // Pastikan aset "Back-Button" ada
                        .resizable()
                        .frame(width: 31, height: 31)
                }
                .offset(x: -160, y: -330)

                // Player 1 selector (top, flipped)
                CharacterViewForSelectScreen(
                    // selectedIndex: $selectedIndexForCarousel, // Jika CharacterViewForSelectScreen memerlukannya
                    selectedCharacterIndex: $selectedCharacterIndex2,
                    characterOptions: characterOptions,
                    selectedCharacter: $player2Character,
                    imageSize: CGSize(width: 200, height: 200)
                )
                .scaleEffect(x: -1, y: -1)
                .offset(x: 0, y: -200)

                // Player 2 selector (bottom)
                CharacterViewForSelectScreen(
                    // selectedIndex: $selectedIndexForCarousel, // Jika CharacterViewForSelectScreen memerlukannya
                    selectedCharacterIndex: $selectedCharacterIndex1,
                    characterOptions: characterOptions,
                    selectedCharacter: $player1Character,
                    imageSize: CGSize(width: 200, height: 200)
                )
                .offset(x: 0, y: 170)

                Button(action: {
                    // Karakter seharusnya sudah diinisialisasi di init() atau diupdate oleh carousel
                    navigateToGame = true
                }) {
                    Image("Next Button") // Pastikan aset "Next Button" ada
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                }
                .buttonStyle(PlainButtonStyle())
                .offset(x: 0, y: 350)
                .navigationDestination(isPresented: $navigateToGame) {
                    GameView(
                        player1: Player(name: "Player 1", selectedCharacter: player1Character!),
                        player2: Player(name: "Player 2", selectedCharacter: player2Character!)
                    )
                }
            }
        }
    }
}


struct CharacterViewForSelectScreen: View {
    @Binding var selectedCharacterIndex: Int
    let characterOptions: [String]
    @Binding var selectedCharacter: Character?
    let imageSize: CGSize

    @State private var scrollViewProxy: ScrollViewProxy?
    private let spacing: CGFloat = 20
    init(selectedCharacterIndex: Binding<Int>,
         characterOptions: [String],
         selectedCharacter: Binding<Character?>,
         imageSize: CGSize) {
        self._selectedCharacterIndex = selectedCharacterIndex
        self.characterOptions = characterOptions
        self._selectedCharacter = selectedCharacter
        self.imageSize = imageSize

        if selectedCharacter.wrappedValue == nil && !characterOptions.isEmpty {
            let initialIndex = selectedCharacterIndex.wrappedValue
            if characterOptions.indices.contains(initialIndex) {
                 selectedCharacter.wrappedValue = Character(
                    name: characterOptions[initialIndex],
                    imageName: characterOptions[initialIndex],
                    unlockTrophy: 0
                )
            }
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 0) {
                Button(action: {
                    withAnimation(.easeInOut) {
                        selectedCharacterIndex = max(selectedCharacterIndex - 1, 0)
                        updateSelectedCharacter()
                        scrollToSelected()
                    }
                }) {
                    Image("arrow-left-svg")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .foregroundColor(selectedCharacterIndex == 0 ? .gray : .blue)
                }
                .disabled(selectedCharacterIndex == 0)
                .padding(.trailing, 5)

                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: spacing) {
                            ForEach(Array(characterOptions.enumerated()), id: \.offset) { index, characterName in
                                CharacterCard(
                                    character: characterName, // Kirim nama karakter (String)
                                    isSelected: index == selectedCharacterIndex,
                                    imageSize: imageSize
                                )
                                .id(index) // ID untuk scrolling
                                .onTapGesture {
                                    withAnimation(.easeInOut) {
                                        selectedCharacterIndex = index
                                        updateSelectedCharacter()
                                        // Scroll ke kartu yang dipilih
                                        proxy.scrollTo(index, anchor: .center)
                                    }
                                }
                            }
                        }
                        // Padding agar kartu di tengah saat pertama kali muncul atau di ujung
                        .padding(.horizontal, (UIScreen.main.bounds.width - imageSize.width - spacing * 2) / 2 )
                    }
                    .frame(width: imageSize.width + spacing * 2) // Sesuaikan lebar ScrollView
                    .onAppear {
                        scrollViewProxy = proxy
                        // Update karakter dan scroll saat pertama kali muncul
                        updateSelectedCharacter()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Delay kecil untuk memastikan proxy siap
                             scrollToSelected(proxy: proxy)
                        }
                    }
                }

                Button(action: {
                    withAnimation(.easeInOut) {
                        selectedCharacterIndex = min(selectedCharacterIndex + 1, characterOptions.count - 1)
                        updateSelectedCharacter()
                        scrollToSelected()
                    }
                }) {
                    Image("arrow-right-svg")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .foregroundColor(selectedCharacterIndex == characterOptions.count - 1 ? .gray : .blue)
                }
                .disabled(selectedCharacterIndex == characterOptions.count - 1)
                .padding(.leading, 5) // Beri sedikit jarak dari carousel
            }
            .frame(maxWidth: .infinity) // Agar HStack mengisi lebar yang tersedia

            // Nama Karakter di bawah Carousel
            if let char = selectedCharacter {
                 Text(char.name)
                    .font(.custom("ARCADECLASSIC", size: 20))
                    .foregroundColor(.white)
                    .padding(.top, 5)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func updateSelectedCharacter() {
        guard characterOptions.indices.contains(selectedCharacterIndex) else { return }
        let characterName = characterOptions[selectedCharacterIndex]
        selectedCharacter = Character(
            name: characterName,
            imageName: characterName, // Asumsi imageName sama dengan name
            unlockTrophy: 0
        )
    }

    private func scrollToSelected(proxy: ScrollViewProxy? = nil) {
        let proxyToUse = proxy ?? scrollViewProxy
        guard let currentProxy = proxyToUse else { return }
        currentProxy.scrollTo(selectedCharacterIndex, anchor: .center)
    }
}

struct CharacterCard: View {
    let character: String // Sekarang menerima String nama karakter
    let isSelected: Bool
    let imageSize: CGSize

    var body: some View {
        Image(character) // Menggunakan nama karakter untuk mencari gambar
            .resizable()
            .scaledToFit()
            .frame(width: imageSize.width, height: imageSize.height)
            .scaleEffect(isSelected ? 1.0 : 0.8)
            .opacity(isSelected ? 1.0 : 0.6)
            .shadow(color: isSelected ? .yellow.opacity(0.8) : .clear, radius: 10)
            .animation(.spring(), value: isSelected) // Menggunakan .spring() untuk animasi lebih halus
            .cornerRadius(12)
    }
}

// Preview untuk CharacteSelectView
struct CharacteSelectView_Previews: PreviewProvider {
    static var previews: some View {
        CharacteSelectView()
    }
}
