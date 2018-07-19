//
//  Mailer.swift
//

import Foundation

class Mailer {
    init() {
    }
    
    func send(message: String) {
        // Sent Message Session
        let smtpSession = MCOSMTPSession()
        smtpSession.hostname = "smtp.gmail.com"
        smtpSession.port = 465
        smtpSession.username = "raven.ericaa@gmail.com"
        smtpSession.password = "erica0409"
        smtpSession.connectionType = .TLS

        // Set
        let builder = MCOMessageBuilder()
        var header = MCOMessageHeader()
        header.from = MCOAddress(mailbox: "raven.ericaa@gmail.com")
        header.to = [MCOAddress(mailbox: "raven.ericaa@gmail.com")]
        header.subject = "test"
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
