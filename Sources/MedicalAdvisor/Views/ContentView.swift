import SwiftUI

struct ContentView: View {
    @State private var appState = AppState()
    @State private var showUploadSheet = false
    
    var body: some View {
        TabView {
            NavigationStack {
                VStack(spacing: 20) {
                    Text("Medical Advisor").font(.largeTitle.bold()).padding(.top, 40)
                    VStack {
                        Image(systemName: "doc.text.magnifyingglass").font(.system(size: 60)).foregroundColor(.blue)
                        Text("Понимайте свои анализы проще").font(.title2.bold())
                        Text("Загрузите отчет, и мы переведем термины на понятный язык.").multilineTextAlignment(.center).foregroundColor(.secondary).padding()
                    }
                    Divider()
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Как это работает").font(.headline)
                        Text("1. Сфотографируйте анализ\n2. AI сравнит с нормой\n3. Получите рекомендации").padding()
                    }
                }.padding()
            }.tabItem { Label("Главная", systemImage: "house.fill") }
            
            ResultsView().environment(appState).tabItem { Label("Результаты", systemImage: "list.bullet") }
        }
        .environment(appState)
        .overlay(alignment: .bottomTrailing) {
            Button(action: { showUploadSheet = true }) {
                Image(systemName: "plus").font(.title.bold()).foregroundColor(.white).frame(width: 60, height: 60).background(Color.blue).clipShape(Circle()).shadow(radius: 4)
            }.padding(30)
        }
        .sheet(isPresented: $showUploadSheet) { ReportUploadView() }
    }
}
