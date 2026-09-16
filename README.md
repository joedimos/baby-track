# Baby Track

Baby Track now contains **two implementations** of the baby care and development tracker:

1. A zero-dependency, mobile-first web/PWA application in the repository root.
2. A native **SwiftUI iOS application** under `ios/`, using SwiftData and Swift Charts.

Both are designed around fast caregiver logging and local-first storage.

## Features

### Daily care
- Feeding: breast, bottle, formula, solids, optional amount in oz/mL
- Sleep: enter a duration or start/stop a live timer
- Diapers: wet, dirty, both, or dry
- Pumping: duration or live timer
- Tummy time: duration or live timer
- Medicine administration log (logging only; the app does not recommend doses)
- General notes
- Today dashboard and chronological timeline

### Growth & development
- Weight, length, and head-circumference history
- Development milestone journal organized by age
- Milestone completion tracking
- Growth visualization in the native iOS app

The milestone journal is not a diagnostic or screening instrument. CDC describes milestones as things most children (75% or more) can do by a given age. Concerns about development should be discussed with a child's healthcare professional.

### Insights
- 7- and 30-day care summaries
- Average feeds and diapers per day
- Recorded sleep average
- Daily logging activity visualization
- Tummy-time totals in the web application

These summaries describe the data entered by the caregiver; they do not determine whether a baby's feeding, sleep, growth, or development is medically appropriate.

## Web app

No package installation or build step is required:

```bash
python3 -m http.server 8000
```

Open `http://localhost:8000`. The web app stores data in browser `localStorage`, supports JSON backup/import, and includes an offline application-shell service worker.

## Native iOS app

The `ios/` directory contains a native iOS 17+ application using SwiftUI, SwiftData, and Swift Charts with no third-party runtime dependencies.

```bash
cd ios
brew install xcodegen
xcodegen generate
open BabyTrack.xcodeproj
```

Then choose an iPhone simulator or connected device in Xcode and Run. See `ios/README.md` for details.

## Architecture

### Web
- `index.html` — application shell and dialogs
- `styles.css` — responsive design system
- `app.js` — care logging, timers, growth, milestones, insights, import/export
- `manifest.webmanifest` — web-app metadata
- `sw.js` — offline application-shell cache

### iOS
- `ios/project.yml` — reproducible XcodeGen project definition
- `ios/BabyTrack/BabyTrackApp.swift` — app and tab navigation
- `ios/BabyTrack/Models.swift` — SwiftData domain model
- `ios/BabyTrack/TodayView.swift` — dashboard and active timers
- `ios/BabyTrack/AddEntryView.swift` — care logging and profile forms
- `ios/BabyTrack/OtherViews.swift` — growth, milestones, timeline, and insights

## Privacy

Neither implementation currently requires a Baby Track account or remote database. The web and iOS stores are separate today. Optional encrypted caregiver/family synchronization can be introduced later without making cloud storage mandatory.

## Potential next phase

Multiple children, encrypted caregiver sync, pediatric visit reports, appointments and reminders, vaccination records, attachments, validated growth-chart percentile calculations, widgets, notifications, Apple Watch quick logging, and authenticated cloud backup.
