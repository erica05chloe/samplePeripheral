//
//  AttendanceViewController.swift
//  SamplePeripheral
//
//  Created by Erica Awada on 2018/06/08.
//  Copyright © 2018年 Erica Awada. All rights reserved.
//

import UIKit
import CoreNFC


class AttendanceViewController: UIViewController, UITextFieldDelegate, NFCNDEFReaderSessionDelegate {

    var blePer = BlePeripheral()
    var ud = UserDefaults.standard
    var session: NFCNDEFReaderSession?
    
//    let image0 = UIImage(named: "black")
//    let image1 = UIImage(named: "black")
    var count = 0

    @IBOutlet weak var bleBtn: UIButton!
    @IBOutlet weak var cardBtn: UIButton!
    @IBOutlet weak var textNumber: UITextField!
    @IBOutlet weak var perLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blePer.setup()
        
        textNumber.delegate = self
        textNumber.placeholder = "社員番号(半角数字)"
        
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
    
    
    //出勤ボタン
    @IBAction func inWork(_ sender: UIButton) {
        if validationCheck() {
            ud.set(1, forKey: "Attendance")
            ud.removeObject(forKey: "Number")
            perLabel.text = "1日がんばろな！"
            
            let sender = FirebaseAccessor()
            let someone = textNumber.text! + "  出勤"
            
            sender.sendMail(message: someone)
            sender.sendData(cardid: textNumber.text!, status: 0)
           
            
            startMes()
        } 
    }

    
    //退勤ボタン
    @IBAction func outWork(_ sender: UIButton) {
        if validationCheck() {
            ud.set(2, forKey: "Attendance")
            ud.removeObject(forKey: "Number")
            perLabel.text = "お疲れさま！　　　　　　　　　　ゆっくり休みやぁ"
            
            let sender = FirebaseAccessor()
            let someone = textNumber.text! + "  退勤"
            sender.sendMail(message: someone)
            sender.sendData(cardid: textNumber.text!, status: 1)
 
            startMes()
        }
    }
    
    
    func startMes() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1
        ) {
            self.perLabel.text = "スマホからはBLEボタン　　　　　社員証からはカードボタンを　　　タップするんや！"
        }
    }
            
     //BLEボタン
    @IBAction func startBLE(_ sender: AnyObject) {
        
        count += 1
    
        if(count%2 == 0){
           // bleBtn.setImage(image0, for: UIControlState())
            print("swich off")
            blePer.stopAdvertise()
            perLabel.text = "BLE接続やめたで！"
            
        } else if(count%2 == 1) {
          //  bleBtn.setImage(image1, for: UIControlState())
            print("switch on")
            blePer.startAdvertise()
            perLabel.text = "BLE接続中やで〜♩"
    
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
                print(record.typeNameFormat)
                
                DispatchQueue.main.async {
                    self.textNumber.text = "\(String(data: record.payload, encoding: .utf8)!)"
                }
            }
        }
    }
    

}




