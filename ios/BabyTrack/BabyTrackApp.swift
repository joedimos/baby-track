import SwiftUI
import SwiftData

@main
struct BabyTrackApp: App {
    var body: some Scene {
        WindowGroup { RootView() }
            .modelContainer(for: [BabyProfile.self, CareEntry.self, GrowthRecord.self, MilestoneRecord.self])
    }
}

struct RootView: View {
    var body: some View {
        TabView {
            NavigationStack { TodayView() }.tabItem { Label("Today", systemImage: "house.fill") }
            NavigationStack { GrowthView() }.tabItem { Label("Growth", systemImage: "chart.line.uptrend.xyaxis") }
            NavigationStack { MilestonesView() }.tabItem { Label("Milestones", systemImage: "star.fill") }
            NavigationStack { TimelineView() }.tabItem { Label("Timeline", systemImage: "list.bullet.rectangle") }
            NavigationStack { InsightsView() }.tabItem { Label("Insights", systemImage: "chart.bar.fill") }
        }.tint(.orange)
    }
}
