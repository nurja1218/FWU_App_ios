//
//  FirmwareViewController.swift
//  PeroDFU
//
//  Created by Junsung Park on 2020/11/24.
//

import UIKit
import iOSDFULibrary

class FirmwareViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var container:UIView!
    
    @IBOutlet weak var collectionView:UICollectionView!

    var firmwares:[URL] = []

    var parentCon:ViewController!
    override func viewDidLoad() {
        super.viewDidLoad()

        container.layer.cornerRadius = 15
        let layout = UICollectionViewFlowLayout()
            

       layout.scrollDirection = .vertical
       
    //   layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
       
       let width = UIScreen.main.bounds.size.width
       
       layout.itemSize = CGSize(width: width - 40 ,height: 30)
       self.collectionView.setCollectionViewLayout(layout, animated: true)
               
        getInbox()
     
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }


    func getInbox()
    {
        let filemgr = FileManager.default

         // Document Directory
        var dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)

         // Documents Location
         let docsDir = dirPaths[0] //as! String
         print("Documents Folder: \(docsDir)")

         print("------------------------")

         // Create a new folder in the directory named "Recipes"
         print("Creating new folder...")
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let newPath = documentsPath.appendingPathComponent("Inbox")
        
        if !filemgr.fileExists(atPath: (newPath?.path)!) {
            
             do {
                try FileManager.default.createDirectory(atPath: newPath!.path, withIntermediateDirectories: true, attributes: nil)
             } catch let error as NSError {
                 NSLog("Unable to create directory \(error.debugDescription)")
             }
        }
        else
        {
           
            do {
                firmwares = try FileManager.default.contentsOfDirectory(at: newPath!, includingPropertiesForKeys: nil, options: [])
                
                collectionView.reloadData()
                 
            } catch let error as NSError {
                NSLog("Unable get urls \(error.debugDescription)")
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return firmwares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeviceCell", for: indexPath)
         as! DeviceCell

    
        let url = firmwares[indexPath.row]
        cell.nameLabel.text = url.lastPathComponent
        
      
        //let name = array[indexPath.row] as! String
        
   
        //cell.name.text = name
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
       // centralManager.stopScan()
        let url = firmwares[indexPath.row]
    
        let firmeware = DFUFirmware(urlToZipFile:  url)
     
   
        performSegue(withIdentifier: "exec_update", sender: firmeware)
     //   dismiss(animated: true, completion: nil)
      

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "exec_update"{
          
            let firmware = sender as! DFUFirmware
            if let detail = segue.destination as? UpdateViewController{
                detail.hero.isEnabled = true
                detail.hero.modalAnimationType = .fade//.push(direction: .left)
                detail.firmware = firmware
                detail.selectedPeriperal = parentCon.selectedPeriperal

   
            }
           
        }
    }
}
