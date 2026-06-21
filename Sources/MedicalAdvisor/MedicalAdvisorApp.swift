//
//  MedicalAdvisorApp.swift
//  MedicalAdvisor
//
//  B2C iOS app: analyze lab reports, provide insights
//  Soft positioning: informational, NOT medical advice
//

import SwiftUI

@main
struct MedicalAdvisorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(AppState())
        }
    }
}
