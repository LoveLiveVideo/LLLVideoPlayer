//
//  LLLTabbarViewController.swift
//  LLLVideoPlayer
//
//  Created by 许乾隆 on 2016/12/30.
//  Copyright © 2016年 ZK. All rights reserved.
//

import Foundation
import UIKit

class LLLTabbarController: UITabBarController {
    
    //sohu的m3u8地址都加密了，防盗链，所以给ijk播放之前还的解密后能用的ts给
    override func viewDidLoad() {
        let xx: IJKFFMoviePlayerController = IJKFFMoviePlayerController.init()
        let imageView: UIImageView = UIImageView.init()
        imageView.sd_setImage(with: nil)
        
    }
    
}
