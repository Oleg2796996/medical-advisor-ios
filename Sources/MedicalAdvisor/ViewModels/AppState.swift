import SwiftUI
import Observation

@Observable
class AppState {
    var reports: [LabReport] = []
    var currentAnalysis: Analysis?
    
    private let testRecommendations: [String: (desc: String, rec: String)] = [
        "glucose_fasting": ("Уровень сахара", "Рекомендуется сдать HbA1c и посетить эндокринолога."),
        "hba1c": ("Средний сахар", "Важный показатель риска диабета. Проконсультируйтесь с врачом."),
        "ferritin": ("Запас железа", "Низкий ферритин может указывать на анемию."),
        "vitamin_d_25oh": ("Витамин D", "Обсудите с врачом дозировку препаратов витамина D.")
    ]
    
    func analyze(report: LabReport) -> Analysis {
        let abnormalTests = report.results.filter { $0.abnormal }
        var findings: [Finding] = []
        for test in abnormalTests {
            if let info = testRecommendations[test.internalKey] {
                findings.append(Finding(
                    id: UUID(),
                    severity: test.flag == .criticalLow || test.flag == .criticalHigh ? .critical : .warning, 
                    title: info.desc, 
                    description: "Показатель \(test.value) \(test.unit) вне нормы.", 
                    recommendation: info.rec, 
                    testsAffected: [test.testName]
                ))
            }
        }
        return Analysis(
            summary: abnormalTests.isEmpty ? "Все показатели в норме!" : "Обнаружено \(abnormalTests.count) отклонений.",
            findings: findings,
            nextSteps: ["Запишитесь на прием к терапевту.", "Не принимайте лекарства без назначения."],
            disclaimer: "⚠️ Не является медицинским диагнозом."
        )
    }
}
