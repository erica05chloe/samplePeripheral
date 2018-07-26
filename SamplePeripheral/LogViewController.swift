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
import Firebase



class LogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var defaultStore: Firestore! = Firestore.firestore()
    
    @IBOutlet weak var attendList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        attendList.delegate = self
//        attendList.dataSource = self
//
//        let allList = defaultStore.collection("histories")
//        let query = allList.order(by: "createdAt", descending: true).limit(to: 30)
//        query.getDocuments(){(querySnapShot, err) in
//            if let err = err {
//                print("Error: \(err)")
//            } else {
//                for document in querySnapShot!.documents {
//                   // print("\(document.documentID) => \(document.data())")
//
//                    let name = document.get("cardId") as! String
//                    let time = document.get("createdAt") as! Date
//                    let attend = document.get("status") as! Int
//
//                    print("\(name)" + "\(time)" + "\(attend)")
//
//                }
//            }
//
//        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
       
    }
    
    //TODO:-
    //tableView 行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    //TODO:-
    //tableView セルに表示する文字
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
       
        return cell
    }

    
}
