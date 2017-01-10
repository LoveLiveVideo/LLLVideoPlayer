//
//  HorizontalVideoPlayer.swift
//  LLLVideoPlayer
//
//  Created by ZK on 2017/1/9.
//  Copyright © 2017年 ZK. All rights reserved.
//

import Foundation
import SnapKit

public protocol HorizontalVideoPlayerProtocol : NSObjectProtocol {
    
    func goBack()
    
}

class HorizontalVideoPlayer: UIView, VideoPlayerControlProtocol {
    
    var horizontalVideoPlayerDelegate: HorizontalVideoPlayerProtocol?
    var ffPlayer: IJKFFMoviePlayerController?
    var videoPlayerControl: VideoPlayerControl?
    
    init!(contentURL aUrl: URL!){
        super.init(frame: CGRect.zero)
        
        self.installNotificationObservers()
        
        let backgroundView: UIView = UIView.init()
        backgroundView.backgroundColor = UIColor.black
        self.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
        
        let options: IJKFFOptions = IJKFFOptions.byDefault()
        ffPlayer = IJKFFMoviePlayerController.init(contentURL: aUrl, with: options)
        ffPlayer?.scalingMode = IJKMPMovieScalingMode.aspectFit
        self.addSubview((ffPlayer?.view)!)
        
        ffPlayer?.view.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        
        videoPlayerControl = VideoPlayerControl.init(frame: CGRect.zero)
        videoPlayerControl?.videoPlayerControlDelegate = self
        videoPlayerControl?.mediaPlayback = ffPlayer
        self.addSubview(videoPlayerControl!)
        
        videoPlayerControl?.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        
        ffPlayer?.prepareToPlay()
        ffPlayer?.play()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func currentPlaybackTime(position: TimeInterval!) {
        ffPlayer?.currentPlaybackTime = position
    }
    
    func goBack() {
        ffPlayer?.shutdown()
        horizontalVideoPlayerDelegate?.goBack()
    }
    
    func installNotificationObservers() {
        NotificationCenter.default.addObserver(self,
        selector: #selector(loadStateDidChange(notification:)),
        name:NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange,
        object: ffPlayer)
    }
    
    func loadStateDidChange(notification: Notification) {
        videoPlayerControl?.videoNameLabel?.text = "更新了哈哈哈"
    }
    
}










