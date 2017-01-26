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
    var backgroundView: UIView?

    init!(contentURL aUrl: URL!){
        super.init(frame: CGRect.zero)
        
        installNotificationObservers()
        
        self.backgroundColor = UIColor.green
        
        backgroundView = UIView.init()
        backgroundView?.backgroundColor = UIColor.black
        addSubview(backgroundView!)
        
        backgroundView?.snp.makeConstraints({ (make) in
            make.top.left.bottom.right.equalTo(self)
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
        selector: #selector(playStateDidChange(notification:)),
        name:NSNotification.Name.IJKMPMoviePlayerPlaybackStateDidChange,
        object: ffPlayer)
    }
    
    func playStateDidChange(notification: Notification) {
        videoPlayerControl?.videoNameLabel?.text = "更新了哈哈哈"
        videoPlayerControl?.playState = ffPlayer!.playbackState

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
    
    
    func willEnterInline() {
        var toFrame: CGRect = UIScreen.main.bounds
        let toWidth: CGFloat = toFrame.size.height
        let toHeight: CGFloat = toFrame.size.width
//        toFrame.size = CGSize.init(width: toWidth, height: toHeight)
        
        
        let xxx: AppDelegate =  UIApplication.shared.delegate as! AppDelegate
        xxx.viewMode = .fullscreen
        
        let animationDuration: TimeInterval = UIApplication.shared.statusBarOrientationAnimationDuration
        
        UIView.animate(withDuration: animationDuration, animations: {
            
            var angle: CGFloat = CGFloat(M_PI_2)
            if UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.landscapeLeft {
                angle *= -1
            }
//            UIDevice.current.orientation = UIDeviceOrientation.landscapeRight
            UIApplication.shared.statusBarOrientation = UIInterfaceOrientation.landscapeRight
            
            self.transform = CGAffineTransform.init(rotationAngle: angle)
            self.frame = toFrame

        }) { (finish) in
//            self.backgroundView?.frame = toFrame
            UIApplication.shared.statusBarOrientation = UIInterfaceOrientation.landscapeRight

        }
        
        

    }
    
        
    
}










