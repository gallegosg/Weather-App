//
//  EmailComposer.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 11/22/24.
//

import SwiftUI
import MessageUI

struct EmailComposer: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode

    let recipients: [String] = [K.appEmail]
    let subject: String = K.emailSubject
    let body: String = K.emailBody

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: EmailComposer

        init(parent: EmailComposer) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true) {
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = context.coordinator
        mailComposer.setToRecipients(recipients)
        mailComposer.setSubject(subject)
        mailComposer.setMessageBody(body, isHTML: false)
        return mailComposer
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}
