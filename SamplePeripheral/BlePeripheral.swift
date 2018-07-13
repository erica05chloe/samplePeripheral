//
//  BlePeripheral.swift
//  SamplePeripheral
//
//  Created by Erica Awada on 2018/05/28.
//  Copyright © 2018年 Erica Awada. All rights reserved.
//

import UIKit
import CoreBluetooth
//import UserNotifications

protocol BlePeripheralDelegate {
  //  func peripheralManagerAdvertising()
    func peripheralManagerWriteRequest()
   // func readData(data: Data)
}


class BlePeripheral: NSObject, CBPeripheralManagerDelegate {
    
    var _delegate: BlePeripheralDelegate!
    
    var _serviceUUID: CBUUID!
    var _characteristicUUID: CBUUID!
    var _indiCharaUUID: CBUUID!
    
    var _peripheralManager: CBPeripheralManager!
    var _service: CBMutableService!
    var _characteristicForWrite: CBMutableCharacteristic!
    var _characteristicForIndicate: CBMutableCharacteristic!
    var _characteristicForRead: CBMutableCharacteristic!
    
    let kServiceUUID = "2a04cfbc-62df-11e8-adc0-fa7ae01bbebc"
    let kCharacteristicUUID = "2a04cfbc-62df-11e8-adc0-fa7ae01bbebc"
    let kIndiCharaUUID = "2a04cfbc-62df-11e8-adc0-fa7ae01bbebd"
    let localName = "SamplePer"
    
    static var sharedInstance = BlePeripheral()
    
    
    //初期化
    func setup(){
        _peripheralManager = CBPeripheralManager(delegate: self, queue: DispatchQueue.global(), options: nil)
        _serviceUUID = CBUUID(string: kServiceUUID)
        _characteristicUUID = CBUUID(string: kCharacteristicUUID)
        _indiCharaUUID = CBUUID(string: kIndiCharaUUID)

    }
    
    
    //peripheralの状態が変化した時の処理
    func peripheralManagerDidUpdateState(_ peripheral:CBPeripheralManager) {
        print("state: \(peripheral.state)")
        
        switch peripheral.state {
            
            //起動したらserviceを追加する
        case CBManagerState.poweredOn:
                addService()
            break
            
        default:
            break
        }
    }
    
    
    //service追加が完了するとよばれる
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        
        if error != nil {
            print("add service faild.. \(error!)")
            return
        }

        print("サービス追加完了")
    }
    
    
    //advertise開始
    func startAdvertise() {
        
        //advertisementDataを作成
        let advertisementData: Dictionary = [CBAdvertisementDataLocalNameKey: localName, CBAdvertisementDataServiceUUIDsKey: [_serviceUUID]] as [String: Any]
        
        _peripheralManager.startAdvertising(advertisementData)
        print("try start adv")
    }
    
    
    //advertise開始処理
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if error != nil {
            print("failed to advertise")
            
            //FIXME:-
           // self._delegate?.peripheralManagerAdvertising()
        }
        print("success to advertise")
    }
    
    
    //service, characteristicの作成
    func addService(){
        
        _characteristicForIndicate = CBMutableCharacteristic.init(type: _indiCharaUUID, properties: .indicate, value: nil, permissions: .readable)
        _characteristicForWrite = CBMutableCharacteristic.init(type: _characteristicUUID, properties: .write, value: nil, permissions: .writeable)
       
        //characteristicをserviceにセット
        let service = CBMutableService(type: _serviceUUID, primary: true)
        service.characteristics = [_characteristicForIndicate, _characteristicForWrite]
        
        
        _peripheralManager.add(service)
        print("\(service)")
    }
    
    
    //writeRequest
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        
        for request in requests {
            
                print("\(request)")
                
                if request.characteristic.uuid.isEqual(_characteristicUUID){
                    
                    //CBCharacteristicのvalueに CBTTRequestのvalueをセット
                    _characteristicForWrite.value = request.value
                }
        }
        
            //リクエストに応答
            _peripheralManager.respond(to: requests[0], withResult: CBATTError.success)
            print("success to write")
        
        
       //attendanceviewで実行
        self._delegate?.peripheralManagerWriteRequest()
        
        
        //プッシュ通知
//        let content = UNMutableNotificationContent()
//        content.title = "Success"
//        content.subtitle = "送信完了"
//        content.sound = UNNotificationSound.default()
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//
//        let request = UNNotificationRequest(identifier: "identifier", content: content, trigger: trigger)
//
//        let center = UNUserNotificationCenter.current()
//        center.add(request)
//        print("push")
        

        }
    
    
        //indicateRequest受信
        func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
            print("indicate受信")

            //indicaterequestの準備
            let data: Data = _characteristicForWrite.value!
            _peripheralManager.updateValue(data, for: _characteristicForIndicate, onSubscribedCentrals: nil)

            //data
            print("\(dataToHex(data: data))")
            
            //---mail---
           // _delegate.readData(data: data)
            
            
            
            //------- P O S T ---------
            let url = "https://httpbin.org/post"
            let request = NSMutableURLRequest(url: URL(string: url)!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-type")

            let str1 = dataToHex(data: data)
            print("\(str1.prefix(2))")
            
            //dataの後6桁が個人の番号,前2桁が出退勤情報
            let params: [String: Any] = ["attend" : ["\(str1.suffix(6))":"\(str1.prefix(2))"]]
            do { request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                let task: URLSessionDataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in

                    let resultData = String(data: data!, encoding: .utf8)!

                    print("resultData: \(resultData)")
                    print("\(String(describing: response))")
                })
                task.resume()
            } catch {
                print("error: \(error)")
                return
            }
            
            
            
            
             }
    
    //dataを文字に変換
    func dataToHex(data: Data) -> String {
        return data.map {
            String(format: "%02hhx", $0)
        } .joined()
    }
        
    
    //advertise停止
    func stopAdvertise() {
        
        _peripheralManager.stopAdvertising()
        print("stop advertise")
    }
    

    
}


