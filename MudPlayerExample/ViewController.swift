//
//  ViewController.swift
//  MudPlayerExample
//
//  Created by TimTiger on 16/1/14.
//  Copyright © 2016年 Mudmen. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button =  UIButton(type: UIButtonType.Custom)
        button.frame = CGRectMake(0,0,100, 100)
        button.setImage(UIImage(named: "PlayerSource.bundle/player_playgray"), forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        button.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(self.view.frame)/2)
        self.view.addSubview(button)
    }
    
    func buttonAction(sender: AnyObject?) {
        let player = AVPlayer(URL: NSURL(string: "http://images.apple.com/media/us/iphone-6s/2015/dhs3b549_75f9_422a_9470_4a09e709b350/films/feature/iphone6s-feature-cc-us-20150909_r848-9dwc.mov")!)
        let playerVC = MudPlayerViewContoller()
        playerVC.player = player
        player.actionAtItemEnd = AVPlayerActionAtItemEnd.Pause
        self.view.addSubview(playerVC.view)
        self.addChildViewController(playerVC)
        player.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

