//
//  ViewController.swift
//  PeroDFU
//
//  Created by Junsung Park on 2020/11/24.
//

import UIKit
import DTGradientButton
import Hero
import CoreBluetooth
import iOSDFULibrary
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var scanBt:UIButton!
    @IBOutlet weak var updateServerBt:UIButton!
    @IBOutlet weak var localBt:UIButton!
    @IBOutlet weak var deviceName:UILabel!
    @IBOutlet weak var videoView:UIImageView!
    @IBOutlet weak var top:NSLayoutConstraint!

    @IBOutlet weak var scanHeight:NSLayoutConstraint!
    @IBOutlet weak var localHeight:NSLayoutConstraint!
    @IBOutlet weak var serverHeight:NSLayoutConstraint!
   
    @IBOutlet weak var connectTop:NSLayoutConstraint!
    @IBOutlet weak var firmwareTop:NSLayoutConstraint!

    
    var selectedPeriperal:CBPeripheral!
    
    var playerLayer: AVPlayerLayer?
    
    var player: AVPlayer?
    
    var isLoop: Bool = true
    
    var firmwareDict:NSDictionary?
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         let colors = [UIColor(hex: "e8963d"), UIColor(hex: "c1315a")]
        scanBt.setGradientBackgroundColors(colors, direction: .toRight, for: .normal)
        scanBt.layer.cornerRadius = 22
        scanBt.layer.masksToBounds = true
     
        updateServerBt.setGradientBackgroundColors(colors, direction: .toRight, for: .normal)
        updateServerBt.layer.cornerRadius = 22
        updateServerBt.layer.masksToBounds = true
  
        localBt.setGradientBackgroundColors(colors, direction: .toRight, for: .normal)
        localBt.layer.cornerRadius = 22
        localBt.layer.masksToBounds = true
        
        
      //  let playerView = VideoPlayerView()
       // let url = URL(fileURLWithPath: <#T##String#>)
        

      //  playerView.play(for: url)
   //     videoView.addSubview(playerView)
        let urlPath = Bundle.main.path(forResource: "demo", ofType:  "mp4")
   
        let url =  URL(fileURLWithPath: urlPath!)
        
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
                  
        playerLayer?.frame = videoView.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        
        videoView.layer.addSublayer(playerLayer!)
        NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)

  
    }
    
    func configureUI()
    {
      
        let height = UIScreen.main.bounds.size.height
        let width = UIScreen.main.bounds.size.width
        
        let mHeight =  width * 9 / 16
         
  
        let offset = ( height - ( (120 + 40 ) * 2 + 40 + 44 + 36 + mHeight  )) / 4
        connectTop.constant = offset
        firmwareTop.constant = offset
        
       
   
    }
    override func viewWillAppear(_ animated: Bool) {
       // let url = URL(string: urlPath!)
           
        if UIScreen.main.bounds.size.height <= 568
        {
            top.constant = 0
            scanHeight.constant = 30
            serverHeight.constant = 30
            localHeight.constant = 30
        }
        playerLayer?.frame = videoView.bounds
   
        
        if player?.timeControlStatus != AVPlayer.TimeControlStatus.playing {
        
            player?.play()
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if player?.timeControlStatus == AVPlayer.TimeControlStatus.playing {
        
            player?.pause()
            
        }
    }
    @objc func reachTheEndOfTheVideo(_ notification: Notification) {
            if isLoop {
                player?.pause()
                player?.seek(to: .zero)
                player?.play()
            }
      
    }
    override func viewDidAppear(_ animated: Bool) {
      //  getFirmwrae()
      //  let delegate = self.view.window!.windowScene!.delegate as? SceneDelegate
      
        //delegate!.main = self
        playerLayer?.frame = videoView.bounds
        configureUI()
   
    }
   
    func getFirmwrae(firmeware:DFUFirmware!)
    {
       

        print(firmeware.fileName)

    }
    func set(device:CBPeripheral)
    {
     
        selectedPeriperal = device
        deviceName.text = device.name
    }

    @IBAction func scan()
    {
        performSegue(withIdentifier: "exec_scan", sender: nil)

    }
    @IBAction func loadLocalFirmware()
    {
        performSegue(withIdentifier: "exec_firmware", sender: 0)

    }
    @IBAction func loadServerFirmware()
    {
        performSegue(withIdentifier: "exec_firmware", sender: 1)

    }
    
    @IBAction func test()
    {
  //      performSegue(withIdentifier: "exec_update", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "exec_update"{
          
            if let detail = segue.destination as? UpdateViewController{
                detail.hero.isEnabled = true
                detail.hero.modalAnimationType = .fade//.push(direction: .left)

   
            }
           
        }
        if segue.identifier == "exec_scan"{
          
            if let detail = segue.destination as? ScanViewController{
                detail.modalPresentationStyle = .overCurrentContext
                detail.hero.isEnabled = true
                detail.hero.modalAnimationType = .fade
                detail.parentCon = self
    
   
            }
           
        }
        if segue.identifier == "exec_firmware"{
          
            let type = sender as! Int
            if let detail = segue.destination as? FirmwareViewController{
                detail.modalPresentationStyle = .overCurrentContext
                detail.hero.isEnabled = true
                detail.hero.modalAnimationType = .fade
                detail.parentCon = self
                detail.type = type
    
   
            }
           
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

