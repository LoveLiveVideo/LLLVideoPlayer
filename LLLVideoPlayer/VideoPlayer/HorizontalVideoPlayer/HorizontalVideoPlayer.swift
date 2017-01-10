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

    
    init!(contentURL aUrl: URL!){
        super.init(frame: CGRect.zero)
        
        let options: IJKFFOptions = IJKFFOptions.byDefault()
        let ffPlayer: IJKFFMoviePlayerController = IJKFFMoviePlayerController.init(contentURL: aUrl, with: options)
        ffPlayer.scalingMode = IJKMPMovieScalingMode.aspectFit
        self.addSubview(ffPlayer.view)
        
        ffPlayer.view.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        
        let videoPlayerControl: VideoPlayerControl = VideoPlayerControl.init(frame: CGRect.zero)
        videoPlayerControl.videoPlayerControlDelegate = self
        videoPlayerControl.mediaPlayback = ffPlayer
        self.addSubview(videoPlayerControl)
        
        videoPlayerControl.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        
        ffPlayer.prepareToPlay()
        ffPlayer.play()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func goBack() {
        
    }
    
}










