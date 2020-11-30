//
//  UpdateViewController.swift
//  PeroDFU
//
//  Created by Junsung Park on 2020/11/24.
//

import UIKit
import DTGradientButton
import iOSDFULibrary
import CoreBluetooth
import SFProgressCircle

class UpdateViewController: UIViewController, DFUServiceDelegate, DFUProgressDelegate,LoggerDelegate{
    func logWith(_ level: LogLevel, message: String) {
       // print("\(level.name()): \(message)")

    }
    
    func dfuStateDidChange(to state: DFUState) {
       
    }
    
    func dfuError(_ error: DFUError, didOccurWithMessage message: String) {
        
    }
    
    func dfuProgressDidChange(for part: Int, outOf totalParts: Int, to progress: Int, currentSpeedBytesPerSecond: Double, avgSpeedBytesPerSecond: Double) {
        
        let totalProgress =  (Float(progress) / 100.0)
        print(totalProgress)
        if(totalProgress < 1)
        {
            let colors = [UIColor(hex: "b3b3b3"), UIColor(hex: "b3b3b3")]
            updateBt.setGradientBackgroundColors(colors, direction: .toRight, for: .normal)
            updateBt.layer.cornerRadius = cornerRadius
            updateBt.layer.masksToBounds = true
            statusLabel.text = "Updating"
            updateBt.setTitle("       Updating...", for: .normal)
        
        }
        else
        {
            bCompleted = true
            let colors = [UIColor(hex: "fad336"), UIColor(hex: "ed1c24")]
            updateBt.setGradientBackgroundColors(colors, direction: .toRight, for: .normal)
            updateBt.layer.cornerRadius = cornerRadius
            updateBt.layer.masksToBounds = true
            
            backBt.isHidden = false
            updateBt.isEnabled = true
        
            statusLabel.text = "Completed"
            updateBt.setTitle("       Done", for: .normal)
   
        
        }
        progressView.progress = CGFloat(totalProgress)
        percentLabel.text = String(format: "%d%%", progress)
    
    }
    @IBOutlet weak var backBt:UIButton!
 
    @IBOutlet weak var statusLabel:UILabel!
 
    @IBOutlet weak var percentLabel:UILabel!
 
    @IBOutlet weak var updateBt:UIButton!
    @IBOutlet weak var selectedDevice:UILabel!
    @IBOutlet weak var selectedFirmware:UILabel!
    
    @IBOutlet weak var progressView:SFCircleGradientView!
    @IBOutlet weak var top:NSLayoutConstraint!
  
    @IBOutlet weak var outer0:NSLayoutConstraint!
    @IBOutlet weak var outer1:NSLayoutConstraint!
    @IBOutlet weak var inner0:NSLayoutConstraint!
    @IBOutlet weak var inner1:NSLayoutConstraint!
 
    var firwareName:String = ""
    var deviceName:String = ""
 
    var firmware:DFUFirmware!
    var selectedPeriperal:CBPeripheral!
    
    var parentCon:ViewController!
    var bCompleted:Bool = false
    
    var bToggle:Bool = false
    var type:Int = 0
    
    var cornerRadius:CGFloat = 22
 
    override func viewDidLoad() {
        super.viewDidLoad()

       
        let colors = [UIColor(hex: "fad336"), UIColor(hex: "ed1c24")]
        updateBt.setGradientBackgroundColors(colors, direction: .toRight, for: .normal)
        updateBt.layer.cornerRadius = cornerRadius
        updateBt.layer.masksToBounds = true
        if(type == 0)
        {
            if(selectedPeriperal != nil)
            {
                selectedDevice.text = selectedPeriperal.name
            }
        
            selectedFirmware.text = firmware.fileName
        }
        else
        {
            selectedFirmware.text = firwareName
            selectedDevice.text = deviceName

        }
        
     
        //fad336 start
        // ed1c24 end
    
    }
    override func viewWillAppear(_ animated: Bool) {
        
    
    }
    override func viewDidAppear(_ animated: Bool) {
        
        let height = UIScreen.main.bounds.size.height
        // height  375 x 812 -> iPhone XS
        // height  414 x 896 -> iPhone XR, iPhone XS Max
        // height  414 x 896 -> iPhone XR
        // height  414 x 736 -> iPhone 6/7/8 plus
        // height  320 x 568 -> iPhone SE/5
   
        // 896 -> XR
        
       
        outer0.constant = 48
        outer1.constant = 48

        inner0.constant = 46
        inner1.constant = 46

       
        let fontSize = progressView.frame.size.height / 4
        
        percentLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: fontSize)
        
        if height <= 568
        {
            top.constant = 20
            updateBt.layer.cornerRadius = cornerRadius
        }
        if(height == 568)
        {
            progressView.lineWidth = 18//  x 568
      
        }
        if(height == 667)
        {
            progressView.lineWidth = 23//  x 667
       
        }
        if(height == 736)
        {
            progressView.lineWidth = 26 //  x 736
       
        }
 
        if(height == 812)
        {
            progressView.lineWidth = 24 //  x 812
      
        }
        if(height == 844)
        {
            progressView.lineWidth = 24//  x 844
      
        }
 
        if(height == 896)
        {
            progressView.lineWidth = 27 //  x 896
     
        }
        
        if(height == 926)
        {
            progressView.lineWidth = 28// x 926
       
        }
       
        if(height == 1366)
        {
            progressView.lineWidth = 81//  x 1366 iPad Pro 12.9
      
        }
        if(height == 1180)
        {
            progressView.lineWidth = 64 //  x 1194 iPad Pro 11

        }
        if(height == 1194)
        {
            progressView.lineWidth = 65//  x 1194 iPad Pro 11

        }
        if(height == 1122)
        {
            progressView.lineWidth = 65//  x 1122 iPad Pro 10.5
       
        }
        if(height == 1080)
        {
            progressView.lineWidth = 63 //  x 1080 iPad 8
     
        }
        if(height == 1024)
        {
            progressView.lineWidth = 59 //  x 1024 iPad Pro 9.7
      
        }
     
       
   
     
   
   
    
        print(height)
   }
    @IBAction func close()
    {
  //      parentCon.bClose = true
        
     //   parentCon.dismiss(animated: true, completion: nil)
        //dismiss(animated: true, completion: nil)
        parentCon.deviceName.text = ""
        self.hero_unwindToRootViewController()
  
    }
    @IBAction func update()
    {
        if(selectedDevice.text?.count == 0)
        {
            let alert0 = UIAlertController(title: "Warning",
                                           message: "No device has been selected.",
                                           preferredStyle: UIAlertController.Style.alert)
             


            let okAction0 = UIAlertAction(title: "OK", style: .default, handler: { [weak self] (action) -> Void in
                self!.bCompleted = false
                self!.parentCon.deviceName.text = ""
                  
                self!.hero_unwindToRootViewController()
      
            })
             
           
             

            alert0.addAction(okAction0)
             
             

            self.present(alert0, animated: true, completion: nil)
            
            return
        }
        
        if(bCompleted == false && bToggle == false)
        {
            backBt.isHidden = true
            bToggle = true
         //   updateBt.isEnabled = false
        
            //
        
            DispatchQueue.main.async { [self] in
                                                
                let colors = [UIColor(hex: "b3b3b3"), UIColor(hex: "b3b3b3")]
                self.updateBt.setGradientBackgroundColors(colors, direction: .toRight, for: .normal)
                self.updateBt.layer.cornerRadius = cornerRadius
                self.updateBt.layer.masksToBounds = true
                self.updateBt.setTitle("       Updating...", for: .normal)
               // self.updateBt.isEnabled = false

      
                                             
            }
            
            
            let dfuInitiator = DFUServiceInitiator(queue: DispatchQueue(label: "Other"))
            dfuInitiator.delegate = self
            dfuInitiator.progressDelegate = self
            dfuInitiator.logger = self
            dfuInitiator.dataObjectPreparationDelay = 0.4 // sec
            
            
            dfuInitiator.with(firmware: firmware).start(target: selectedPeriperal)
        }
        else if( bCompleted == true)
        {
            bCompleted = false
            parentCon.deviceName.text = ""
              
            self.hero_unwindToRootViewController()
     
        }
 
       
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

}
