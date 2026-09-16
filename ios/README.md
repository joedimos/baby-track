# Baby Track for iOS

Native SwiftUI companion to the Baby Track web application.

## Requirements

- macOS with Xcode 15 or newer
- iOS 17 or newer deployment target
- XcodeGen (recommended for generating the checked-in project definition)

## Generate and run

From this directory:

```bash
brew install xcodegen
xcodegen generate
open BabyTrack.xcodeproj
```

Select an iPhone simulator or a connected iPhone and press Run.

The app is implemented with SwiftUI, SwiftData, and Swift Charts and has no third-party runtime dependencies.

## Included

- Native five-tab interface: Today, Growth, Milestones, Timeline, Insights
- Feeding, sleep, diaper, pumping, tummy-time, medicine, and note logging
- Start/stop timers for sleep, pumping, and tummy time
- SwiftData on-device persistence
- Baby profile, birth date, and due date
- Growth measurement history and weight chart
- Development milestone journal
- Timeline filtering
- 7/30-day insights and activity chart

## Privacy

The current native app is local-first. It does not require an account or upload records to a Baby Track server.

## Web vs. iOS data

The web app and iOS app currently use separate on-device stores (`localStorage` in the web app and SwiftData in iOS). A later sync layer can provide optional encrypted family/caregiver synchronization while preserving an offline-first mode.
