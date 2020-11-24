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
        
        progressView.progress = CGFloat(totalProgress)
        percentLabel.text = String(format: "%d%%", progress)
    
    }
    
    @IBOutlet weak var percentLabel:UILabel!
 
    @IBOutlet weak var updateBt:UIButton!
    @IBOutlet weak var selectedDevice:UILabel!
    @IBOutlet weak var selectedFirmware:UILabel!
    
    @IBOutlet weak var progressView:SFCircleGradientView!
   
    var firmware:DFUFirmware!
    var selectedPeriperal:CBPeripheral!
    
    var parentCon:FirmwareViewController!
 
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
    override func viewDidAppear(_ animated: Bool) {
   }
    @IBAction func close()
    {
  //      parentCon.bClose = true
        
     //   parentCon.dismiss(animated: true, completion: nil)
        //dismiss(animated: true, completion: nil)
        self.hero_unwindToRootViewController()
  
    }
    @IBAction func update()
    {
        let dfuInitiator = DFUServiceInitiator(queue: DispatchQueue(label: "Other"))
        dfuInitiator.delegate = self
        dfuInitiator.progressDelegate = self
        dfuInitiator.logger = self
        dfuInitiator.dataObjectPreparationDelay = 0.4 // sec
        
        
        dfuInitiator.with(firmware: firmware).start(target: selectedPeriperal)
       
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

}
