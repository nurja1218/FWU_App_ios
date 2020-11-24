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

class UpdateViewController: UIViewController {

    @IBOutlet weak var updateBt:UIButton!
    @IBOutlet weak var selectedDevice:UILabel!
    @IBOutlet weak var selectedFirmware:UILabel!
   
    var firmware:DFUFirmware!
    var selectedPeriperal:CBPeripheral!
 
    override func viewDidLoad() {
        super.viewDidLoad()

       
        let colors = [UIColor(hex: "e8963d"), UIColor(hex: "c1315a")]
        updateBt.setGradientBackgroundColors(colors, direction: .toRight, for: .normal)
        updateBt.layer.cornerRadius = 22
        updateBt.layer.masksToBounds = true
        
        selectedDevice.text = selectedPeriperal.name
        selectedFirmware.text = firmware.fileName
    
    }
    @IBAction func close()
    {
        dismiss(animated: true, completion: nil)
    }
    

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

}
