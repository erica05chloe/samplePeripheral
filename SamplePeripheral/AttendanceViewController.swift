//
//  AttendanceViewController.swift
//  SamplePeripheral
//
//  Created by Erica Awada on 2018/06/08.
//  Copyright © 2018年 Erica Awada. All rights reserved.
//

import UIKit
import CoreNFC
import MessageUI


class AttendanceViewController: UIViewController, UITextFieldDelegate, NFCNDEFReaderSessionDelegate, MFMailComposeViewControllerDelegate {
    
    
    var blePer = BlePeripheral()
    var ud = UserDefaults.standard
    var session: NFCNDEFReaderSession?
    
    let image0 = UIImage(named: "black")
    let image1 = UIImage(named: "black")
    var count = 0

    @IBOutlet weak var bleBtn: UIButton!
    @IBOutlet weak var cardBtn: UIButton!
    @IBOutlet weak var textNumber: UITextField!
//    @IBOutlet weak var perLabel: UILabel!
    
    @IBOutlet weak var perLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       

        blePer.setup()
     //   perLabel.text = "tap me for BLE"
        
        textNumber.delegate = self
        textNumber.placeholder = "社員番号(半角数字)"
        
        
        if ud.object(forKey: "Number") == nil {
            textNumber.text = ""
        } else {
            textNumber.text = loadNumber()
        }
        
        //ボタンの装飾
//        bleBtn.layer.borderWidth = 1.5
//        bleBtn.layer.borderColor = UIColor.black.cgColor
//        bleBtn.layer.cornerRadius = 5.0
//        
//        cardBtn.layer.borderWidth = 1.5
//        cardBtn.layer.borderColor = UIColor.black.cgColor
//        cardBtn.layer.cornerRadius = 5.0
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
            perLabel.text = "1日がんばろな！"
            
            //mail
//            if MFMailComposeViewController.canSendMail() {
//                let e = MFMailComposeViewController()
//                let number = textNumber.text
//                e.mailComposeDelegate = self
//                e.setToRecipients(["erica.chloe5@gmail.com"]) //宛先
//                e.setSubject(number! + " 出勤") //件名
//                e.setMessageBody("送信を押してください)", isHTML: false) //本文
//                present(e, animated: false, completion: nil) //メール作成画面表示
//            } else {
//                print("作成できません")
//            }

            //-------- P O S T --------
            let url = "https://httpbin.org/post"
            let request = NSMutableURLRequest(url: URL(string: url)!)
            
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-type")
            
            let params: [String: Any] = ["attend" : ["01":"\(textNumber.text!)"]]
            do { request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            
                let task: URLSessionDataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
                    
                    let resultData = String(data: data!, encoding: .utf8)!
                    
                    print("resultData: \(resultData)")
                })
                task.resume()
            } catch {
                print("error: \(error)")
                return
            }
            
            
        }
    }

    
    //退勤ボタン
    @IBAction func outWork(_ sender: UIButton) {
        if validationCheck() {
            ud.set(2, forKey: "Attendance")
            ud.removeObject(forKey: "Number")
            perLabel.text = "お疲れさま！　　　　　　　　　　ゆっくり休みやぁ"
            
            //mail
//            if MFMailComposeViewController.canSendMail() {
//                let e = MFMailComposeViewController()
//                let number = textNumber.text
//                e.mailComposeDelegate = self
//                e.setToRecipients(["erica.chloe5@gmail.com"]) //宛先
//                e.setSubject(number! + " 退勤") //件名
//                e.setMessageBody("送信を押してください", isHTML: false)
//                present(e, animated: false, completion: nil) //メール作成画面表示
//            } else {
//                print("作成できません")
//            }
            
            //-------- P O S T ------------
            let url = "https://httpbin.org/post"
            let request = NSMutableURLRequest(url: URL(string: url)!)
            
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-type")
            
            let params: [String: Any] = ["attend" : ["02":"\(textNumber.text!)"]]
            do { request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                
                let task: URLSessionDataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
                    
                    let resultData = String(data: data!, encoding: .utf8)!
                    
                    print("resultData: \(resultData)")
                })
                task.resume()
            } catch {
                print("error: \(error)")
                return
            }
        }
    }
    
    //mailComposeController
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        if result == MFMailComposeResult.cancelled {
//            print("送信がキャンセルされました")
//        } else if result == MFMailComposeResult.saved {
//            print("保存されました")
//        } else if result == MFMailComposeResult.failed {
//            print("送信に失敗しました")
//        } else if result == MFMailComposeResult.sent {
//            print("送信しました")
//        }
//        dismiss(animated: false, completion: nil) //閉じる
//    }
    
  
    //BLEボタン
    @IBAction func startBLE(_ sender: AnyObject) {
        
        count += 1
    
        if(count%2 == 0){
            bleBtn.setImage(image0, for: UIControlState())
        
            print("swich off")
            blePer.stopAdvertise()
            perLabel.text = "BLE接続やめたで！"
            
        } else if(count%2 == 1) {
            bleBtn.setImage(image1, for: UIControlState())
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
                
                DispatchQueue.main.async {
                    self.textNumber.text = "\(String(data: record.payload, encoding: .utf8)!)"
                }
            }
        }
    }
    

}

extension AttendanceViewController: BlePeripheralDelegate {
//    func readData(data: Data) {
//        //mail
//        if MFMailComposeViewController.canSendMail() {
//            let e = MFMailComposeViewController()
//            let number = textNumber.text
//            e.mailComposeDelegate = self
//            e.setToRecipients(["erica.chloe5@gmail.com"]) //宛先
//            e.setSubject(number! + " 退勤") //件名
//            e.setMessageBody("送信を押してください", isHTML: false)
//            present(e, animated: false, completion: nil) //メール作成画面表示
//        } else {
//            print("作成できません")
//        }
//    }
    
    func peripheralManagerWriteRequest() {
        successAlert()
        print("callback 成功")
    }
    
}


