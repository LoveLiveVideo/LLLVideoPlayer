//
//  VideoPlayerControl.swift
//  LLLVideoPlayer
//
//  Created by ZK on 2017/1/10.
//  Copyright © 2017年 ZK. All rights reserved.
//

import Foundation


public protocol VideoPlayerControlProtocol : NSObjectProtocol {
    
    func goBack()
    
}

class VideoPlayerControl: UIControl {
    
    var mediaPlayback: IJKMediaPlayback?
    
    var videoPlayerControlDelegate: VideoPlayerControlProtocol?

    var backButton: UIButton?
    var playButton: UIButton?
    var switchButton: UIButton?
    
    var videoNameLabel: UILabel?
    var currentTimeLabel: UILabel?
    var totalDurationLabel: UILabel?

    var progressSlider: UISlider?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black
        
        backButton = UIButton.init(type: UIButtonType.custom)
        backButton?.setTitle("返回", for: UIControlState.normal)
        backButton?.setTitleColor(UIColor.white, for: UIControlState.normal)
        backButton?.addTarget(self, action: #selector(VideoPlayerControl.backButtonTap(sender:)), for: UIControlEvents.touchUpInside)
        self.addSubview(backButton!)

        backButton?.snp.makeConstraints({ (make) in
            make.left.top.equalTo(20)
            make.width.equalTo(40)
            make.height.equalTo(30)
        })
        
        videoNameLabel = UILabel.init()
        videoNameLabel?.textColor = UIColor.white
        videoNameLabel?.text = "测试测试测试"
        self.addSubview(videoNameLabel!)

        videoNameLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo(20)
            make.left.equalTo((backButton?.snp.right)!).offset(20)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(30)
        })
        
        playButton = UIButton.init(type: UIButtonType.custom)
        playButton?.setTitle("播放", for: UIControlState.normal)
        playButton?.setTitleColor(UIColor.white, for: UIControlState.normal)
        playButton?.addTarget(self, action: #selector(VideoPlayerControl.backButtonTap(sender:)), for: UIControlEvents.touchUpInside)
        self.addSubview(playButton!)
        
        playButton?.snp.makeConstraints({ (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(self).offset(-20)
            make.width.equalTo(40)
            make.height.equalTo(30)
        })
        
        switchButton = UIButton.init(type: UIButtonType.custom)
        switchButton?.setTitle("转屏", for: UIControlState.normal)
        switchButton?.setTitleColor(UIColor.white, for: UIControlState.normal)
        switchButton?.addTarget(self, action: #selector(VideoPlayerControl.backButtonTap(sender:)), for: UIControlEvents.touchUpInside)
        self.addSubview(switchButton!)
        
        switchButton?.snp.makeConstraints({ (make) in
            make.right.equalTo(self).offset(-20)
            make.bottom.equalTo(self).offset(-20)
            make.width.equalTo(40)
            make.height.equalTo(30)
        })
        
        totalDurationLabel = UILabel.init()
        totalDurationLabel?.textColor = UIColor.white
        totalDurationLabel?.font = UIFont.systemFont(ofSize: 13)
        totalDurationLabel?.textAlignment = NSTextAlignment.left
        self.addSubview(totalDurationLabel!)
        
        totalDurationLabel?.snp.makeConstraints({ (make) in
            make.right.equalTo((switchButton?.snp.left)!).offset(-10)
            make.bottom.equalTo(self).offset(-20)
            make.width.equalTo(45)
            make.height.equalTo(30)
        })
        
        currentTimeLabel = UILabel.init()
        currentTimeLabel?.textColor = UIColor.white
        currentTimeLabel?.font = UIFont.systemFont(ofSize: 13)
        currentTimeLabel?.textAlignment = NSTextAlignment.right
        self.addSubview(currentTimeLabel!)
        
        currentTimeLabel?.snp.makeConstraints({ (make) in
            make.right.equalTo((totalDurationLabel?.snp.left)!)
            make.bottom.equalTo(self).offset(-20)
            make.width.equalTo(45)
            make.height.equalTo(30)
        })
        
        progressSlider = UISlider.init()
        progressSlider?.addTarget(self, action: #selector(VideoPlayerControl.backButtonTap(sender:)), for: UIControlEvents.touchUpInside)
        self.addSubview(progressSlider!)
        
        progressSlider?.snp.makeConstraints({ (make) in
            make.left.equalTo((playButton?.snp.right)!).offset(10)
            make.right.equalTo((currentTimeLabel?.snp.left)!).offset(-10)
            make.bottom.equalTo(self).offset(-20)
            make.height.equalTo(30)
        })
        
        Timer.scheduledTimer(timeInterval: 1,
                             target: self,
                             selector: #selector(refreshPlayerControl),
                             userInfo: nil,
                             repeats: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setVideoPlayerControlDelegate(object: VideoPlayerControlProtocol) -> Void {
        videoPlayerControlDelegate = object
        
    }

    func backButtonTap(sender: UIButton) -> Void {
        videoPlayerControlDelegate?.goBack()
    }
    
    func refreshPlayerControl() -> Void {
        let duration: TimeInterval? = self.mediaPlayback?.duration
        if duration != nil {
            let durationR: TimeInterval! = duration
            if durationR > 0.0 {
                progressSlider?.maximumValue = Float(durationR)
                
                let minute = Int(durationR / 60)
                let second = Int(durationR.truncatingRemainder(dividingBy: 60))
                
                totalDurationLabel?.text = String.init(format: "/%02d:%02d", minute, second)
                
            }else{
                totalDurationLabel?.text = "/00:00"
                progressSlider?.maximumValue = 0.0;
            }
        }
        
        let position: TimeInterval? = mediaPlayback?.currentPlaybackTime
        if position != nil {
            let positionR: TimeInterval! = position
            if positionR > 0.0 {
                progressSlider?.value = Float(positionR)
                
                let minute = Int(positionR / 60)
                let second = Int(positionR.truncatingRemainder(dividingBy: 60))
                
                currentTimeLabel?.text = String.init(format: "%02d:%02d", minute, second)
                
            }else{
                currentTimeLabel?.text = "00:00"
                progressSlider?.value = Float(0.0)
            }
        }

    }
}












