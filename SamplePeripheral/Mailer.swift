//
//  Mailer.swift
//

import Foundation

class Mailer {
    init() {
    }
    
    //勤怠情報
    func send(message: String) {
        // Sent Message Session
        let smtpSession = MCOSMTPSession()
        smtpSession.hostname = "smtp.gmail.com"
        smtpSession.port = 465
        smtpSession.username = "test.skb.raven@gmail.com"
        smtpSession.password = "ravenraben2016!"
        smtpSession.connectionType = .TLS

        //timelog@raven-g.com
        //timelog2018!
        // Set
        let builder = MCOMessageBuilder()
        let header = MCOMessageHeader()
        header.from = MCOAddress(mailbox: "timelog@raven-g.com")
        header.to = [MCOAddress(mailbox: "timelog@raven-g.com")]
        header.subject = "勤怠情報"
        builder.header = header
        // text part
        builder.textBody = message

        let rfc822Data = builder.data()
        let sendOperation = smtpSession.sendOperation(with: rfc822Data)
        sendOperation?.start{ (error) -> Void in
            if error != nil {
                // Error TBF
                print("Error sending email: \(error.debugDescription)")
            } else {
                print("Success sending email: \(message)")
            }
        }
    }
    
    //退室管理
    func sendFinal(message: String) {
        // Sent Message Session
        let smtpSession = MCOSMTPSession()
        smtpSession.hostname = "smtp.gmail.com"
        smtpSession.port = 465
        smtpSession.username = "raven.ericaa@gmail.com"
        smtpSession.password = "erica0409"
        smtpSession.connectionType = .TLS
        
        // Set
        let builder = MCOMessageBuilder()
        let header = MCOMessageHeader()
        header.from = MCOAddress(mailbox: "raven.ericaa@gmail.com")
        header.to = [MCOAddress(mailbox: "raven.ericaa@gmail.com")]
        header.subject = "退室管理"
        builder.header = header
        // text part
        builder.textBody = message
        
        let rfc822Data = builder.data()
        let sendOperation = smtpSession.sendOperation(with: rfc822Data)
        sendOperation?.start{ (error) -> Void in
            if error != nil {
                // Error TBF
                print("Error sending email: \(error.debugDescription)")
            } else {
                print("Success sending email: \(message)")
            }
        }
    }
}
