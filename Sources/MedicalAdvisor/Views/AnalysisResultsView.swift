//
//  AnalysisResultsView.swift
//  MedicalAdvisor
//
//  Display analysis results with findings and recommendations
//

import SwiftUI

struct AnalysisResultsView: View {
    let analysis: Analysis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // ── Summary ───────────────────────────────────────
            VStack(alignment: .leading, spacing: 8) {
                Text("Analysis")
                    .font(.title2.bold())
                
                Text(analysis.summary)
                    .font(.body)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray6))
                    )
            }
            
            // ── Findings ──────────────────────────────────────
            if !analysis.findings.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Findings")
                        .font(.title3.bold())
                    
                    ForEach(analysis.findings) { finding in
                        FindingCard(finding: finding)
                    }
                }
            }
            
            // ── Next Steps ────────────────────────────────────
            VStack(alignment: .leading, spacing: 8) {
                Text("Next Steps")
                    .font(.title3.bold())
                
                ForEach(analysis.nextSteps, id: \.self) { step in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                        Text(step)
                            .font(.body)
                    }
                }
            }
            
            // ── Disclaimer ────────────────────────────────────
            Text(analysis.disclaimer)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 8)
            
            // ── Save Button ───────────────────────────────────
            Button(action: {}) {
                HStack {
                    Image(systemName: "square.and.arrow.down")
                    Text("Save Report")
                        .bold()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}

// ── Finding Card ────────────────────────────────────────────────

struct FindingCard: View {
    let finding: Finding
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(finding.severity.icon)
                Text(finding.title)
                    .font(.headline)
                    .foregroundColor(finding.color)
            }
            
            Text(finding.description)
                .font(.body)
                .foregroundColor(.secondary)
            
            Text(finding.recommendation)
                .font(.subheadline)
                .padding(8)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

// ── Preview View ────────────────────────────────────────────────

struct PreviewView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        let label = UILabel()
        label.text = "Preview: \(url.lastPathComponent)"
        label.textAlignment = .center
        vc.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)
        ])
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
