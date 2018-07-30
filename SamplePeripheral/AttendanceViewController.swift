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
    var session: NFCNDEFReaderSession?
    
    let image0 = UIImage(named: "BLE_g")
    let image1 = UIImage(named: "black")
    var count = 0
    @IBOutlet weak var bleBtn: UIButton!
    @IBOutlet weak var cardBtn: UIButton!
    @IBOutlet weak var textNumber: UITextField!
    @IBOutlet weak var perLabel: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blePer.setup()
        textNumber.delegate = self
        textNumber.placeholder = "半角数字(eg:003)"
        sendBtn.backgroundColor = UIColor.init(red: 118/255, green: 214/255, blue: 255/255, alpha: 1.0)
        
        Thread.sleep(forTimeInterval: 1)
        blePer.startAdvertise()
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
            if text.count > 0 && text.count < 4 {
                let predicate = NSPredicate(format: "SELF MATCHES '\\\\d+'")
                result = predicate.evaluate(with: text)
            } else {
                result = false
            }
        }
        if result == false{
            alert()
            textNumber.text = ""
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
    
    //完了アラート
//    func successAlert() {
//        let alert: UIAlertController = UIAlertController(title: "SUCCESS", message: nil, preferredStyle: UIAlertControllerStyle.alert)
//        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
//            (action: UIAlertAction!) -> Void in } )
//
//        alert.addAction(defaultAction)
//        present(alert, animated: true, completion: nil)
//    }
    
    //失敗アラート
    func faildAlert() {
        let alert: UIAlertController = UIAlertController(title: "ERROR", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ (action: UIAlertAction!) -> Void in } )

        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }

    //送信ボタン
    @IBAction func sendNum(_ sender: UIButton) {
        if validationCheck() {

            let sender = FirebaseAccessor()
            let someone = textNumber.text!
            //Firebaseを参照して0なら1を、1なら0をstatusにおく
            sender.checkData(cardId: someone)
            perLabel.text = "送信できたで！"
            startMes()
            //おとならす？
            playSound()
            textNumber.text = ""
        }
    }
    
    //出勤ボタン
//    @IBAction func inWork(_ sender: UIButton) {
//        if validationCheck() {
//            ud.set(1, forKey: "Attendance")
//            ud.removeObject(forKey: "Number")
//            perLabel.text = "1日がんばろな！"
//
//            let sender = FirebaseAccessor()
//            let someone = textNumber.text!
//
//            sender.sendMail(message: someone)
//            sender.sendData(cardid: textNumber.text!, status: 0)
//
//
//            startMes()
//        }
//    }

    
    //退勤ボタン
//    @IBAction func outWork(_ sender: UIButton) {
//        if validationCheck() {
//            ud.set(2, forKey: "Attendance")
//            ud.removeObject(forKey: "Number")
//            perLabel.text = "お疲れさま！　　　　　　　　　　ゆっくり休みやぁ"
//
//            let sender = FirebaseAccessor()
//            let someone = textNumber.text!
//            sender.sendMail(message: someone)
//            sender.sendData(cardid: textNumber.text!, status: 1)
//
//            startMes()
//        }
//    }
    
    
    func startMes() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1
        ) {
            self.perLabel.text = "社員証持ってたら\nカードボタンをタップするんや！\n忘れた人は打ち込んでな！"
        }
    }
            
     //BLEボタン
    @IBAction func startBLE(_ sender: AnyObject) {
        
        count += 1
    
        if(count%2 == 0){
            bleBtn.setImage(image1, for: UIControlState())
            print("swich on")
            blePer.startAdvertise()
            perLabel.text = "アドバタイズ中やで〜♪"
            
        } else if(count%2 == 1) {
            bleBtn.setImage(image0, for: UIControlState())
            print("switch off")
            blePer.stopAdvertise()
            perLabel.text = "アドバタイズやめたで"
            startMes()
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
            print("stop NFC")
    }
   
    //読み取り成功のとき。
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            for record in message.records {
               
                print(String(data: record.payload, encoding: .utf8)!)
                print(record.typeNameFormat)
                
//              //textFieldに表示用
//                DispatchQueue.main.async {
//                    self.textNumber.text = "\(String(data: record.payload, encoding: .utf8)!)"
//                }
                
                
                let sender = FirebaseAccessor()
                sender.checkData(cardId: String(data: record.payload, encoding: .utf8)!)
            }
        }
    }
    

}




