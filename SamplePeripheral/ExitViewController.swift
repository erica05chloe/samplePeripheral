//
//  ExitViewController.swift
//  SamplePeripheral
//
//  Created by Erica Awada on 2018/06/08.
//  Copyright © 2018年 Erica Awada. All rights reserved.
//

import UIKit

class ExitViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var checkList = ["窓の施錠", "総務部キャビネット", "有線放送電源", "エアコン電源", "消灯", "セキュリティ設定"]
    
    @IBOutlet weak var checkListView: UITableView!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    var selectCell:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textName.delegate = self
        textName.placeholder = "氏名"
        sendBtn .isEnabled = false
        sendBtn.backgroundColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
        
        let displayWidth: CGFloat = self.view.frame.width
        let checkListView: UITableView = UITableView(frame: CGRect(x: 0, y: 200, width: displayWidth, height: 300))
        checkListView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        checkListView.dataSource = self
        checkListView.delegate = self
        
    //複数 true, 単一 false
        checkListView.allowsMultipleSelection = true
        checkListView.tableFooterView = UIView(frame: .zero)
        self.view.addSubview(checkListView)
        
    }

  
    //textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //returnで閉じるキーボード
        textField.resignFirstResponder()
        return true
    }
    
    //checkListのmethod
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(checkList[indexPath.row])"
        return cell
    }
    

    //select cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)

       // checkmarkをいれる
        cell?.accessoryType = .checkmark
        selectCell.append(1)
        print("\(selectCell)")

        if selectCell.count == checkList.count {
            sendBtn.isEnabled = true
            sendBtn.backgroundColor = UIColor.init(red: 118/255, green: 214/255, blue: 255/255, alpha: 1.0)
            }
        }

    //selectはずれたとき
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        //checkmarkはずす
        cell?.accessoryType = .none
        selectCell.remove(at: 0)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if selectCell.count != checkList.count {
            sendBtn.isEnabled = false
            sendBtn.backgroundColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
        }
    }

    
    func validationCheck() -> Bool {
        var result = true
        
        //名前を空文字check
        if let text = textName.text {
            if text.count > 0 {
            } else {
                result = false
            }
        }
        if result == false {
            print("名前入力されていない")
            faultAlert()
        }
        return result
    }
    
    
    func faultAlert() {
        let alert: UIAlertController = UIAlertController(title: "ERROR", message: "名前を入力してください", preferredStyle: UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in } )
        
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    func finalAlert() {
        let alert: UIAlertController = UIAlertController(title: "送信完了", message: "お疲れ様でした", preferredStyle: UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in } )
        
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
 
    //入退室管理のデータ送信
    @IBAction func tapToSend(_ sender: AnyObject) {
        if validationCheck() {
        let fireAcce = FirebaseAccessor()
        fireAcce.sendLast(message: textName.text!)
        }
        finalAlert()
        textName.text = ""
        
        //TODO:-
        //全選択解除
        for i in 0..<checkList.count {
            let indexPath = IndexPath(row: i, section: 0)
            let cell = checkListView.cellForRow(at: indexPath)
            cell?.accessoryType = .none
            checkListView.deselectRow(at: indexPath, animated: true)
            print("checkList")
       // }; reloadInputViews()
        };self.checkListView.reloadData()
        sendBtn.isEnabled = false
        sendBtn.backgroundColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
  }

}
