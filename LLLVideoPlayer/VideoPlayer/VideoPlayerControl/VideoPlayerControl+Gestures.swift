//
//  VideoPlayerControl+Gestures.swift
//  LLLVideoPlayer
//
//  Created by ZK on 2017/1/12.
//  Copyright © 2017年 ZK. All rights reserved.
//

import Foundation

extension VideoPlayerControl : UIGestureRecognizerDelegate{
    
    var panRecognizer: UIPanGestureRecognizer {
        get{
            if _panRecognizer == nil {
                _panRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(handlePanRecognizer(sender:)))
//                _panRecognizer?.maximumNumberOfTouches = 1
                _panRecognizer!.delegate = self
            }
            return _panRecognizer!
        }
    }
    
    func registerGestureRecognizer()  {
        
        let showOverlayGesture: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(showOverlay(sender:)))
        showOverlayGesture.numberOfTapsRequired = 1
        showOverlayGesture.numberOfTouchesRequired = 1
        showOverlayGesture.delegate = self
        addGestureRecognizer(showOverlayGesture)
        
        addGestureRecognizer(panRecognizer)

    }
    
    func showOverlay(sender: UITapGestureRecognizer) -> Void {
        if voerlayAlpha < 1.0 {
            showOverlayView(show: true)
        }else {
            showOverlayView(show: false)
        }
    }
    
    func showOverlayView(show: Bool) {
        overlayHiddenTimerCount = 0
        
        let alpha: CGFloat = show ? 1.0 : 0.0;
        let duration: TimeInterval = UIApplication.shared.statusBarOrientationAnimationDuration

        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: { 
            self.setAlpha(alpha: alpha)
        }) { (finish) in
            
        }
    }
    
    func setAlpha(alpha: CGFloat) {
        voerlayAlpha = alpha
        
        playButton?.alpha = alpha
        pauseButton?.alpha = alpha
        switchButton?.alpha = alpha
        
        videoNameLabel?.alpha = alpha
        currentTimeLabel?.alpha = alpha
        totalDurationLabel?.alpha = alpha

        progressSlider?.alpha = alpha
        
        bottomProgressSlider?.alpha = 1-alpha
        
        backgroundView.alpha = alpha
        
    }
    
    func registerTimer() {
        if overlayHiddenTimer == nil {
            overlayHiddenTimer = Timer.init(timeInterval: 0.1, target: self, selector: #selector(setOverlayHidden), userInfo: nil, repeats: true)
            RunLoop.current.add(overlayHiddenTimer!, forMode: RunLoopMode.defaultRunLoopMode)
        }
    }
    
    func setOverlayHidden() {
        if voerlayAlpha > 0.0 && playState ==  IJKMPMoviePlaybackState.playing{
            overlayHiddenTimerCount += 1;
            if overlayHiddenTimerCount > 50 {
                overlayHiddenTimerCount = 0
                showOverlayView(show: false)
            }
        }
    }
    
    func handlePanRecognizer(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case UIGestureRecognizerState.began:
            
            break
        case UIGestureRecognizerState.changed:
            let translation: CGPoint = sender.translation(in: self)
            let location: CGPoint = sender.location(in: self)
            //左右
            if fabs(translation.y) < fabs(translation.x) {
                //秒
                let swipeTime: TimeInterval = TimeInterval(translation.x)/5.0
                var endPlayTime = (mediaPlayback?.currentPlaybackTime)! + swipeTime
                endPlayTime = endPlayTime > 0.0 ? endPlayTime : 0.0
                
                let seekOrientation = translation.x >= 0.0 ? SeekViewIconOrientation.forward : SeekViewIconOrientation.backward
                
                playerSeekView.update(withPlaybackTime: CGFloat(endPlayTime), duration: CGFloat((mediaPlayback?.duration)!), orientation: seekOrientation)
                playerSeekView.center = CGPoint.init(x: self.bounds.size.width/2.0, y: self.bounds.size.height/2.0)
                
                currentPlayTime = endPlayTime
            }else if (fabs(translation.y) > fabs(translation.x) && fabs(location.x) < self.bounds.size.width/2) {
      
                //声音有系统ui，亮度没有方格，可以自己做一个亮度UI，bilili做法
                UIScreen.main.brightness -= (translation.y / 10) * 0.02
                
                brightSlider.updateValue(UIScreen.main.brightness)
                
            }else if (fabs(translation.y) > fabs(translation.x) && fabs(location.x) > self.bounds.size.width/2) {
                
                mpVolumeSilder.value -= Float((translation.y / 10) * 0.02)
            }

            
            break
        case UIGestureRecognizerState.ended:
            
            playerSeekView.removeFromSuperview()
            brightSlider.removeFromSuperview()

            seek(aTime: currentPlayTime)
            
            break
        default:
            break
        }
        
    }
    
    func seek(aTime: TimeInterval) {

        
        videoPlayerControlDelegate?.currentPlaybackTime(position: aTime)

    }




    
    
}






