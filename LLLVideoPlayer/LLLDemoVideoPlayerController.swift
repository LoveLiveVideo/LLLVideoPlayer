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
        let imageView: UIImageView = UIImageView.init()
        imageView.sd_setImage(with: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: LLLDemoVideoPlayerCell? = tableView.dequeueReusableCell(withIdentifier: "TodayTableViewCell") as? LLLDemoVideoPlayerCell
        if(cell == nil){
            cell = LLLDemoVideoPlayerCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "TodayTableViewCell")
        }
        
        let dic1: NSDictionary? = extensionsArray?.object(at: indexPath.row) as? NSDictionary
        let data: NSData? = dic1?.object(forKey: "data") as? NSData
        cell?.imagePhoto?.image = UIImage.init(data: data as! Data)
        cell?.imagePhotoTitle?.text = dic1?.object(forKey: "title") as? String
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let storyboard: UIStoryboard = UIStoryboard.init(name: "MainInterface", bundle: Bundle.main)
            let shareSelect: UIViewController = storyboard.instantiateViewController(withIdentifier: "ShareSelect")
            let shareSelectVC: LLLDemoHorizontalVideoPlayerController = shareSelect as! ShareSelectViewController
            let nav: UINavigationController = self.navigationController!
            nav.pushViewController(shareSelectVC, animated: true)
        }else if indexPath.row == 1 {
            
        }else {
            
        }
    }
}
