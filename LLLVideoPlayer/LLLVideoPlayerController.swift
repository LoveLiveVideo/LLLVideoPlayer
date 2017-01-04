//
//  LLLVideoPlayerController.swift
//  LLLVideoPlayer
//
//  Created by ZK on 2017/1/4.
//  Copyright © 2017年 ZK. All rights reserved.
//

import Foundation

class LLLVideoPlayerController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //sohu的m3u8地址都加密了，防盗链，所以给ijk播放之前还的解密后能用的ts给
    override func viewDidLoad() {
        let xx: IJKFFMoviePlayerController = IJKFFMoviePlayerController.init()
        let imageView: UIImageView = UIImageView.init()
        imageView.sd_setImage(with: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
