# Medical Advisor — iOS App

**B2C iOS app: analyze lab reports, provide plain-English insights**

## Stack

- **SwiftUI** (iOS 17+)
- **SwiftData** (local persistence)
- **VisionKit** (document scanning)
- **Charts** (trend visualization)
- Backend: Python FastAPI + PostgreSQL (future)

## Features (MVP)

- 📸 Upload lab report (photo/PDF)
- 🔍 Parse results → compare against reference ranges
- 📋 Display abnormal findings with severity
- 💡 Generate recommendations and next steps
- 📊 Trend tracking across multiple reports (future)

## Screens

1. **Home** — intro + CTA to upload
2. **Upload** — camera/photo library → analyze
3. **Results** — findings + next steps
4. **History** — saved reports list

## Disclaimer

> ⚠️ This is informational only. NOT medical advice.

## Setup

1. Clone: `git clone git@github.com:openclaw/medical-advisor-ios.git`
2. Open `MedicalAdvisor.xcodeproj` in Xcode 15+
3. Set bundle ID and signing team
4. Build & run

## Backend (future)

- Python FastAPI service for analysis
- LLM integration for richer insights
- Cloud storage for user reports
