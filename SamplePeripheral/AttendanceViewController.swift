//
//  AttendanceViewController.swift
//  SamplePeripheral
//
//  Created by Erica Awada on 2018/06/08.
//  Copyright © 2018年 Erica Awada. All rights reserved.
//

import UIKit
import CoreNFC


class AttendanceViewController: UIViewController, UITextFieldDelegate, NFCNDEFReaderSessionDelegate, BlePeripheralDelegate {
    
    
    var blePer = BlePeripheral()
    var ud = UserDefaults.standard
    var session: NFCNDEFReaderSession?
    
    let image0 = UIImage(named: "crow1")
    let image1 = UIImage(named: "crow2")
    var count = 0

    @IBOutlet weak var bleBtn: UIButton!
    @IBOutlet weak var textNumber: UITextField!
    @IBOutlet weak var perLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        blePer.setup()
        perLabel.text = "tap me for BLE"
        
        textNumber.delegate = self
        textNumber.placeholder = "社員番号(半角数字)"
        
        
        if ud.object(forKey: "Number") == nil {
            textNumber.text = ""
        } else {
            textNumber.text = loadNumber()
        }
    }

    
    //userDefaults読み込み
    func loadNumber() -> String {
        
        let str: String = ud.object(forKey: "Number") as! String
        return str
    }
    
    
    //textfield
    //returnでclose
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    //validation check
    private func validationCheck() -> Bool {
        var result = true
        
        if let text = textNumber.text {
            if text.count > 0 {
                let predicate = NSPredicate(format: "SELF MATCHES '\\\\d+'")
                
                ud.set(text, forKey: "Number")
                result = predicate.evaluate(with: text)
            } else {
                result = false
            }
        }
        if result == false{
            alert()
        }
        return result
    }
    
    
    //入力内容エラーアラート
    func alert() {

        let alert: UIAlertController = UIAlertController(title: "ERROR", message: "入力内容を確認してください", preferredStyle: UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in } )
        
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    //送信完了アラート
    func successAlert() {
        let alert: UIAlertController = UIAlertController(title: "SUCCESS", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in } )
        
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    //送信失敗アラート
    func faildAlert() {
        let alert: UIAlertController = UIAlertController(title: "ERROR", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ (action: UIAlertAction!) -> Void in } )
        
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    //TODO:- 
    //どちらも送信先はDB（サーバー）
    //出勤ボタン
    @IBAction func inWork(_ sender: UIButton) {
        if validationCheck() {
            ud.set(1, forKey: "Attendance")
            ud.removeObject(forKey: "Number")
        }
    }
    
    //退勤ボタン
    @IBAction func outWork(_ sender: UIButton) {
        if validationCheck() {
            ud.set(2, forKey: "Attendance")
            ud.removeObject(forKey: "Number")
        }
    }
    
    
    func peripheralManagerWriteRequest() {
        successAlert()
        print("callback成功")
    }
    
    
    
    
    //BLEボタン
    @IBAction func startBLE(_ sender: AnyObject) {
        count += 1
    
        if(count%2 == 0){
            bleBtn.setImage(image0, for: UIControlState())
        
            print("swich off")
            blePer.stopAdvertise()
            perLabel.text = "tap me for BLE"
            
        } else if(count%2 == 1) {
            bleBtn.setImage(image1, for: UIControlState())
            print("switch on")
            blePer.startAdvertise()
            perLabel.text = "connecting BLE!"
    
        }

    }

    
    //NFC
    @IBAction func readNFC(_ sender: UIButton) {
        //readingAvailableでNFCが使える端末か判断
        if NFCNDEFReaderSession.readingAvailable {
            
            //invalidateAfterFirstReadは連続でタグを読み取るかどうか
            session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
            session?.alertMessage = "NFCタグを近づけてください"
            
            //読み取り開始
            session?.begin()
        } else {
            print("NFCが使えません")
            faildAlert()
        }
    }
    
    //読み取り時エラーがおきたとき。キャンセルボタンを押すか、タイムアウト(60秒?)したとき。
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
           // print("error: \(error.localizedDescription)")
            print("stop NFC")
    }
    
    //読み取り成功のとき。
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            for record in message.records {
                
                
                print(String(data: record.payload, encoding: .utf8)!)
                
                DispatchQueue.main.async {
                    self.textNumber.text = "\(String(data: record.payload, encoding: .utf8)!)"
                }
            }
        }
    }
    

}


