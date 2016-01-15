//
//  MudPlayerView.swift
//  MudPlayerExample
//
//  Created by TimTiger on 16/1/14.
//  Copyright © 2016年 Mudmen. All rights reserved.
//

import UIKit
import AVFoundation

@available(iOS 7.0, *)
class MudPlayerView: UIView {
    
    override class func layerClass() -> AnyClass {
        return AVPlayerLayer.self
    }
    
    var player: AVPlayer! {
        didSet {
            let playerLayer = layer as! AVPlayerLayer
            playerLayer.player = player
        }
}

    var videoGravity: String! {
        didSet {
            let playerLayer = layer as! AVPlayerLayer
            playerLayer.videoGravity = self.videoGravity
        }
    }
    
}
