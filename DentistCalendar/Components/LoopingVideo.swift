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
        
        // Load Video
        if !videoName.isEmpty {
            let fileUrl = Bundle.main.url(forResource: videoName, withExtension: "mov")!
            let playerItem = AVPlayerItem(url: fileUrl)
            // Setup Player
            let player = AVQueuePlayer(playerItem: playerItem)
            playerLayer.player = player
            playerLayer.videoGravity = .resizeAspect
            playerLayer.cornerRadius = 20
            playerLayer.masksToBounds = true
            layer.addSublayer(playerLayer)
            // Loop
            playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
            
            // Play
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


//class PlayerUIView: UIView {
//    private var playerLayer = AVPlayerLayer()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        // Load Video
//        let fileUrl = Bundle.main.url(forResource: "VideoWithBlock", withExtension: "mov")!
//        let playerItem = AVPlayerItem(url: fileUrl)
//
//        // Setup Player
//        let player = AVPlayer(playerItem: playerItem)
//        playerLayer.player = player
//        playerLayer.videoGravity = .resizeAspectFill
//        layer.addSublayer(playerLayer)
//
//        // Loop
//        player.actionAtItemEnd = .none
//        NotificationCenter.default.addObserver(self, selector: #selector(rewindVideo(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
//
//        // Play
//        player.play()
//    }
//
//    @objc
//    func rewindVideo(notification: Notification) {
//        playerLayer.player?.seek(to: .zero)
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        playerLayer.frame = bounds
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

//struct LoopingPlayer_Previews: PreviewProvider {
//    static var previews: some View {
//        LoopingPlayer()
//    }
//}
