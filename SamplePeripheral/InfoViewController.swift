//
//  InfoViewController.swift
//  SamplePeripheral
//
//  Created by Erica Awada on 2018/06/27.
//  Copyright © 2018年 Erica Awada. All rights reserved.
//


//在籍状態一覧ページ
import UIKit

class InfoViewController: UIViewController {

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
        
    }
    

    

}
