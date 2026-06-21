//
//  ReportUploadView.swift
//  MedicalAdvisor
//
//  Upload lab report (PDF/photo) → parse → display
//

import SwiftUI
import UIKit

struct ReportUploadView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var appState = AppState()
    @State private var isScanning = false
    @State private var selectedImage: UIImage?
    @State private var previewURL: URL?
    @State private var analysis: Analysis?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // ── Upload Area ───────────────────────────────
                    VStack(spacing: 16) {
                        // Preview
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(radius: 4)
                        } else {
                            // Upload placeholder
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.secondarySystemBackground))
                                    .frame(height: 200)
                                
                                VStack(spacing: 12) {
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 32))
                                        .foregroundColor(.blue)
                                    Text("Take a photo or upload a PDF")
                                        .font(.headline)
                                    Text("Lab reports, blood tests, check-ups")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    
                    // ── Action Buttons ──────────────────────────────
                    VStack(spacing: 12) {
                        // Camera button
                        Button(action: openCamera) {
                            HStack {
                                Image(systemName: "camera.fill")
                                Text("Take Photo")
                                    .bold()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        // Photo library button
                        Button(action: openPhotoLibrary) {
                            HStack {
                                Image(systemName: "photo.fill")
                                Text("Choose from Library")
                                    .bold()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray5))
                            .foregroundStyle(.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        // Analyze button (if image selected)
                        if selectedImage != nil || isScanning {
                            Button(action: analyzeReport) {
                                HStack {
                                    if isScanning {
                                        ProgressView()
                                            .scaleEffect(0.8)
                                    } else {
                                        Image(systemName: "magnifyingglass")
                                    }
                                    Text(isScanning ? "Analyzing..." : "Analyze Results")
                                        .bold()
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(isScanning ? Color.gray : Color.green)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .disabled(isScanning)
                        }
                    }
                    
                    // ── Analysis Results ────────────────────────────
                    if let analysis = analysis {
                        AnalysisResultsView(analysis: analysis)
                    }
                }
                .padding()
            }
            .navigationTitle("Upload Report")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .sheet(item: $previewURL) { url in
                // PDF viewer or image preview
                PreviewView(url: url)
            }
        }
    }
    
    // ── Actions ───────────────────────────────────────────────────
    
    private func openCamera() {
        // In real app: use UIImagePickerController / PHPicker
        // For MVP: simulate with mock data
        loadMockData()
    }
    
    private func openPhotoLibrary() {
        loadMockData()
    }
    
    private func analyzeReport() {
        isScanning = true
        // Simulate analysis delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let report = mockReport()
            self.analysis = appState.analyze(report: report)
            self.isScanning = false
        }
    }
    
    // ── Mock Data ─────────────────────────────────────────────────
    
    private func mockReport() -> LabReport {
        LabReport(
            id: UUID(),
            labName: "LABCORP",
            reportDate: "06/15/2026",
            patientName: "Test User",
            patientAge: 35,
            patientSex: "M",
            results: [
                LabResult(testName: "Glucose", internalKey: "glucose_fasting", value: 115, unit: "mg/dL", referenceMin: 70, referenceMax: 100, flag: .high),
                LabResult(testName: "HbA1c", internalKey: "hba1c", value: 5.8, unit: "%", referenceMin: 4.0, referenceMax: 5.6, flag: .high),
                LabResult(testName: "LDL", internalKey: "ldl", value: 135, unit: "mg/dL", referenceMin: 0, referenceMax: 100, flag: .high),
                LabResult(testName: "Total Cholesterol", internalKey: "total_cholesterol", value: 215, unit: "mg/dL", referenceMin: 0, referenceMax: 200, flag: .high),
                LabResult(testName: "Triglycerides", internalKey: "triglycerides", value: 165, unit: "mg/dL", referenceMin: 0, referenceMax: 150, flag: .high),
                LabResult(testName: "Ferritin", internalKey: "ferritin", value: 15, unit: "ng/mL", referenceMin: 24, referenceMax: 336, flag: .low),
                LabResult(testName: "Vitamin D", internalKey: "vitamin_d_25oh", value: 18, unit: "ng/mL", referenceMin: 20, referenceMax: 100, flag: .low),
                LabResult(testName: "Hemoglobin", internalKey: "hemoglobin", value: 14.2, unit: "g/dL", referenceMin: 13.5, referenceMax: 17.5, flag: .normal),
                LabResult(testName: "TSH", internalKey: "tsh", value: 3.2, unit: "mIU/L", referenceMin: 0.4, referenceMax: 4.0, flag: .normal),
                LabResult(testName: "ALT", internalKey: "alt", value: 42, unit: "U/L", referenceMin: 7, referenceMax: 56, flag: .normal),
            ],
            createdAt: Date()
        )
    }
    
    private func loadMockData() {
        // For MVP demo: show analysis immediately
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isScanning = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let report = mockReport()
                analysis = appState.analyze(report: report)
                isScanning = false
            }
        }
    }
}
