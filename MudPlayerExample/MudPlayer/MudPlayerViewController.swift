//
//  MudPlayerViewController.swift
//  MudPlayerExample
//
//  Created by TimTiger on 16/1/14.
//  Copyright © 2016年 Mudmen. All rights reserved.
//

import UIKit
import AVFoundation

@available(iOS 7.0, *)
public protocol MudPlayerViewControllerDelegate: NSObjectProtocol {

}

@available(iOS 7.0, *)
public class MudPlayerViewContoller: UIViewController {
    
    /*!
    @property	delegate
    @abstract	代理
    */
    weak public var delegate: MudPlayerViewControllerDelegate?
    
    /*!
    @property	player
    @abstract	播放器
    */
    public var player: AVPlayer!
    
    /*
    @property readyForDisplay
    @abstract	是否已经准备好播放，只读属性
    */
    public var readyForDisplay: Bool!
    
    /*!
    @property	 videoGravity
    @abstract	设置视频如何展示
    @discussion	有 AVLayerVideoGravityResizeAspect, AVLayerVideoGravityResizeAspectFill 和 AVLayerVideoGravityResize. 这三种。默认是 AVLayerVideoGravityResizeAspect.
        <AVFoundation/AVAnimation.h> 可以找到这些类型的说明
    */
    public var videoGravity: String = AVLayerVideoGravityResizeAspect {
        didSet {
            if self.playerView != nil {
                self.playerView.videoGravity = self.videoGravity
            }
        }
    }
    
    /*!
    @property	videoBounds
    @abstract	当前视频相对于它的父视图的位置
    */
    public private(set) var videoBounds: CGRect!
    
    /*!
    @property	playerView
    @abstract	视频显示器
    */
    private var playerView: MudPlayerView!
    
    /*!
    @property	defaultControls
    @abstract 默认视频控制UI
    */
    private var defaultControls: MudPlayerControls!
    
    /*
    @property 	showsDefaultControls
    @abstract	是否显示自带控制UI, 默认true
    @discussion 如果你想定制自己的控制UI就设置为false, （将来版本将会支持
    */
    
    var showsDefaultControls: Bool = true {
        didSet {
            if self.defaultControls != nil {
                self.defaultControls.hidden = !showsDefaultControls
            }
        }
    }
    
    /*!
    @property	contentOverlayView
    @abstract 自定义的控制界面 放在此视图之上  将来的版本再支持
    */
    public var contentOverlayView: UIView!
    
    /*!
    @property	timeObserver
    @abstract 观察播放进度
    */
    private var timeObserver: AnyObject?
    
    /*!
    @property	shouldReplay
    @abstract 是否需要重播
    */
    private var shouldReplay: Bool = false
    
    //MARK: - Life cycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //info.plist: View controller-based status bar appearance set NO
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
    }
    
    public override func viewWillDisappear(animated: Bool) {
         super.viewWillDisappear(animated)
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
    }
    
    //MARK: - Private 
    private func initView() {
        //init player view
        self.initPlayerView()

        //init custom controls overlay
        self.initContentOverlayView()
        
        //init default controls view
        self.initControlsView()
    }
    
    private func initPlayerView() {
        self.playerView = MudPlayerView(frame: self.view.bounds)
        self.playerView.backgroundColor = UIColor.blackColor()
        self.playerView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth,UIViewAutoresizing.FlexibleHeight]
        self.playerView.player = self.player
        self.playerView.videoGravity = self.videoGravity
        self.addObserverForPlayer()
        self.view = self.playerView
    }
    
    private func initControlsView() {
        self.defaultControls = MudPlayerControls(frame: self.view.bounds)
        self.defaultControls.autoresizingMask = [UIViewAutoresizing.FlexibleWidth,UIViewAutoresizing.FlexibleHeight]
        self.defaultControls.hidden = !self.showsDefaultControls
        self.defaultControls.delegate = self
        self.view.addSubview(self.defaultControls)
    }
    
    private func initContentOverlayView() {
        self.contentOverlayView = UIView(frame: self.view.bounds)
        self.contentOverlayView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth,UIViewAutoresizing.FlexibleHeight]
        self.contentOverlayView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.contentOverlayView)
    }
    
    private func addObserverForPlayer() {
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handNotification:", name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        
        self.timeObserver = self.player.addPeriodicTimeObserverForInterval(CMTimeMake(1, 1), queue: dispatch_get_main_queue()) {
             [unowned self] time in
            
            if self.player.currentItem == nil {
                return
            }
            
            if UIApplication.sharedApplication().applicationState != .Active && self.defaultControls == nil {
                return
            }
            
            self.defaultControls.updatePlayButtonStatus(self.player.rate)
            self.defaultControls.updateControlsWithItem(self.player.currentItem!, time: time)
        }
    }
    
    internal func handNotification(notification: NSNotification) {
        self.shouldReplay = true
        self.defaultControls.updatePlayButtonStatus(self.player.rate)
    }
}

extension MudPlayerViewContoller: MudPlayerControlsDelegate {
    
    func setPlayerWithRate(rate: Float) {
        if rate == 0 {
            self.player.pause()
        } else {
            if self.shouldReplay {
                self.player.seekToTime(CMTime(seconds: 0, preferredTimescale: Int32(NSEC_PER_SEC)))
                self.shouldReplay = false
            }
            self.player.play()
        }
    }
    
    func playerControls(controls: MudPlayerControls,playOrPauseDidSelected sender: AnyObject?) {
        self.defaultControls.updatePlayButtonStatus(self.player.rate)
        self.setPlayerWithRate(1-self.player.rate)
    }
    
    func playerControls(controls: MudPlayerControls,progressValueChanged progress: Float,shouldPlay: Bool) {
        self.shouldReplay = false
        if shouldPlay {
            self.setPlayerWithRate(1)
        } else {
            self.setPlayerWithRate(0)
        }
        let seconds = self.player.currentItem!.durationSeconds*Double(progress)
        let time = CMTime(seconds: seconds, preferredTimescale: Int32(NSEC_PER_SEC))
        self.player.currentItem?.seekToTime(time)
    }
    
    func playerControls(controls: MudPlayerControls,closeDidSelected sender: AnyObject?) {
        self.setPlayerWithRate(0)
        if self.timeObserver != nil {
            self.player.removeTimeObserver(self.timeObserver!)
        }
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    func playerControls(controls: MudPlayerControls,shareDidSelected sender: AnyObject?) {
        self.setPlayerWithRate(0)
        if self.timeObserver != nil {
            self.player.removeTimeObserver(self.timeObserver!)
        }
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
}

