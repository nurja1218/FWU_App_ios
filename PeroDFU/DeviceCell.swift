//
//  DeviceCell.swift
//  PeroDFU
//
//  Created by Junsung Park on 2020/11/24.
//

import UIKit
import CoreBluetooth

class DeviceCell: UICollectionViewCell {
    var peripheral: CBPeripheral!
    var name: String?
    
    @IBOutlet weak var nameLabel:UILabel!
    
    
    func assign(peripheral: CBPeripheral, withName name: String?) {
        self.peripheral = peripheral
        self.name = name
        
        nameLabel!.text = name
    }
}
