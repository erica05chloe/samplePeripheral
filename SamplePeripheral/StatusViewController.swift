//
//  StatusViewController.swift
//  SamplePeripheral
//
//  Created by Erica Awada on 2018/06/27.
//  Copyright © 2018年 Erica Awada. All rights reserved.
//

import UIKit

class StatusViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var textNumber: UITextField!
    @IBOutlet weak var textDetail: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        textNumber.placeholder = "半角数字"
        textDetail.placeholder = "例) 会議　14:00"
    }
    
    
    //textField キーボード閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //在席状態一覧
    @IBAction func logInfo(_ sender: UIButton) {
        let vc = InfoViewController()
        vc.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self.present(vc, animated: true, completion: nil)
    }
    
    
    

    //在席ボタン
    @IBAction func sittingSeat(_ sender: Any) {
        
    }
    
    
    //外出ボタン
    @IBAction func goOut(_ sender: Any) {
        
    }
    
    
    //離席ボタン
    @IBAction func leavingSeat(_ sender: Any) {
        
    }
    
   
    //退勤ボタン
    @IBAction func goHome(_ sender: Any) {
        
    }
    

}
