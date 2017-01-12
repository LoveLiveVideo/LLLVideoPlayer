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
        
        installNotificationObservers()
        
        let backgroundView: UIView = UIView.init()
        backgroundView.backgroundColor = UIColor.black
        addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
        
        let options: IJKFFOptions = IJKFFOptions.byDefault()
        ffPlayer = IJKFFMoviePlayerController.init(contentURL: aUrl, with: options)
        ffPlayer?.scalingMode = IJKMPMovieScalingMode.aspectFit
        addSubview((ffPlayer?.view)!)
        
        ffPlayer?.view.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        
        videoPlayerControl = VideoPlayerControl.init(frame: CGRect.zero)
        videoPlayerControl?.videoPlayerControlDelegate = self
        videoPlayerControl?.mediaPlayback = ffPlayer
        addSubview(videoPlayerControl!)
        
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
    
    func installNotificationObservers() {
        NotificationCenter.default.addObserver(self,
        selector: #selector(loadStateDidChange(notification:)),
        name:NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange,
        object: ffPlayer)
    }
    
    func loadStateDidChange(notification: Notification) {
        videoPlayerControl?.videoNameLabel?.text = "更新了哈哈哈"
        videoPlayerControl?.setPlayButton(playbackState: ffPlayer!.playbackState)

        switch ffPlayer!.playbackState {
        case IJKMPMoviePlaybackState.playing:
            
            break
        case IJKMPMoviePlaybackState.stopped:
            
            break
        case IJKMPMoviePlaybackState.paused:
            
            break
        case IJKMPMoviePlaybackState.interrupted:
            
            break
        case IJKMPMoviePlaybackState.seekingForward:
            
            break
        case IJKMPMoviePlaybackState.seekingBackward:
            
            break
        default:
            break
        }
        
    }
    
    
    func goBack() {
        ffPlayer?.shutdown()
        horizontalVideoPlayerDelegate?.goBack()
    }
    
    func play() {
        ffPlayer?.play()
    }
    
    func pause() {
        ffPlayer?.pause()
    }
}










