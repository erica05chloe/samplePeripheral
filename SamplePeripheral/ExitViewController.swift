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
    var ud = UserDefaults()
    var selectCell:[String] = []
    
    @IBOutlet weak var checkListView: UITableView!
    @IBOutlet weak var textName: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textName.delegate = self
        textName.placeholder = "氏名"
        
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
    
    
    //TODO:- 全てにcheckmarkがついたら送信できる
    
    //select cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        //checkmarkをいれる
        cell?.accessoryType = .checkmark
       
        }
    
    
    //selectはずれたとき
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        //checkmarkはずす
        cell?.accessoryType = .none
    }

    
    
    func validationCheck() -> Bool {
        var result = true
        
        //名前を空文字check
        //全てにチェックがついているか
        if let text = textName.text {
            if text.count > 0 {
                ud.set(text, forKey: "Name")
                
            } else {
                result = false
            }
        }
        
        return result
    }
    
    
    //TODO: 送信先入力＆送信後アラート
    //入退室管理のデータ送信
    @IBAction func tapToSend(_ sender: Any) {
        if validationCheck() {
          
            checkListView.cellForRow(at: checkListView.indexPathForSelectedRow!)
            print("\(String(describing: checkListView.indexPathForSelectedRow))")
    }

  }

}
