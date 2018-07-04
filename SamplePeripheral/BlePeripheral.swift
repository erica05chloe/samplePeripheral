//
//  BlePeripheral.swift
//  SamplePeripheral
//
//  Created by Erica Awada on 2018/05/28.
//  Copyright © 2018年 Erica Awada. All rights reserved.
//

import UIKit
import CoreBluetooth

@objc
protocol BlePeripheralDelegate {
  //  func peripheralManagerAdvertising()
    func peripheralManagerWriteRequest()
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
        
        
        self._delegate?.peripheralManagerWriteRequest()

        }
    
    
        //indicateRequest受信
        func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
            print("indicate受信")

            //indicaterequestの準備
            let data: Data = _characteristicForWrite.value!
            _peripheralManager.updateValue(data, for: _characteristicForIndicate, onSubscribedCentrals: nil)

            //data
            print("\(dataToHex(data: data))")
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
