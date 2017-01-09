//
//  LLLVideoPlayerController.swift
//  LLLVideoPlayer
//
//  Created by ZK on 2017/1/4.
//  Copyright © 2017年 ZK. All rights reserved.
//

import Foundation

class LLLDemoVideoPlayerController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //sohu的m3u8地址都加密了，防盗链，所以给ijk播放之前还的解密后能用的ts给
    override func viewDidLoad() {
        let xx: IJKFFMoviePlayerController = IJKFFMoviePlayerController.init()
        
        self.title = "点播"
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "LLLDemoVideoPlayerCell")
        if(cell == nil){
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "LLLDemoVideoPlayerCell")
        }
        if indexPath.row == 0 {
            cell?.textLabel?.text = "横屏播放器"
            cell?.detailTextLabel?.text = "最常见播放器类型，适用于大多app"
        }else if indexPath.row == 1 {
            cell?.textLabel?.text = "竖屏播放器"
            cell?.detailTextLabel?.text = "适用于手机拍摄播放"
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let horizontalVideoPlayerController : LLLDemoHorizontalVideoPlayerController = LLLDemoHorizontalVideoPlayerController.init()
            self.navigationController?.pushViewController(horizontalVideoPlayerController, animated: true)
            
        }else if indexPath.row == 1 {
            let horizontalVideoPlayerController : LLLDemoVerticalVideoPlayerController = LLLDemoVerticalVideoPlayerController.init()
            self.navigationController?.pushViewController(horizontalVideoPlayerController, animated: true)
            
        }else {
            
        }
    }
}
