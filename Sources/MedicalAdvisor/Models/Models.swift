import SwiftUI
//
//  Models.swift
//  MedicalAdvisor
//
//  Data models for lab results and analysis
//

import Foundation

// ── Lab Result ──────────────────────────────────────────────────

struct LabResult: Identifiable, Codable, Hashable {
    let id: UUID
    let testName: String           // Original name (e.g. "Hemoglobin")
    let internalKey: String        // Normalized key (e.g. "hemoglobin")
    let value: Double
    let unit: String
    let referenceMin: Double?
    let referenceMax: Double?
    let flag: ResultFlag
    
    var abnormal: Bool { flag != .normal }
    
    var displayValue: String {
        let formatted = value == value.truncatingRemainder(dividingBy: 1) 
            ? String(format: "%.0f", value)
            : String(format: "%.2f", value)
        return "\(formatted) \(unit)"
    }
    
    var displayReference: String? {
        guard let min = referenceMin, let max = referenceMax else { return nil }
        return "\(min)-\(max)"
    }
    
    init(
        testName: String,
        internalKey: String,
        value: Double,
        unit: String,
        referenceMin: Double? = nil,
        referenceMax: Double? = nil,
        flag: ResultFlag
    ) {
        self.id = UUID()
        self.testName = testName
        self.internalKey = internalKey
        self.value = value
        self.unit = unit
        self.referenceMin = referenceMin
        self.referenceMax = referenceMax
        self.flag = flag
    }
}

// ── Result Flag ─────────────────────────────────────────────────

enum ResultFlag: String, Codable, CaseIterable {
    case normal
    case low
    case high
    case criticalLow
    case criticalHigh
    case unknown
    
    var color: Color {
        switch self {
        case .normal: return .green
        case .low, .high: return .orange
        case .criticalLow, .criticalHigh: return .red
        case .unknown: return .gray
        }
    }
    
    var icon: String {
        switch self {
        case .normal: return "checkmark.circle.fill"
        case .low, .high: return "exclamationmark.triangle.fill"
        case .criticalLow, .criticalHigh: return "exclamationmark.circle.fill"
        case .unknown: return "questionmark.circle.fill"
        }
    }
    
    var label: String {
        switch self {
        case .normal: return "Normal"
        case .low: return "Low"
        case .high: return "High"
        case .criticalLow: return "Critical Low"
        case .criticalHigh: return "Critical High"
        case .unknown: return "Unknown"
        }
    }
}

// ── Lab Report ──────────────────────────────────────────────────

struct LabReport: Identifiable, Codable {
    let id: UUID
    let labName: String?
    let reportDate: String?
    let patientName: String?
    let patientAge: Int?
    let patientSex: String?
    let results: [LabResult]
    let createdAt: Date
    
    var abnormalCount: Int {
        results.filter(\.abnormal).count
    }
    
    var totalCount: Int {
        results.count
    }
}

// ── Finding ─────────────────────────────────────────────────────

struct Finding: Identifiable, Codable {
    let id: UUID
    let severity: FindingSeverity
    let title: String
    let description: String
    let recommendation: String
    let testsAffected: [String]
    
    var color: Color {
        switch severity {
        case .critical: return .red
        case .warning: return .orange
        case .info: return .blue
        }
    }
}

enum FindingSeverity: String, Codable, CaseIterable {
    case critical
    case warning
    case info
    
    var icon: String {
        switch self {
        case .critical: return "🚨"
        case .warning: return "⚠️"
        case .info: return "💡"
        }
    }
}

// ── Analysis ────────────────────────────────────────────────────

struct Analysis: Codable {
    let summary: String
    let findings: [Finding]
    let nextSteps: [String]
    let disclaimer: String
}
