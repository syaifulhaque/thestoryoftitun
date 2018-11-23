//
//  DetailViewController.swift
//  StoviTheStoryVideo
//
//  Created by Egi Muhamad Saefulhaqi on 21/11/18.
//  Copyright © 2018 Egi Muhamad Saefulhaqi. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageLoading: UIImageView!
    @IBOutlet weak var descriptionArea: UITextView!
    @IBOutlet weak var functionView: UIView!
    @IBOutlet weak var xButtonOutlet: UIButton!
    var funcState: functionState = .open
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    @IBOutlet weak var playButton :UIButton!
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    let synth = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance(string: "")
    @IBOutlet weak var speechButton: UIButton!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var overlayLoading: UIView!
    
    var story: Story?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationController?.isNavigationBarHidden = false
        var urlVideo = ""
        UIView.animate(withDuration: 5.0, delay: 0.0, options: .curveEaseIn, animations: {
            self.imageLoading.transform = CGAffineTransform(rotationAngle: ((180.0 * CGFloat(Double.pi)) / 180.0))
        }, completion: { (time) in
            self.overlayLoading.alpha = 0
            self.imageLoading.alpha = 0
            if let story = self.story {
                self.descriptionArea.text = story.content
                urlVideo = story.videoUrl
                self.titleLabel.text = story.title
            }
        })
        if let story = self.story {
            urlVideo = story.videoUrl
            self.titleLabel.text = story.title
        }
        let url = URL(string: urlVideo)
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        let playerLayer=AVPlayerLayer(player: player!)
        playerLayer.frame = self.videoView.bounds
        playerLayer.accessibilityElementsHidden = false
        playerLayer.videoGravity = .resizeAspectFill
        print("Story : \(story)")
        self.videoView.layer.addSublayer(playerLayer)
        
       
        //playButton!.addTarget(self, action: Selector("playButtonTapped:"), for: .touchUpInside)
        playButton!.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)
        
        
//        UIView.animate(withDuration:0.5, delay: 0, options: [.repeat],animations: {
//                self.imageLoading.transform = CGAffineTransform(rotationAngle: CGFloat(180))
//        })
        
        
       
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissLoading))
        
        overlayLoading.addGestureRecognizer(tap)
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
    
    @objc func dismissLoading(){
        self.overlayLoading.alpha = 0
        self.imageLoading.alpha = 0
    }
    
    func playVideo(){
        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        let player = AVPlayer(url: videoURL!)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.videoView.bounds
        self.videoView.layer.addSublayer(playerLayer)
        player.play()
    }
    
    @IBAction func backButton(_ sender: Any) {
        
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
            playButton.setBackgroundImage(#imageLiteral(resourceName: "big-pause-button"), for: UIControl.State.normal)
            //playButton!.setTitle("Pause", for: UIControl.State.normal)
        } else {
            player!.pause()
            //playButton!.setImage(UIImage(named: "player_control_play_50px.png"), forState: UIControlState.Normal)
            playButton.setBackgroundImage(#imageLiteral(resourceName: "youtube"), for: UIControl.State.normal)
            //playButton!.setTitle("Play", for: UIControl.State.normal)
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
    override func viewDidDisappear(_ animated: Bool) {
        if synth.isSpeaking {
            synth.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
    }
    
    @IBAction func speechStart(_ sender: Any) {
        if synth.isSpeaking {
            synth.pauseSpeaking(at: AVSpeechBoundary.immediate)
        }else if synth.isPaused {
            print("Continue")
            synth.continueSpeaking()
        }else if !synth.isSpeaking{
            utterance = AVSpeechUtterance(string: descriptionArea.text)
            utterance.voice = AVSpeechSynthesisVoice(language: "id-ID")
            utterance.rate = 0.5
            synth.speak(utterance)
        }else {
            print("No One")
        }
        
    }
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.speechButton.isEnabled = true
                case .denied:
                    self.speechButton.isEnabled = false
                //self.descriptionArea.text = "User denied access to speech recognition"
                case .restricted:
                    self.speechButton.isEnabled = false
                //self.descriptionArea.text = "Speech recognition restricted on this device"
                case .notDetermined:
                    self.speechButton.isEnabled = false
                    //self.descriptionArea.text = "Speech recognition not yet authorized"
                }
            }
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
