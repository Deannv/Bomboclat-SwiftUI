//
//  SoundManager.swift
//  BombDuel
//
//  Created by Kemas Deanova on 19/05/25.
//

import Foundation
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    private var player: AVAudioPlayer?
    private var isMuted = false

    func playBackgroundMusic() {
        guard !isMuted, let url = Bundle.main.url(forResource: "bgmusic", withExtension: "mp3") else { return }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.play()
        } catch {
            print("Error loading music: \(error)")
        }
    }

    func toggleMute() {
        isMuted.toggle()
        if isMuted {
            player?.stop()
        } else {
            playBackgroundMusic()
        }
    }
}
