//
//  AppState.swift
//  MedicalAdvisor
//
//  App state: reports storage, analysis
//

import SwiftUI
import SwiftData

class AppState: ObservableObject {
    @Published var reports: [LabReport] = []
    @Published var currentAnalysis: Analysis?
    @Published var selectedTab: Int = 0
    
    // Mock analysis for MVP (later: call Python backend)
    func analyze(report: LabReport) -> Analysis {
        let abnormalCount = report.results.filter(\.abnormal).count
        
        // Generate summary
        var summary: String
        if report.results.contains(where: { $0.flag == .criticalLow || $0.flag == .criticalHigh }) {
            summary = "🚨 Critical findings detected. Seek medical attention."
        } else if abnormalCount > 0 {
            summary = "⚠️ \(abnormalCount) out of \(report.totalCount) tests are outside normal range."
        } else {
            summary = "✅ All \(report.totalCount) tests within normal range."
        }
        
        // Generate findings from abnormal results
        var findings: [Finding] = []
        for result in report.results where result.abnormal {
            let severity: FindingSeverity = result.flag == .high || result.flag == .low ? .warning : .critical
            let title = "\(result.flag.label.capitalized): \(result.testName) (\(result.displayValue))"
            
            // Generic descriptions based on test type
            let desc = self.testDescription(key: result.internalKey, value: result.value, flag: result.flag)
            let rec = self.testRecommendation(key: result.internalKey, flag: result.flag)
            
            findings.append(Finding(
                id: UUID(),
                severity: severity,
                title: title,
                description: desc,
                recommendation: rec,
                testsAffected: [result.internalKey]
            ))
        }
        
        // Sort by severity
        let severityOrder: [FindingSeverity] = [.critical, .warning, .info]
        findings.sort { a, b in
            severityOrder.firstIndex(of: a.severity)! < severityOrder.firstIndex(of: b.severity)!
        }
        
        // Generate next steps
        var nextSteps: [String] = ["📋 Share results with your doctor"]
        let keys = Set(report.results.filter(\.abnormal).map(\.internalKey))
        if keys.contains("ferritin") { nextSteps.append("🩸 Ask about iron supplementation") }
        if keys.contains("vitamin_d_25oh") { nextSteps.append("☀️ Ask about vitamin D (2000-5000 IU/day)") }
        if keys.contains("glucose_fasting") || keys.contains("hba1c") {
            nextSteps.append("🩺 Request diabetes screening")
        }
        if keys.intersection(["ldl", "total_cholesterol", "triglycerides"]).isEmpty == false {
            nextSteps.append("❤️ Ask about cardiovascular risk assessment")
        }
        nextSteps.append("🍎 Maintain healthy diet, 150 min exercise/week")
        
        return Analysis(
            summary: summary,
            findings: findings,
            nextSteps: nextSteps,
            disclaimer: "⚠️ This is informational only and NOT a diagnosis. Consult a healthcare professional."
        )
    }
    
    private func testDescription(key: String, value: Double, flag: ResultFlag) -> String {
        let descriptions: [String: String] = [
            "hemoglobin": "Hemoglobin carries oxygen in your blood. \(flag.label.lowercased()) levels may indicate anemia or other conditions.",
            "glucose_fasting": "Fasting glucose measures blood sugar. \(flag.label.lowercased()) levels may suggest insulin resistance.",
            "total_cholesterol": "Total cholesterol is a measure of all cholesterol in your blood. \(flag.label.lowercased()) levels increase cardiovascular risk.",
            "ldl": "LDL is the 'bad' cholesterol. \(flag.label.lowercased()) levels increase heart disease risk.",
            "triglycerides": "Triglycerides are a type of fat in your blood. \(flag.label.lowercased()) levels may relate to diet or metabolism.",
            "ferritin": "Ferritin stores iron in your body. \(flag.label.lowercased()) levels may indicate iron deficiency.",
            "vitamin_d_25oh": "Vitamin D supports bone health and immunity. \(flag.label.lowercased()) levels are very common and treatable.",
            "hba1c": "HbA1c reflects average blood sugar over 3 months. \(flag.label.lowercased()) levels suggest prediabetes or diabetes.",
            "tsh": "TSH regulates thyroid function. \(flag.label.lowercased()) levels may indicate thyroid issues.",
            "alt": "ALT is a liver enzyme. \(flag.label.lowercased()) levels may indicate liver stress.",
            "ast": "AST is a liver/muscle enzyme. \(flag.label.lowercased()) levels may indicate organ stress.",
        ]
        
        let base = descriptions[key] ?? "This test result is outside the normal reference range."
        return "\(base) Your value: \(value). Normal range: \(key == "vitamin_d_25oh" ? "20-100" : "see lab report") \(key == "vitamin_d_25oh" ? "ng/mL" : "")."
    }
    
    private func testRecommendation(key: String, flag: ResultFlag) -> String {
        let recs: [String: String] = [
            "ferritin": "Ask your doctor about iron supplementation. Common causes: heavy periods, poor diet, GI blood loss.",
            "vitamin_d_25oh": "Vitamin D: 2000-5000 IU/day. Sun exposure 15-20 min/day helps.",
            "glucose_fasting": "Reduce refined carbs and sugar. Exercise 30 min/day. Ask your doctor about repeat testing.",
            "ldl": "Reduce saturated fat and fried foods. Exercise regularly. Ask your doctor about management.",
            "total_cholesterol": "Reduce saturated fat, increase fiber. Ask your doctor about cholesterol management.",
            "triglycerides": "Reduce alcohol, sugar, and refined carbs. Exercise regularly. Omega-3 may help.",
            "hba1c": "5.6-6.4% = prediabetes. Lifestyle changes can reverse this. Ask your doctor about a plan.",
            "tsh": "Follow up for full thyroid panel: TSH, Free T4, Free T3, TPO antibodies.",
            "alt": "Reduce alcohol, review medications. Most common cause is fatty liver — weight loss helps.",
            "ast": "Discuss with your doctor. May need liver function evaluation.",
            "hemoglobin": "Ask about iron studies. Consider iron-rich foods: red meat, spinach, legumes.",
        ]
        
        return recs[key] ?? "Discuss with your doctor. Normal range varies by lab."
    }
}
