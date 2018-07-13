//
//  LogViewController.swift
//  SamplePeripheral
//
//  Created by Erica Awada on 2018/06/08.
//  Copyright © 2018年 Erica Awada. All rights reserved.
//

//サーバーから受け取って、一覧として表示
//出退勤の時間一覧

import UIKit

class LogViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //とりあえずアプリ起動時にget
        //------ G E T ----------
        let url = URL(string: "https://httpbin.org/get")
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                print("statusCode: \(response.statusCode)")
                
                let resultData = String(data: data, encoding: .utf8)!
                print("resultData: \(resultData)")
            }
        }.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    
}
