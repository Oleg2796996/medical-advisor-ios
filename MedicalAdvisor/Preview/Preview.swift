//
//  Preview.swift
//  MedicalAdvisor
//
//  Preview providers for SwiftUI previews
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
