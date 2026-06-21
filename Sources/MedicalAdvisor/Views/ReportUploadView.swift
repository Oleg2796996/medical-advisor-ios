import SwiftUI
import PhotosUI

struct ReportUploadView: View {
    @State private var appState = AppState()
    @State private var isShowingPicker = false
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Загрузка отчета").font(.title.bold()).padding(.top, 20)
                
                VStack(spacing: 15) {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        HStack {
                            Image(systemName: "photo.on.rectangle.angled")
                            Text("Выбрать фото из галереи")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                    Button(action: { isShowingPicker = true }) {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("Сделать фото")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
                
                Spacer()
                
                Text("После загрузки AI проанализирует показатели и сравнит их с референсными значениями.").multilineTextAlignment(.center).foregroundColor(.secondary).padding()
            }
            .navigationTitle("Загрузка")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        // Action to dismiss
                    }
                }
            }
            .sheet(isPresented: $isShowingPicker) {
                Text("Камера будет интегрирована через VisionKit в следующем обновлении.")
                    .padding()
            }
            .onChange(of: selectedItem) { newValue in
                if let item = newValue {
                    let mockReport = LabReport(
                        id: UUID(),
                        labName: "Инвитро",
                        reportDate: "21.06.2026",
                        results: [
                            LabResult(testName: "Глюкоза", internalKey: "glucose_fasting", value: "6.2", unit: "ммоль/л", abnormal: true, flag: .warning),
                            LabResult(testName: "Ферритин", internalKey: "ferritin", value: "12", unit: "нг/мл", abnormal: true, flag: .critical)
                        ]
                    )
                    appState.reports.append(mockReport)
                }
            }
        }
    }
}
