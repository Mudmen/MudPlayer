//
//  MudPlayerControls.swift
//  MudPlayerExample
//
//  Created by TimTiger on 16/1/14.
//  Copyright © 2016年 Mudmen. All rights reserved.
//

import UIKit
import AVFoundation

protocol MudPlayerControlsDelegate: NSObjectProtocol {
    func playerControls(controls: MudPlayerControls,playOrPauseDidSelected sender: AnyObject?)
    func playerControls(controls: MudPlayerControls,progressValueChanged progress: Float,shouldPlay: Bool)
    func playerControls(controls: MudPlayerControls,closeDidSelected sender: AnyObject?)
    func playerControls(controls: MudPlayerControls,shareDidSelected sender: AnyObject?)
}

@available(iOS 7.0, *)
class MudPlayerControls: UIView {
    
    //MARK: - Public
    weak var delegate: MudPlayerControlsDelegate?
    
    //MARK: - Private
    /*!
    @property playButton
    @abstract	控制视频的暂停 与播放
    */
    var playButton: UIButton!
    
    var grayPlayButton: UIButton!
    
    /*!
    @property playButton
    @abstract	控制视频的暂停 与播放
    */
    private var closeButton: UIButton!
    
    /*!
    @property playButton
    @abstract	控制视频的暂停 与播放
    */
   private var shareButton: UIButton!
    
    /*!
    @property timeLabel
    @abstract	视频时长视图
    */
    var timeLabel: UILabel!
    
    /*!
    @property timeLabel
    @abstract	已播放时长视图
    */
    var watchedTimeLabel: UILabel!
    
    /*!
    @property progressView
    @abstract 视频缓冲进度
    */
    var progressView: UIProgressView!
    
    /*!
    @property progressSlider
    @abstract 视频进度调节控制
    */
    var progressSlider: UISlider!
    
    private var bottomBar: UIView!
    
    private var alphaChangeCount: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        //设置自动布局
        self.setupLayoutConstraint()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Private API
    private func setupView() {
        
        self.backgroundColor = UIColor.clearColor()
        
        self.bottomBar = UIView(frame: CGRectMake(0,0,100,37))
        self.bottomBar.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        self.bottomBar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.bottomBar)
        
        self.playButton = UIButton(type: UIButtonType.Custom)
        self.playButton.frame = CGRectMake(0, 0, 51, 37)
        self.playButton.backgroundColor = UIColor.clearColor()
        self.playButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.playButton.setImage(UIImage(named: "PlayerSource.bundle/player_play"), forState: UIControlState.Normal)
        self.bottomBar.addSubview(self.playButton)
        
        self.watchedTimeLabel = UILabel(frame: CGRectMake(0,0,30,37))
        self.watchedTimeLabel.font = UIFont.systemFontOfSize(12)
        self.watchedTimeLabel.textColor = UIColor.whiteColor()
        self.watchedTimeLabel.text = "00:00"
        self.watchedTimeLabel.backgroundColor = UIColor.clearColor()
        self.watchedTimeLabel.textAlignment = NSTextAlignment.Center
        self.watchedTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.bottomBar.addSubview(self.watchedTimeLabel)
        
        self.progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.Default)
        self.progressView.frame = CGRectMake(0, 0, 100, 1)
        self.progressView.progress = 0
        self.progressView.trackTintColor = UIColor(red: 30.0/255, green: 30.0/255, blue: 30.0/255, alpha: 1)
        self.progressView.progressTintColor = UIColor(red: 80.0/255, green: 80.0/255, blue: 80.0/255, alpha: 1)
        self.progressView.translatesAutoresizingMaskIntoConstraints = false
        self.bottomBar.addSubview(self.progressView)
        
        self.progressSlider = UISlider(frame: CGRectMake(0,0,100,37))
        self.progressSlider.minimumValue = 0
        self.progressSlider.maximumValue = 1
        self.progressSlider.value = 0
        self.progressSlider.addTarget(self, action: "sliderDragCancelAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.progressSlider.addTarget(self, action: "sliderDragCancelAction:", forControlEvents: UIControlEvents.TouchUpOutside)
        self.progressSlider.addTarget(self, action: "sliderDragAction:", forControlEvents: UIControlEvents.ValueChanged)
        self.progressSlider.setMinimumTrackImage(UIImage(named: "PlayerSource.bundle/player_maxtrackimage"), forState: UIControlState.Normal)
        self.progressSlider.setMaximumTrackImage(UIImage(named: "PlayerSource.bundle/player_mintrackimage"), forState: UIControlState.Normal)
        self.progressSlider.setThumbImage(UIImage(named: "PlayerSource.bundle/player_thumb"), forState: UIControlState.Normal)
        self.progressSlider.translatesAutoresizingMaskIntoConstraints = false
        self.bottomBar.addSubview(self.progressSlider)
        
        self.timeLabel = UILabel(frame: CGRectMake(0,0,100,37))
        self.timeLabel.font = UIFont.systemFontOfSize(12)
        self.timeLabel.text = "00:00"
        self.timeLabel.textColor = UIColor.whiteColor()
        self.timeLabel.backgroundColor = UIColor.clearColor()
        self.timeLabel.textAlignment = NSTextAlignment.Center
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.bottomBar.addSubview(self.timeLabel)
        
        self.closeButton = UIButton(type: UIButtonType.Custom)
        self.closeButton.frame = CGRectMake(0, 0, 47, 57)
        self.closeButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.closeButton.setImage(UIImage(named: "PlayerSource.bundle/player_back"), forState: UIControlState.Normal)
        self.closeButton.backgroundColor = UIColor.clearColor()
        self.addSubview(self.closeButton)
        
        self.shareButton = UIButton(type: UIButtonType.Custom)
        self.shareButton.frame = CGRectMake(0, 0, 47, 57)
        self.shareButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.shareButton.setImage(UIImage(named: "PlayerSource.bundle/player_share"), forState: UIControlState.Normal)
        self.shareButton.translatesAutoresizingMaskIntoConstraints = false
        self.shareButton.backgroundColor = UIColor.clearColor()
        self.addSubview(self.shareButton)
        
        self.grayPlayButton = UIButton(type: UIButtonType.Custom)
        self.grayPlayButton.frame = CGRectMake(0, 0, 40, 40)
        self.grayPlayButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.grayPlayButton.setImage(UIImage(named: "PlayerSource.bundle/player_playgray"), forState: UIControlState.Normal)
        self.grayPlayButton.backgroundColor = UIColor.clearColor()
        self.grayPlayButton.translatesAutoresizingMaskIntoConstraints = false
        self.grayPlayButton.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
        self.addSubview(self.grayPlayButton)
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "checkNeedHidden:", userInfo: nil, repeats: true)
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: "show")
        self.addGestureRecognizer(tapGesture)
    }
    
    private func setupLayoutConstraint() {
        let bottonBarHeightConstraint = NSLayoutConstraint(item: self.bottomBar, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 37)
        let bottomBarWidthConstraint = NSLayoutConstraint(item: self.bottomBar, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        let bottomBarLeftConstraint = NSLayoutConstraint(item: self.bottomBar, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let bottomBarRightConstraint = NSLayoutConstraint(item: self.bottomBar, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let bottomBarBottomConstraint = NSLayoutConstraint(item: self.bottomBar, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        self.addConstraints([bottonBarHeightConstraint,bottomBarWidthConstraint,bottomBarLeftConstraint,bottomBarRightConstraint,bottomBarBottomConstraint])
        
        let watchedTimeLabelHeightConstraint = NSLayoutConstraint(item: self.watchedTimeLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 37)
        let watchedTimeLabelWidthConstraint = NSLayoutConstraint(item: self.watchedTimeLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40)
        let watchedTimeLabelLeftConstraint = NSLayoutConstraint(item: self.watchedTimeLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.playButton, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let watchedTimeLabelBottomConstraint = NSLayoutConstraint(item: self.watchedTimeLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.bottomBar, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        self.bottomBar.addConstraints([watchedTimeLabelHeightConstraint,watchedTimeLabelWidthConstraint,watchedTimeLabelLeftConstraint,watchedTimeLabelBottomConstraint])
        
        let progressViewHeightConstraint = NSLayoutConstraint(item: self.progressView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 1)
        let progressViewLeftConstraint = NSLayoutConstraint(item: self.progressView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.watchedTimeLabel, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        let progressViewRightConstraint = NSLayoutConstraint(item: self.progressView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.timeLabel, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: -10)
        let progressViewBottomConstraint = NSLayoutConstraint(item: self.progressView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.bottomBar, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -17)
        self.bottomBar.addConstraints([progressViewHeightConstraint,progressViewLeftConstraint,progressViewRightConstraint,progressViewBottomConstraint])
        
        let progressSliderHeightConstraint = NSLayoutConstraint(item: self.progressSlider, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 37)
        let progressSliderLeftConstraint = NSLayoutConstraint(item: self.progressSlider, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.watchedTimeLabel, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        let progressSliderRightConstraint = NSLayoutConstraint(item: self.progressSlider, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.timeLabel, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: -10)
        let progressSliderBottomConstraint = NSLayoutConstraint(item: self.progressSlider, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.bottomBar, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        self.bottomBar.addConstraints([progressSliderHeightConstraint,progressSliderLeftConstraint,progressSliderRightConstraint,progressSliderBottomConstraint])
        
        let timeLabelHeightConstraint = NSLayoutConstraint(item: self.timeLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 37)
        let timeLabelWidthConstraint = NSLayoutConstraint(item: self.timeLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40)
        let timeLabelRightConstraint = NSLayoutConstraint(item: self.timeLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.bottomBar, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -15)
        let timeLabelBottomConstraint = NSLayoutConstraint(item: self.timeLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.bottomBar, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        self.bottomBar.addConstraints([timeLabelHeightConstraint,timeLabelWidthConstraint,timeLabelRightConstraint,timeLabelBottomConstraint])
        
        let shareButtonHeightConstraint = NSLayoutConstraint(item: self.shareButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 57)
        let shareButtonWidthConstraint = NSLayoutConstraint(item: self.shareButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 47)
        let shareButtonRightConstraint = NSLayoutConstraint(item: self.shareButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let shareButtonTopConstraint = NSLayoutConstraint(item: self.shareButton, attribute: NSLayoutAttribute.Top
            , relatedBy: NSLayoutRelation.Equal, toItem: self.closeButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        self.addConstraints([shareButtonHeightConstraint,shareButtonWidthConstraint,shareButtonRightConstraint,shareButtonTopConstraint])
        
        let grayPlayButtonHeightConstraint = NSLayoutConstraint(item: self.grayPlayButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40)
        let grayPlayButtonWidthConstraint = NSLayoutConstraint(item: self.grayPlayButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40)
        let grayPlayButtonRightConstraint = NSLayoutConstraint(item: self.grayPlayButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let grayPlayButtonTopConstraint = NSLayoutConstraint(item: self.grayPlayButton, attribute: NSLayoutAttribute.CenterY
            , relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        self.addConstraints([grayPlayButtonHeightConstraint,grayPlayButtonWidthConstraint,grayPlayButtonRightConstraint,grayPlayButtonTopConstraint])
    }
    
    private func alphaChange(viewAlpha: CGFloat) {
        UIView.animateWithDuration(0.25) { () -> Void in
            self.bottomBar.alpha = viewAlpha
            self.closeButton.alpha = viewAlpha
            self.shareButton.alpha = viewAlpha
        }
    }
    
    //MARK: - Public
    func updateControlsWithItem(item: AVPlayerItem,time: CMTime) {
        let totalDuration =  item.durationSeconds
        let currentDuration = CMTimeGetSeconds(time)
        self.progressView.setProgress(item.loadedProgress.floatValue, animated: true)
        self.progressSlider.setValue(item.playProgress.floatValue, animated: true)
        self.timeLabel.text = totalDuration.minutesAndSeconds
        self.watchedTimeLabel.text = currentDuration.minutesAndSeconds
    }
    
    func updatePlayButtonStatus(rate: Float) {
        if rate == 0 {
            self.grayPlayButton.hidden = false
            self.playButton.setImage(UIImage(named: "PlayerSource.bundle/player_play"), forState: UIControlState.Normal)
        } else {
            self.grayPlayButton.hidden = true
            self.playButton.setImage(UIImage(named: "PlayerSource.bundle/player_pause"), forState: UIControlState.Normal)
        }
    }
    
    //MARK: - Actions
    func checkNeedHidden(sender: AnyObject?) {
        if self.alphaChangeCount > 3 {
            self.alphaChange(0.3)
            self.alphaChangeCount = 0
        }
        self.alphaChangeCount++;
    }
    
    func show() {
        self.alphaChangeCount = 0
        self.alphaChange(1)
    }
    
    func buttonAction(sender: UIButton) {
        self.show()
        if sender == self.playButton || sender == self.grayPlayButton {
            if self.delegate != nil {
                self.delegate?.playerControls(self, playOrPauseDidSelected: sender)
            }
        } else if sender == self.closeButton {
            if self.delegate != nil {
                self.delegate?.playerControls(self, closeDidSelected: sender)
            }
        } else if sender == self.shareButton {
            if self.delegate != nil {
                self.delegate?.playerControls(self, shareDidSelected: sender)
            }
        }
    }
    
    func sliderDragCancelAction(sender: UISlider) {
        self.show()
        if self.delegate != nil {
            self.delegate?.playerControls(self, progressValueChanged: sender.value,shouldPlay: true)
        }
    }

    func sliderDragAction(sender: UISlider) {
        self.show()
        if self.delegate != nil {
            self.delegate?.playerControls(self, progressValueChanged: sender.value,shouldPlay: false)
        }
    }
}
