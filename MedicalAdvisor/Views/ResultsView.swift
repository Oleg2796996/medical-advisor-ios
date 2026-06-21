//
//  ResultsView.swift
//  MedicalAdvisor
//
//  Display saved reports with results
//

import SwiftUI

struct ResultsView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack {
            if appState.reports.isEmpty {
                EmptyResultsView()
            } else {
                List {
                    ForEach(appState.reports) { report in
                        ReportCard(report: report)
                    }
                }
                .navigationTitle("My Results")
            }
        }
    }
}

// ── Report Card ────────────────────────────────────────────────

struct ReportCard: View {
    let report: LabReport
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack {
                VStack(alignment: .leading) {
                    Text(report.labName ?? "Lab Report")
                        .font(.headline)
                    Text(formatDate(report.reportDate))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Abnormal count badge
                if report.abnormalCount > 0 {
                    Text("\(report.abnormalCount) abnormal")
                        .font(.caption.bold())
                        .padding(6)
                        .background(Color.orange)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                } else {
                    Text("All normal")
                        .font(.caption.bold())
                        .padding(6)
                        .background(Color.green)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
            }
            
            // Quick summary
            VStack(alignment: .leading, spacing: 4) {
                Text("Results: \(report.totalCount)")
                    .font(.subheadline)
                
                if let patientName = report.patientName {
                    Text("Patient: \(patientName)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private func formatDate(_ dateStr: String?) -> String {
        guard let date = dateStr else { return "Unknown date" }
        return date // In real app: parse date string
    }
}
