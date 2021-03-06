//
//  ScanViewController.swift
//  PeroDFU
//
//  Created by Junsung Park on 2020/11/24.
//

import UIKit
import CoreBluetooth

class ScanViewController: UIViewController, CBCentralManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
  
    
    var centralManager              : CBCentralManager!
    var discoveredPeripherals       : [(peripheral: CBPeripheral, name: String?)] = []
    var scanningStarted             : Bool = false

    @IBOutlet weak var container:UIView!
    @IBOutlet weak var collectionView:UICollectionView!
    
    var parentCon:ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
          
        
        discoveredPeripherals = []
        centralManager = CBCentralManager(delegate: self, queue: nil) // The delegate must be set in init in order to
        
        
     
        
        container.layer.cornerRadius = 15
        
        collectionView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let layout = UICollectionViewFlowLayout()
            

       layout.scrollDirection = .vertical
       
       layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
       let width = UIScreen.main.bounds.size.width
       
       layout.itemSize = CGSize(width: width - 40 ,height: 35)
       self.collectionView.setCollectionViewLayout(layout, animated: false)
     
        centralManager.delegate = self
        if centralManager.state == .poweredOn {
            startDiscovery()
        }
    }
    
    func startDiscovery() {
        if !scanningStarted {
            scanningStarted = true
            print("Start discovery")
            // By default the scanner shows only devices advertising with one of those Service UUIDs:
            centralManager!.delegate = self
            centralManager!.scanForPeripherals(
                withServices: nil,
                options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        }
    }
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Central Manager is now powered on")
            startDiscovery()
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let name = advertisementData[CBAdvertisementDataLocalNameKey] as! String?
        
        // Ignore dupliactes.
        // They will not be reported in a single scan, as we scan without CBCentralManagerScanOptionAllowDuplicatesKey flag,
        // but after returning from DFU view another scan will be started.
        guard discoveredPeripherals.contains(where: { element in element.peripheral == peripheral }) == false else {
            return
        }
        
        UIView.animate(withDuration: 0.5) {
         //   self.emptyView.alpha = 0
        }
        
        discoveredPeripherals.append((peripheral, name))
        collectionView.reloadData()
        //discoveredPeripheralsTableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        centralManager.stopScan()
        discoveredPeripherals.removeAll()
   
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return discoveredPeripherals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeviceCell", for: indexPath)
         as! DeviceCell

        let selectedPeripheral = discoveredPeripherals[indexPath.row]
   
        if(selectedPeripheral.name != nil)
        {
            cell.assign(peripheral: selectedPeripheral.peripheral, withName: selectedPeripheral.name)
       
        }
        else
        {
            cell.assign(peripheral: selectedPeripheral.peripheral, withName: "n/a")
       
        }
   
      
        //let name = array[indexPath.row] as! String
        
   
        //cell.name.text = name
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
       // centralManager.stopScan()
        scanningStarted = false
        let selectedPeripheral = discoveredPeripherals[indexPath.row]
   
        parentCon.set(device: selectedPeripheral.peripheral)
        
        dismiss(animated: true, completion: nil)
      

    }

}
extension ScanViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
       
 // 높이 구하기
        let width = UIScreen.main.bounds.size.width
        
       
          
   
        return  CGSize(width: width - 40 ,height: 35)
        
    }
}
