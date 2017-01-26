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
    
    func play()
    
    func pause()

    
    func currentPlaybackTime(position: TimeInterval!)
    
    func willEnterInline()
}

class VideoPlayerControl: UIControl {
    
    var _viewMode: VideoPlayerViewMode = .inline
    var viewMode: VideoPlayerViewMode {
        set(newState){
            _viewMode = newState
        }
        get{
            return _viewMode
        }
    }
    
    let playButtonLeft: Float = 0
    let backButtonTop: Float = 20
    let backButtonLeft: Float = 10
    let videoNameLabelLeft: Float = 12
    let videoNameLabelH: Float = 15
    let totalDurationLabelR: Float = 7
    let totalDurationLabelH: Float = 12
    let totalDurationLabelW: Float = 40
    let progressSliderLeft: Float = 6
    let progressSliderRight: Float = 8


    var mediaPlayback: IJKMediaPlayback?
    
    var videoPlayerControlDelegate: VideoPlayerControlProtocol?

    var backButton: UIButton?
    var playButton: UIButton?
    var pauseButton: UIButton?
    var switchButton: UIButton?
    
    var videoNameLabel: UILabel?
    var currentTimeLabel: UILabel?
    var totalDurationLabel: UILabel?

    var progressSlider: SVPlayerSlider?
    var bottomProgressSlider: SHProgressView?

    var progressSliderDragging: Bool = false
    
    var voerlayAlpha: CGFloat = 1.0
    var overlayHiddenTimer: Timer?
    var overlayHiddenTimerCount: Int = 0
    
    var _playState: IJKMPMoviePlaybackState = .stopped
    var playState: IJKMPMoviePlaybackState {
        set(newState){
            _playState = newState
            self.setPlayButtonState()
        }
        get{
            return _playState
        }
    }
    
    var _currentPlayTime: TimeInterval = 0.0
    var currentPlayTime: TimeInterval {
        set(newState){
            _currentPlayTime = newState
            
            progressSlider?.value = Float(_currentPlayTime)
            let value: CGFloat = CGFloat(_currentPlayTime)/CGFloat((progressSlider?.maximumValue)!)
            progressSlider?.setProcessValue(value)
            bottomProgressSlider?.setProgress(value, animated: false)
            
            let minute = Int(_currentPlayTime / 60)
            let second = Int(_currentPlayTime.truncatingRemainder(dividingBy: 60))
            
            currentTimeLabel?.text = String.init(format: "%02d:%02d", minute, second)
        }
        get{
            return _currentPlayTime
        }
    }
    
    var _backgroundView: UIView?
    var backgroundView: UIView {
        get{
            if _backgroundView == nil {
                _backgroundView = UIView.init()
                _backgroundView?.isUserInteractionEnabled = true
                _backgroundView?.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
                insertSubview(_backgroundView!, at: 0)
                
                _backgroundView!.snp.makeConstraints({ (make) in
                    make.edges.equalTo(self)
                })
            }
            return _backgroundView!
        }
    }
    
    var _playerSeekView: PlayerSeekView?
    var playerSeekView: PlayerSeekView {
        get{
            if _playerSeekView == nil {
                _playerSeekView = PlayerSeekView.init()
                _playerSeekView?.isUserInteractionEnabled = false
            }
            if _playerSeekView!.superview == nil {
                addSubview(_playerSeekView!)
            }

            return _playerSeekView!
        }
    }
    
    var _brightSlider: SHVoumeBrightSlider?
    var brightSlider: SHVoumeBrightSlider {
        get{
            if _brightSlider == nil {
                _brightSlider = SHVoumeBrightSlider.init(brightSlider: )()
            }
            if _brightSlider!.superview == nil {
                addSubview(_brightSlider!)
                
                _brightSlider!.snp.makeConstraints({ (make) in
                    make.edges.equalTo(self)
                })
            }
            return _brightSlider!
        }
    }

    var _panRecognizer: UIPanGestureRecognizer?
    
    
    var currentDeviceVolume: Float?
    var _mpVolumeSilder: UISlider?
    var mpVolumeSilder: UISlider {
        get{
            if _mpVolumeSilder == nil {
                let mpVolumeView: MPVolumeView = MPVolumeView()
                for view in mpVolumeView.subviews {
                    let uiview: UIView = view as UIView
                    if uiview.isKind(of: NSClassFromString("MPVolumeSlider")!){
                        _mpVolumeSilder = (uiview as! UISlider)
                    }
                }
            }
            
            currentDeviceVolume = _mpVolumeSilder!.value

            return _mpVolumeSilder!
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        registerGestureRecognizer()
        registerTimer()

        self.setBackButton()

        videoNameLabel = UILabel.init()
        videoNameLabel?.textColor = UIColor.white
        videoNameLabel?.text = "测试测试测试"
        videoNameLabel?.font = UIFont.systemFont(ofSize: CGFloat(videoNameLabelH))
        self.addSubview(videoNameLabel!)

        videoNameLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo((backButton?.snp.right)!).offset(videoNameLabelLeft)
            make.centerY.equalTo(backButton!)
            make.right.equalTo(self).offset(-videoNameLabelLeft)
            make.height.equalTo(videoNameLabelH)
        })
        
        playButton = UIButton.init(type: UIButtonType.custom)
        playButton?.setImage(UIImage.init(named: "PlayerInline-Btn-Play-Normal"), for: UIControlState.normal)
        playButton?.setImage(UIImage.init(named: "PlayerInline-Btn-Play-Pressed"), for: UIControlState.highlighted)
        playButton?.setImage(UIImage.init(named: "PlayerInline-Btn-Play-Disable"), for: UIControlState.disabled)
        playButton?.addTarget(self, action: #selector(VideoPlayerControl.playButtonTap(sender:)), for: UIControlEvents.touchUpInside)
        self.addSubview(playButton!)
        
        playButton?.snp.makeConstraints({ (make) in
            make.left.equalTo(playButtonLeft)
            make.bottom.equalTo(self).offset(-playButtonLeft)
            make.width.equalTo(45)
            make.height.equalTo(39)
        })
        
        pauseButton = UIButton.init(type: UIButtonType.custom)
        pauseButton?.setImage(UIImage.init(named: "PlayerInline-Btn-Pause-Normal"), for: UIControlState.normal)
        pauseButton?.setImage(UIImage.init(named: "PlayerInline-Btn-Pause-Pressed"), for: UIControlState.highlighted)
        pauseButton?.setImage(UIImage.init(named: "PlayerInline-Btn-Pause-Disable"), for: UIControlState.disabled)
        pauseButton?.addTarget(self, action: #selector(VideoPlayerControl.pauseButtonTap(sender:)), for: UIControlEvents.touchUpInside)
        self.addSubview(pauseButton!)
        pauseButton?.isHidden = true
        
        pauseButton?.snp.makeConstraints({ (make) in
            make.left.equalTo(playButtonLeft)
            make.bottom.equalTo(self).offset(-playButtonLeft)
            make.width.equalTo(45)
            make.height.equalTo(39)
        })
        
        switchButton = UIButton.init(type: UIButtonType.custom)
        switchButton?.setImage(UIImage.init(named: "PlayerInline-Btn-FullScreen-Normal"), for: UIControlState.normal)
        switchButton?.setImage(UIImage.init(named: "PlayerInline-Btn-FullScreen-Highlighted"), for: UIControlState.highlighted)
        switchButton?.addTarget(self, action: #selector(VideoPlayerControl.switchButtonTap(sender:)), for: UIControlEvents.touchUpInside)
        self.addSubview(switchButton!)
        
        switchButton?.snp.makeConstraints({ (make) in
            make.right.equalTo(self).offset(-playButtonLeft)
            make.bottom.equalTo(self).offset(-playButtonLeft)
            make.width.equalTo(38)
            make.height.equalTo(39)
        })
        
        totalDurationLabel = UILabel.init()
        totalDurationLabel?.textColor = UIColor.white.withAlphaComponent(0.5)
        totalDurationLabel?.font = UIFont.systemFont(ofSize: CGFloat(totalDurationLabelH))
        totalDurationLabel?.textAlignment = NSTextAlignment.left
        totalDurationLabel?.text = "/00:00"
        self.addSubview(totalDurationLabel!)
        
        totalDurationLabel?.snp.makeConstraints({ (make) in
            make.right.equalTo((switchButton?.snp.left)!).offset(-totalDurationLabelR)
            make.centerY.equalTo(playButton!)
            make.width.equalTo(totalDurationLabelW)
            make.height.equalTo(totalDurationLabelH)
        })
        
        currentTimeLabel = UILabel.init()
        currentTimeLabel?.textColor = UIColor.white.withAlphaComponent(0.5)
        currentTimeLabel?.font = UIFont.systemFont(ofSize: CGFloat(totalDurationLabelH))
        currentTimeLabel?.textAlignment = NSTextAlignment.right
        currentTimeLabel?.text = "00:00"
        self.addSubview(currentTimeLabel!)
        
        currentTimeLabel?.snp.makeConstraints({ (make) in
            make.right.equalTo((totalDurationLabel?.snp.left)!)
            make.centerY.equalTo(playButton!)
            make.width.equalTo(totalDurationLabelW)
            make.height.equalTo(totalDurationLabelH)
        })
        
        progressSlider = SVPlayerSlider.init()
        self.addSubview(progressSlider!)
        progressSlider?.addTarget(self, action: #selector(progressSliderTouchDown(sender:)), for: UIControlEvents.touchDown)
        progressSlider?.addTarget(self, action: #selector(progressSliderTouchUpOutside(sender:)), for: UIControlEvents.touchUpOutside)
        progressSlider?.addTarget(self, action: #selector(progressSliderTouchUpInside(sender:)), for: UIControlEvents.touchUpInside)
        progressSlider?.addTarget(self, action: #selector(progressSliderTouchCancel(sender:)), for: UIControlEvents.touchCancel)
        progressSlider?.setThumbImage(UIImage.init(named: "PlayerFullScreen-Btn-ProgressBar-Normal"), for: UIControlState.normal)
        progressSlider?.setThumbImage(UIImage.init(named: "PlayerFullScreen-Btn-ProgressBar-Highlighted"), for: UIControlState.highlighted)
        progressSlider?.setThumbImage(UIImage.init(named: "PlayerFullScreen-Btn-ProgressBar-Disabled"), for: UIControlState.disabled)
        
        let leftImage: UIImage = UIImage.init(named: "PlayerFullScreen-Bg-ProgressBar-Left")!
        let rightImage: UIImage = UIImage.init(named: "PlayerFullScreen-Bg-ProgressBar-Right")!
        let downloadImage: UIImage = UIImage.init(named: "PlayerFullScreen-Bg-ProgressBar-Download")!
        let width: CGFloat = rightImage.size.width/2.0
        let height: CGFloat = rightImage.size.height/2.0
        progressSlider?.setMinimumTrackImage(rightImage.stretchableImage(withLeftCapWidth: Int(width), topCapHeight: Int(height)), for: UIControlState.normal)
        progressSlider?.setMaximumTrackImage(rightImage.stretchableImage(withLeftCapWidth: Int(width), topCapHeight: Int(height)), for: UIControlState.normal)
        //缓存进度
        progressSlider?.setDownloadedImage(downloadImage)
        progressSlider?.setProcessImage(leftImage)

        progressSlider?.snp.makeConstraints({ (make) in
            make.left.equalTo((playButton?.snp.right)!).offset(progressSliderLeft)
            make.right.equalTo((currentTimeLabel?.snp.left)!).offset(-progressSliderRight)
            make.bottom.equalTo(self)
            make.height.equalTo(39)
        })
        
        bottomProgressSlider = SHProgressView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 2))
        addSubview(bottomProgressSlider!)
        bottomProgressSlider?.progressImage = UIImage.init(named: "PlayerFullScreen-Bg-ProgressBar-Left")
        bottomProgressSlider?.trackImage = UIImage.init(color: UIColor.init(hexString: "#000000", alpha: 0.6), size: CGSize.init(width: 2.0, height: 2.0))
        bottomProgressSlider?.setProgress(0.0, animated: true)
        bottomProgressSlider?.snp.makeConstraints({ (make) in
            make.left.bottom.right.equalTo(self)
            make.height.equalTo(2)
        })
        
        self.refreshPlayerControl()
        Timer.scheduledTimer(timeInterval: 0.5,
                             target: self,
                             selector: #selector(refreshPlayerControl),
                             userInfo: nil,
                             repeats: true)
        
        showOverlayView(show: true)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setVideoPlayerControlDelegate(object: VideoPlayerControlProtocol) -> Void {
        videoPlayerControlDelegate = object
    }
    
    func setBackButton() {
        backButton = UIButton.init(type: UIButtonType.custom)
        backButton?.setImage(UIImage.init(named: "All-Btn-BackOfLight-Normal"), for: UIControlState.normal)
        backButton?.setImage(UIImage.init(named: "All-Btn-BackOfLight-Highlighted"), for: UIControlState.highlighted)
        backButton?.addTarget(self, action: #selector(backButtonTap(sender:)), for: UIControlEvents.touchUpInside)
        self.addSubview(backButton!)
        
        backButton?.snp.makeConstraints({ (make) in
            make.top.equalTo(backButtonTop)
            make.left.equalTo(backButtonLeft)
            make.width.equalTo(22)
            make.height.equalTo(32)
        })
    }
    
    func backButtonTap(sender: UIButton) -> Void {
        videoPlayerControlDelegate?.goBack()
    }
    
    func playButtonTap(sender: UIButton) -> Void {
        playButton?.isHidden = true
        pauseButton?.isHidden = false
        videoPlayerControlDelegate?.play()
    }
    
    func pauseButtonTap(sender: UIButton) -> Void {
        playButton?.isHidden = false
        pauseButton?.isHidden = true
        videoPlayerControlDelegate?.pause()
    }
    
    func setPlayButtonState() {
        if playState == IJKMPMoviePlaybackState.stopped ||
            playState == IJKMPMoviePlaybackState.paused ||
            playState == IJKMPMoviePlaybackState.interrupted {
            playButton?.isHidden = false
            pauseButton?.isHidden = true
        }else {
            playButton?.isHidden = true
            pauseButton?.isHidden = false
        }
    }
    
    func switchButtonTap(sender: UIButton) -> Void {
        if viewMode == .inline {
           self.switchView(toMode: .fullscreen, completetion: { 
            
           })
        }else {
        
        }
        
    }
    
    func progressSliderTouchDown(sender: UISlider) -> Void {
        progressSliderDragging = true
    }
    
    func progressSliderTouchCancel(sender: UISlider) -> Void {
        progressSliderDragging = false
    }
    
    func progressSliderTouchUpOutside(sender: UISlider) -> Void {
        progressSliderDragging = false
    }
    
    func progressSliderTouchUpInside(sender: UISlider) -> Void {
        progressSliderDragging = false
        let position: TimeInterval = TimeInterval.init((progressSlider?.value)!)
        videoPlayerControlDelegate?.currentPlaybackTime(position: position)
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
        
        let position: TimeInterval?
        if progressSliderDragging {
            position = TimeInterval.init((progressSlider?.value)!)
        }else {
            position = mediaPlayback?.currentPlaybackTime
        }
        if position != nil {
            let positionR: TimeInterval! = position
            if positionR > 0.0 {
                progressSlider?.value = Float(positionR)
                let value: CGFloat = CGFloat(positionR)/CGFloat((progressSlider?.maximumValue)!)
                progressSlider?.setProcessValue(value)
                bottomProgressSlider?.setProgress(value, animated: true)

                let minute = Int(positionR / 60)
                let second = Int(positionR.truncatingRemainder(dividingBy: 60))
                
                currentTimeLabel?.text = String.init(format: "%02d:%02d", minute, second)
                
            }else{
                currentTimeLabel?.text = "00:00"
                progressSlider?.value = Float(0.0)
                progressSlider?.setProcessValue(0.0)
                bottomProgressSlider?.setProgress(0.0, animated: true)
            }
        }
    }
    
}












