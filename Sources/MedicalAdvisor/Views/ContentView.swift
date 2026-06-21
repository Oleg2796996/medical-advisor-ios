//
//  ContentView.swift
//  MedicalAdvisor
//
//  Main tab view with navigation
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState()
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            // ── Home Tab ──────────────────────────────────────
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            
            // ── Results Tab ───────────────────────────────────
            if appState.reports.isEmpty {
                EmptyResultsView()
                    .tabItem {
                        Label("Results", systemImage: "doc.text")
                    }
                    .tag(1)
            } else {
                ResultsView()
                    .tabItem {
                        Label("Results", systemImage: "doc.text")
                    }
                    .tag(1)
            }
            
            // ── Plus Button (Add Report) ──────────────────────
            // Handled by toolbar
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    appState.selectedTab = 2
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
        }
        .sheet(isPresented: .constant(true)) {
            // This will be triggered by the Plus button in real implementation
        }
        .environment(appState)
    }
}

// ── Home Tab ─────────────────────────────────────────────────────

struct HomeView: View {
    @StateObject private var appState = AppState()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // ── Hero ──────────────────────────────────────
                    VStack(spacing: 12) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.blue)
                        Text("Medical Advisor")
                            .font(.title.bold())
                        Text("Upload your lab reports. Get plain-English insights.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical, 20)
                    
                    // ── CTA ───────────────────────────────────────
                    Button(action: {
                        appState.selectedTab = 2
                    }) {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("Upload Lab Report")
                                .bold()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    // ── How it works ────────────────────────────
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How it works")
                            .font(.title2.bold())
                        
                        [
                            ("📸", "Upload a photo or PDF of your lab report", "Take a photo or select from your library"),
                            ("🔍", "AI analyzes your results", "We compare against reference ranges and look for patterns"),
                            ("📋", "Get plain-English insights", "Understand what your numbers mean and what to do next"),
                        ].enumerated().map { i, (icon, title, desc) in
                            HStack(spacing: 12) {
                                Text(icon)
                                    .font(.title2)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(title)
                                        .font(.headline)
                                    Text(desc)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    // ── Disclaimer ──────────────────────────────
                    Text("⚠️ This app provides informational insights only and is NOT a substitute for professional medical advice. Always consult your healthcare provider.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}

// ── Empty Results ────────────────────────────────────────────────

struct EmptyResultsView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "doc.badge.plus")
                    .font(.system(size: 60))
                    .foregroundColor(.secondary)
                Text("No results yet")
                    .font(.title2.bold())
                Text("Upload your first lab report to get started.")
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))
        }
    }
}
