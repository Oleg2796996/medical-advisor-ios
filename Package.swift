// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MedicalAdvisor",
    platforms: [.iOS(.v17)],
    products: [.executable(name: "MedicalAdvisor", targets: ["MedicalAdvisor"])],
    targets: [.target(name: "MedicalAdvisor", dependencies: [])]
)
