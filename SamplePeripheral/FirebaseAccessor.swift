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
    
    
    func sendMail(message: String){
        //mail
        let callMailer = Mailer()
        callMailer.send(message: message)
        print(message)
    }
    
    
    func sendData(cardid: String, status: Int) {
        

//        //mail
//        let callMailer = Mailer()
//        callMailer.send(message: "")
//
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

}
