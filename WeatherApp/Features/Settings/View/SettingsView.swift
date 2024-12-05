//
//  SettingsView.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 10/1/24.
//

import SwiftUI
import MessageUI

struct SettingsView: View {
    @StateObject var vm: WeatherViewModel
    @EnvironmentObject private var settings: SettingsViewModel
    @State private var isShowingEmailComposer = false

    var units: [String] = ["C", "F"]
    
    var body: some View {
        List {
            Section(header: Text(String(localized: "Temperature Unit"))) {
                UnitButton(unit: K.imperial)
                UnitButton(unit: K.metric)
            }
            
            Section(header: Text(String(localized: "General"))) {
                HStack {
                    Text(String(localized: "Permissions"))
                    Spacer()
                    Button(String(localized: "Settings")) {
                        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                        }
                    }
                    .tint(.lightBlue)
                }
            }
            
            Section(header: Text(String(localized: "Info"))) {
                HStack {
                    Text(String(localized: "Data Source"))
                    Spacer()
                    Text(String(localized: "Weather API"))
                }
                HStack {
                    Text(String(localized: "Feedback"))
                    Spacer()
                    Button(String(localized: "Email")) {
                        if MFMailComposeViewController.canSendMail() {
                            isShowingEmailComposer = true
                        } else {
                            openEmailFallback()
                        }
                        
                    }
                    .tint(.lightBlue)
                }
            }
        }
        .background(Color.blue.opacity(0.1))
        .scrollContentBackground(.hidden)
        .navigationTitle(String(localized: "Settings"))
        .sheet(isPresented: $isShowingEmailComposer) {
            EmailComposer()
        }
    }
    
    private func openEmailFallback() {
        let email = K.appEmail
        let subject = K.emailSubject
        let body = K.emailBody
        if let url = URL(string: "mailto:\(email)?subject=\(subject)&body=\(body)"),
           UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                print("Unable to open email app.")
            }
        }
}

#Preview {
    SettingsView(vm: WeatherViewModel(service: WeatherService(), locationManager: LocationManager()))
        .environmentObject(SettingsViewModel())
}
