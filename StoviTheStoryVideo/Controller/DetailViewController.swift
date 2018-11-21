//
//  DetailViewController.swift
//  StoviTheStoryVideo
//
//  Created by Egi Muhamad Saefulhaqi on 21/11/18.
//  Copyright © 2018 Egi Muhamad Saefulhaqi. All rights reserved.
//

import UIKit
import AVFoundation

class DetailViewController: UIViewController {
    
    @IBOutlet weak var functionView: UIView!
    @IBOutlet weak var xButtonOutlet: UIButton!
    var funcState: functionState = .open
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    @IBOutlet weak var playButton :UIButton!
    
    @IBOutlet weak var videoView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        let playerLayer=AVPlayerLayer(player: player!)
        playerLayer.frame = self.videoView.bounds
        playerLayer.accessibilityElementsHidden = false
        playerLayer.videoGravity = .resizeAspectFill
        
        self.videoView.layer.addSublayer(playerLayer)
        
       
        //playButton!.addTarget(self, action: Selector("playButtonTapped:"), for: .touchUpInside)
        playButton!.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)
        
       
        
        
        // Add playback slider
        
        let playbackSlider = UISlider(frame:CGRect(x:10, y:300, width:300, height:20))
        playbackSlider.minimumValue = 0
        
        
        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        
        playbackSlider.maximumValue = Float(seconds)
        playbackSlider.isContinuous = true
        playbackSlider.tintColor = UIColor.green
        
        playbackSlider.addTarget(self, action: #selector(playbackSliderValueChanged(_:)), for: .valueChanged)
        // playbackSlider.addTarget(self, action: "playbackSliderValueChanged:", forControlEvents: .ValueChanged)
        self.videoView.addSubview(playbackSlider)
        // Do any additional setup after loading the view.
    }
    
    func playVideo(){
        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        let player = AVPlayer(url: videoURL!)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.videoView.bounds
        self.videoView.layer.addSublayer(playerLayer)
        player.play()
    }
    
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        player!.seek(to: targetTime)
        
        if player!.rate == 0
        {
            player?.play()
        }
    }
    
    
    @objc func playButtonTapped(_ sender:UIButton)
    {
        if player?.rate == 0
        {
            player!.play()
            //playButton!.setImage(UIImage(named: "player_control_pause_50px.png"), forState: UIControlState.Normal)
            playButton!.setTitle("Pause", for: UIControl.State.normal)
        } else {
            player!.pause()
            //playButton!.setImage(UIImage(named: "player_control_play_50px.png"), forState: UIControlState.Normal)
            playButton!.setTitle("Play", for: UIControl.State.normal)
        }
    }
    
    @IBAction func xButtonAction(_ sender: Any) {
        switch funcState {
        case .close:
                UIView.animate(withDuration: 0.5) {
                    self.functionView.frame.origin.x = 0
                }
            funcState = .open
            
        case .open:
        
            UIView.animate(withDuration: 0.5) {
                self.functionView.frame.origin.x = self.view.frame.width - 35
            }
            funcState = .close
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

enum functionState {
    case open, close
}
