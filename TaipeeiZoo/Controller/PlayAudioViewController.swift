//
//  PlayAudioViewController.swift
//  TaipeiZoo
//
//  Created by eva on 2018/6/6.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController  {
    
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    var playButton:UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       // let url = URL(string: "https://s3.amazonaws.com/kargopolov/kukushka.mp3")
        let url = URL(string: "http://mediasys.taipei.gov.tw/tcg/service/KMStorage/355/ADB04074-6156-5C7C-1630-B4E88BAD5147/Panda_Voice03.mp3")
        
        
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        
        let playerLayer=AVPlayerLayer(player: player!)
        playerLayer.frame=CGRect(x:0, y:0, width:10, height:50)
        self.view.layer.addSublayer(playerLayer)
        
        playButton = UIButton(type: UIButtonType.system) as UIButton
        let xPostion:CGFloat = 50
        let yPostion:CGFloat = 100
        let buttonWidth:CGFloat = 150
        let buttonHeight:CGFloat = 45
        
        playButton!.frame = CGRect(x: xPostion, y: yPostion, width: buttonWidth, height: buttonHeight)
        playButton!.backgroundColor = UIColor.lightGray
        playButton!.setTitle("Play", for: UIControlState.normal)
        playButton!.tintColor = UIColor.black
        playButton!.addTarget(self, action: #selector(ViewController.playButtonTapped(_:)), for: .touchUpInside)
        
        self.view.addSubview(playButton!)
    }
    
    func playButtonTapped(_ sender:UIButton)
    {
        if player?.rate == 0
        {
            player!.play()
            //playButton!.setImage(UIImage(named: "player_control_pause_50px.png"), forState: UIControlState.Normal)
            playButton!.setTitle("Pause", for: UIControlState.normal)
        } else {
            player!.pause()
            //playButton!.setImage(UIImage(named: "player_control_play_50px.png"), forState: UIControlState.Normal)
            playButton!.setTitle("Play", for: UIControlState.normal)
        }
    }
    
}
