//
//  MailRequest.swift
//  SamplePeripheral
//
//  Created by Erica Awada on 2018/07/12.
//  Copyright © 2018年 Erica Awada. All rights reserved.
//

import UIKit

class MailRequest: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //POST先のURL
        let url = "https://httpbin.org"
        let request = NSMutableURLRequest(url: URL(string: url)!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        //JSONファイル作成　Dictionary型
        let params: [String: Any] = [
            "abc" : "erica ",
            "baz" : ["a" : 1, "b" : 2, "x" : 3]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            
            let task: URLSessionDataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
                
            //サーバファイルの処理結果
            let resultData = String(data: data!, encoding: .utf8)!
                
                print("\(resultData)")
                print("\(String(describing: response))")
            })
            task.resume()
        } catch {
            print("\(error)")
            return
        }
    }
    
   }

