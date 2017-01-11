//
//  LLLHorizontalVideoPlayerController.swift
//  LLLVideoPlayer
//
//  Created by ZK on 2017/1/4.
//  Copyright © 2017年 ZK. All rights reserved.
//

import Foundation
import SnapKit

class LLLDemoHorizontalVideoPlayerController: UIViewController, HorizontalVideoPlayerProtocol {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        
        let path: String = (documentDirectory?.appending("/212_sd_optimizing_your_app_for_multitasking_on_ipad_in_ios_9.mp4"))!
//        let url: URL = URL.init(string: "http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/gear1/prog_index.m3u8")!
        let url: URL = URL.init(fileURLWithPath: path)
        let player: HorizontalVideoPlayer = HorizontalVideoPlayer.init(contentURL: url)
        player.horizontalVideoPlayerDelegate = self
        view.addSubview(player)
        
        player.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(player.snp.width).multipliedBy(9.0/16.0)
        }
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: false)
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        navigationController?.setNavigationBarHidden(false, animated: false)
//        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: false)
//    }
    
    func goBack() {
        _ = navigationController?.popViewController(animated: true)
    }
}
