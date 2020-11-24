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
            statusLabel.text = "updating"
            updateBt.setTitle("       updating...", for: .normal)
        
        }
        else
        {
            bCompleted = true
            let colors = [UIColor(hex: "fad336"), UIColor(hex: "ed1c24")]
            updateBt.setGradientBackgroundColors(colors, direction: .toRight, for: .normal)
            updateBt.layer.cornerRadius = 22
            updateBt.layer.masksToBounds = true
            
            backBt.isHidden = false
            updateBt.isEnabled = true
        
            statusLabel.text = "completed"
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
  
    
    
    var firmware:DFUFirmware!
    var selectedPeriperal:CBPeripheral!
    
    var parentCon:ViewController!
    var bCompleted:Bool = false
    
    var bToggle:Bool = false
 
    override func viewDidLoad() {
        super.viewDidLoad()

       
        let colors = [UIColor(hex: "fad336"), UIColor(hex: "ed1c24")]
        updateBt.setGradientBackgroundColors(colors, direction: .toRight, for: .normal)
        updateBt.layer.cornerRadius = 22
        updateBt.layer.masksToBounds = true
        if(selectedPeriperal != nil)
        {
            selectedDevice.text = selectedPeriperal.name
        }
    
        selectedFirmware.text = firmware.fileName
        //fad336 start
        // ed1c24 end
    
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if UIScreen.main.bounds.size.height <= 568
        {
            top.constant = 0
        }
    }
    override func viewDidAppear(_ animated: Bool) {
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
        
            DispatchQueue.main.async {
                                                
                let colors = [UIColor(hex: "b3b3b3"), UIColor(hex: "b3b3b3")]
                self.updateBt.setGradientBackgroundColors(colors, direction: .toRight, for: .normal)
                self.updateBt.layer.cornerRadius = 22
                self.updateBt.layer.masksToBounds = true
                self.updateBt.setTitle("       updating...", for: .normal)
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
