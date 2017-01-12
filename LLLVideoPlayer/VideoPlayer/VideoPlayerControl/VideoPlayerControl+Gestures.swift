//
//  VideoPlayerControl+Gestures.swift
//  LLLVideoPlayer
//
//  Created by ZK on 2017/1/12.
//  Copyright © 2017年 ZK. All rights reserved.
//

import Foundation

extension VideoPlayerControl {
    
    func registerGestureRecognizer()  {
        _callPlayerOverlayGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
            action:@selector(callPlayerOverlay:)];
        _callPlayerOverlayGesture.numberOfTapsRequired = 1;
        _callPlayerOverlayGesture.numberOfTouchesRequired = 1;
        _callPlayerOverlayGesture.delegate = self;
        [self.videoPlayerView addGestureRecognizer:_callPlayerOverlayGesture];
    }
    

    
}
