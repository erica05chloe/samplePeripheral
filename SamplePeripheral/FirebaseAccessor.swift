//
//  FirebaseAccessor.swift
//  SamplePeripheral
//
//  Created by Erica Awada on 2018/07/18.
//  Copyright © 2018年 Erica Awada. All rights reserved.
//

import Firebase


class FirebaseAccessor {
   
    
    var defaultStore : Firestore! = Firestore.firestore()
    
    //mail送信(出退勤）
    func sendMail(message: String, status: String) {
        
        //day time yyyy/MM/dd hh:mm
        let time = DateFormatter()
        time.timeStyle = .short
        time.dateStyle = .short
        time.locale = Locale(identifier: "ja_JP")
        let now = Date()
        print(time.string(from: now))
        
        
        //mail
        let callMailer = Mailer()
        callMailer.send(message: message + " " + time.string(from: now) + status + "\n\n\n1月\nhttps://us-central1-ravenapp-f59c0.cloudfunctions.net/history/\(message)?from=20171221&to=20180120\n\n2月\nhttps://us-central1-ravenapp-f59c0.cloudfunctions.net/history/\(message)?from=20180121&to=20180220\n\n3月\nhttps://us-central1-ravenapp-f59c0.cloudfunctions.net/history/\(message)?from=20180221&to=20180320\n\n4月\nhttps://us-central1-ravenapp-f59c0.cloudfunctions.net/history/\(message)?from=20180321&to=20180420\n\n5月\nhttps://us-central1-ravenapp-f59c0.cloudfunctions.net/history/\(message)?from=20180421&to=20180520\n\n6月\nhttps://us-central1-ravenapp-f59c0.cloudfunctions.net/history/\(message)?from=20180521&to=20180620\n\n7月\nhttps://us-central1-ravenapp-f59c0.cloudfunctions.net/history/\(message)?from=20180621&to=20180720\n\n8月\nhttps://us-central1-ravenapp-f59c0.cloudfunctions.net/history/\(message)?from=20180721&to=20180820\n\n9月\nhttps://us-central1-ravenapp-f59c0.cloudfunctions.net/history/\(message)?from=20180821&to=20180920\n\n10月\nhttps://us-central1-ravenapp-f59c0.cloudfunctions.net/history/\(message)?from=20180921&to=20181020\n\n11月\nhttps://us-central1-ravenapp-f59c0.cloudfunctions.net/history/\(message)?from=20181021&to=20181120\n\n12月\nhttps://us-central1-ravenapp-f59c0.cloudfunctions.net/history/\(message)?from=20181121&to=20181220")
        print(message)
    }
    
    //mail送信(退室管理)
    func sendLast(message: String) {
        
        //day time yyyy/MM/dd hh:mm
        let time = DateFormatter()
        time.timeStyle = .short
        time.dateStyle = .short
        time.locale = Locale(identifier: "ja_JP")
        let now = Date()
        
        let lastMailer = Mailer()
        lastMailer.sendFinal(message: time.string(from: now) + " " + message + "\n\n・窓の施錠\n・総務部キャビネット\n・有線放送電源\n・エアコン電源\n・消灯\n・セキュリティ設定\n\n上記の確認をしました。" )
    }
    
    
    //Firebaseへのデータ送信
    func sendData(cardid: String, status: Int) {
        defaultStore.collection("histories").addDocument(data: [
            "cardId": cardid,
            "status": status,
            "createdAt": Date()
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }

    //Firebaseでの参照
    func checkData(cardId: String) {
        
        let sameId = defaultStore.collection("histories")
        let query = sameId.whereField("cardId", isEqualTo: cardId)
        
        query.getDocuments(){(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var last: QueryDocumentSnapshot? = nil
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
            
                    let newDate = document.get("createdAt") as! Date
                    if last != nil {
                        let lastDate = last!.get("createdAt") as! Date
                        if lastDate < newDate {
                            last = document
                        }
                    } else {
                        last = document
                    }
                }
                
                //status情報のない人は1で登録する
                
                if let nowStatus = last?.get("status") as? Int {
                    var sendStatus = 0
                    switch nowStatus {
                    case 0:
                        sendStatus = 1
                        self.sendData(cardid: cardId, status: sendStatus)
                        self.sendMail(message: cardId, status: " 1")
                        
                    case 1:
                        sendStatus = 0
                        self.sendData(cardid: cardId, status: sendStatus)
                        self.sendMail(message: cardId, status: " 0")
                        
                    //0,1以外　不定状態(強制退勤)
                    case 99:
                        sendStatus = 0
                        self.sendData(cardid: cardId, status: sendStatus)
                        self.sendMail(message: cardId, status: " 0")
                        
                    default: print("system err")
                        
                    }
                }
                
            }
        }
    }
    

}
