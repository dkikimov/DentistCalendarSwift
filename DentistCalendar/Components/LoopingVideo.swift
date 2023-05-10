//
//  GifPlayerView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 07.07.2021.
//

import SwiftUI
import AVFoundation

struct LoopingPlayer: UIViewRepresentable {
    var videoName: String
    func makeUIView(context: Context) -> UIView {
        return QueuePlayerUIView(frame: .zero, videoName: videoName)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {

    }
}

class QueuePlayerUIView: UIView {
    private var playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    
    
    init(frame: CGRect, videoName: String) {
        super.init(frame: frame)
        
        if !videoName.isEmpty {
            let fileUrl = Bundle.main.url(forResource: videoName, withExtension: "mov")!
            let playerItem = AVPlayerItem(url: fileUrl)
            let player = AVQueuePlayer(playerItem: playerItem)
            playerLayer.player = player
            playerLayer.videoGravity = .resizeAspect
            layer.addSublayer(playerLayer)
            playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
            
            player.play()
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
