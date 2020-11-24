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

class ViewController: UIViewController {

    @IBOutlet weak var scanBt:UIButton!
    @IBOutlet weak var updateServerBt:UIButton!
    @IBOutlet weak var localBt:UIButton!
    @IBOutlet weak var deviceName:UILabel!
    
    var selectedPeriperal:CBPeripheral!
    
    
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
        
  
    }
    override func viewDidAppear(_ animated: Bool) {
      //  getFirmwrae()
        let delegate = self.view.window!.windowScene!.delegate as? SceneDelegate
      
        delegate!.main = self
   
    }
    override func viewWillAppear(_ animated: Bool) {
        
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
        performSegue(withIdentifier: "exec_firmware", sender: nil)

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
          
            if let detail = segue.destination as? FirmwareViewController{
                detail.modalPresentationStyle = .overCurrentContext
                detail.hero.isEnabled = true
                detail.hero.modalAnimationType = .fade
                detail.parentCon = self
    
   
            }
           
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

