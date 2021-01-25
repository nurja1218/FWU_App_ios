//
//  FirmwareViewController.swift
//  PeroDFU
//
//  Created by Junsung Park on 2020/11/24.
//

import UIKit
import iOSDFULibrary
import Alamofire
import SwiftyJSON

class FirmwareViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var container:UIView!
    
    @IBOutlet weak var collectionView:UICollectionView!

    var firmwares:[URL] = []

    var parentCon:ViewController!
    
    var bTouchEnable:Bool = false
    var bClose:Bool = false
    
    var type :Int = 0
    var selectedFirmware:String = ""
    var selectedDevice:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        container.layer.cornerRadius = 15
        let layout = UICollectionViewFlowLayout()
            

       layout.scrollDirection = .vertical
       
    //   layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
       
       let width = UIScreen.main.bounds.size.width
       
       layout.itemSize = CGSize(width: width - 40 ,height: 30)
       self.collectionView.setCollectionViewLayout(layout, animated: true)
             
        if(type == 0)
        {
            getInbox()

        }
        else
        {
            downloadList()

        }
     
    }
    func downloadList()
    {
     //   let url = "http://www.junsoft.org/firmware/firmwares.json"
        let url = "https://palmcat.co.kr/sw/update.json"

        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]

       
        AF.request(url, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: headers)
        .responseJSON {  [self] response in
            
            switch response.result {

            case .success(let value):
                let json = JSON(value)
                /*
                let items =  json["item"].arrayValue
                for item in items{
                   let name =  item["name"].stringValue
                    print(name)
                    let path = "http://www.junsoft.org/firmware/" + name
                    let pathUrl = URL(string: path)
                    self.firmwares.append(pathUrl!)
                    
                  
                }
                 */
                let dict =  json["peroFU"].dictionaryValue
                let items = dict["firmware"]!.arrayValue
                for item in items{
                   let name =  item["path"].stringValue
                    print(name)
                    let path = "https://palmcat.co.kr/sw/pero-fu/" + name
                    let pathUrl = URL(string: path)
                    self.firmwares.append(pathUrl!)
                    
                  
                }
       
                collectionView.reloadData()
         
               // completion(true, json)
                

            case .failure(let error):
            
                print("error : \(error)")
                //completion(false, JSON())
                
                break;
                
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        bTouchEnable = true
        let layout = UICollectionViewFlowLayout()
    
        layout.scrollDirection = .vertical
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let width = UIScreen.main.bounds.size.width
        
        layout.itemSize = CGSize(width: width - 40 ,height: 35)

     
    }
    override func viewDidLayoutSubviews() {
        if(bClose == true)
        {
            bClose = false
            self.hero_unwindToRootViewController()
            
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        bTouchEnable = false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(bTouchEnable == true)
        {
            dismiss(animated: true, completion: nil)
     
        }
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
    
        if(type == 0)
        {
            let firmeware = DFUFirmware(urlToZipFile:  url)
         
       
            performSegue(withIdentifier: "exec_update", sender: firmeware)
        }
        else
        {
           // let firmeware = DFUFirmware(urlToZipFile:  url)
         
            let name =  url.lastPathComponent
            let urlStr = "https://palmcat.co.kr/sw/pero-fu/" + name
           
            downloadFirmware(filename: name, url: URL(string: urlStr)!)
       
            //performSegue(withIdentifier: "exec_update", sender: firmeware)
        }
 
     //   dismiss(animated: true, completion: nil)
      

    }
    func documentsDirectoryURL() -> NSURL {
          let manager = FileManager.default
          let URLs = manager.urls(for: .documentDirectory, in: .userDomainMask)
          return URLs[0] as NSURL
      }
    func dataFileURL(fileName:String) -> NSURL {
          
          let path = String(format: "%@", fileName)
          let targetPath = documentsDirectoryURL()
          
          let manager = FileManager.default
        
          
          if(manager.fileExists(atPath: targetPath.path!))
          {
              print("exist")
          }
          else
          {
              do{
                  try   manager.createDirectory(at: targetPath as URL, withIntermediateDirectories: false, attributes: nil)
                  
              } catch {
                  print("Error: \(error.localizedDescription)")
              }
          }
          
          
          
          return documentsDirectoryURL().appendingPathComponent(path)! as NSURL
          
      }
    func downloadFirmware(filename:String, url:URL)
    {
        let manager = FileManager.default
               
        let path = String(format: "%@", filename)
        let pathUrl = dataFileURL(fileName: filename)

        let destination: DownloadRequest.Destination = { _, _ in
                          
                              var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                              documentsURL.appendPathComponent(path)
                              return (documentsURL, [.removePreviousFile])
               }
        
        AF.download(url,to:destination).responseData { (_data) in
            if(_data.error == nil)
            {
                let data = manager.contents(atPath: pathUrl.path!)
                             
                let firmeware = DFUFirmware(zipFile:data!)
              
            
                self.selectedFirmware = filename
                self.performSegue(withIdentifier: "exec_update", sender: firmeware)
      
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "exec_update"{
          
            var firmware:DFUFirmware!
         
            if let detail = segue.destination as? UpdateViewController{
                if(sender != nil)
                {
                    firmware   = sender as! DFUFirmware
              
                }
                detail.hero.isEnabled = true
                detail.hero.modalAnimationType = .fade//.push(direction: .left)
               
                detail.type = type
                if( type == 0)
                {
          
                    if(firmware != nil)
                    {
                        detail.firmware = firmware
                  
                    }
                    detail.selectedPeriperal = parentCon.selectedPeriperal
                
                }
                else
                {
                    if(firmware != nil)
                    {
                        detail.firmware = firmware
                  
                    }
                
                    if(parentCon.selectedPeriperal != nil)
                    {
                        detail.selectedPeriperal = parentCon.selectedPeriperal
             
                        detail.deviceName = parentCon.selectedPeriperal.name!
           
                 
                    }
                 
                     detail.firwareName = selectedFirmware
                   // detail.selectedDevice.text  = parentCon.selectedPeriperal.name
                   // detail.selectedFirmware.text = self.selectedFirmware
                    
                }
                 detail.parentCon = parentCon

               
            }
           
        }
    }
}


extension FirmwareViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
       
 // 높이 구하기
        let width = UIScreen.main.bounds.size.width
        
       
          
   
        return  CGSize(width: width - 40 ,height: 35)
        
    }
}
