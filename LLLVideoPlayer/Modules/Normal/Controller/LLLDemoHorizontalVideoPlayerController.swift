//
//  LLLHorizontalVideoPlayerController.swift
//  LLLVideoPlayer
//
//  Created by ZK on 2017/1/4.
//  Copyright © 2017年 ZK. All rights reserved.
//

import Foundation

class LLLDemoHorizontalVideoPlayerController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        let url: URL = URL.init(string: "http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/gear1/prog_index.m3u8")!
        let player: HorizontalVideoPlayer = HorizontalVideoPlayer.init(contentURL: url)
        
        self.view.addSubview(player)
        
        player.mas_makeConstraints { (make) in
            make?.top.equalTo()
            make?.edges.equalTo(player)
            make?.top.left().right().equalTo(self.view)
            make?.height.mas_equalTo(200)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
