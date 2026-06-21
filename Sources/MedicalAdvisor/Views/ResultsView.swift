import SwiftUI

struct ResultsView: View {
    @Environment(AppState.self) var appState
    
    var body: some View {
        NavigationStack {
            List(appState.reports) { report in
                HStack {
                    VStack(alignment: .leading) {
                        Text(report.labName ?? "Лаборатория").font(.headline)
                        Text(report.reportDate ?? "").font(.caption)
                    }
                    Spacer()
                    Text("\(report.abnormalCount) откл.").font(.caption.bold()).padding(6).background(Color.orange).foregroundColor(.white).clipShape(Capsule())
                }
            }.navigationTitle("Мои Анализы")
        }
    }
}
