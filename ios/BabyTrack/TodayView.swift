import SwiftUI
import SwiftData

struct TodayView: View {
    @Query(sort: \CareEntry.startedAt, order: .reverse) private var entries: [CareEntry]
    @Query private var profiles: [BabyProfile]
    @Environment(\.modelContext) private var context
    @State private var adding: CareType?
    @State private var showProfile = false
    private var today: [CareEntry] { entries.filter { Calendar.current.isDateInToday($0.startedAt) } }
    private let quick: [CareType] = [.feed,.sleep,.diaper,.pump,.tummy,.medicine]
    var body: some View {
        ScrollView {
            VStack(alignment:.leading,spacing:18) {
                HStack { VStack(alignment:.leading) { Text("BABY TRACK").font(.caption.bold()).foregroundStyle(.orange); Text(profiles.first?.name.isEmpty == false ? "Hi, \(profiles.first!.name) ♡" : "Today").font(.largeTitle.bold()); Text(ageText).foregroundStyle(.secondary) }; Spacer(); Button { showProfile=true } label:{ Image(systemName:"person.crop.circle").font(.title2) } }
                LazyVGrid(columns:Array(repeating:GridItem(.flexible()),count:3),spacing:10) { ForEach(quick,id:\.self) { type in Button { adding=type } label:{ VStack(spacing:8){ Image(systemName:type.icon).font(.title2); Text(type.title).font(.caption.bold()) }.frame(maxWidth:.infinity,minHeight:78).background(.background).clipShape(RoundedRectangle(cornerRadius:18)).shadow(color:.black.opacity(.05),radius:8) }.buttonStyle(.plain) } }
                VStack(alignment:.leading,spacing:12){ Text("Today").font(.headline); HStack { Stat(value:count(.feed),label:"feeds"); Stat(value:count(.diaper),label:"diapers"); Stat(value:sleepText,label:"sleep"); Stat(value:count(.pump),label:"pumps") } }.card()
                ForEach(entries.filter(\.isActive)) { entry in ActiveTimer(entry:entry) }
                Text("Recent").font(.title3.bold()); if entries.isEmpty { ContentUnavailableView("Nothing logged yet",systemImage:"heart.text.square") } else { ForEach(entries.prefix(8)) { EntryRow(entry:$0) } }
            }.padding()
        }.background(Color(.systemGroupedBackground)).navigationBarHidden(true)
        .sheet(item:$adding){ AddEntryView(type:$0) }.sheet(isPresented:$showProfile){ ProfileView() }
    }
    private func count(_ t:CareType)->String { "\(today.filter{$0.type==t}.count)" }
    private var sleepText:String { let m=today.filter{$0.type == .sleep}.compactMap(\.durationMinutes).reduce(0,+); return m > 0 ? "\(m/60)h \(m%60)m" : "0" }
    private var ageText:String { guard let d=profiles.first?.birthDate else { return "Set up baby's profile" }; let m=Calendar.current.dateComponents([.month],from:d,to:.now).month ?? 0; return m < 1 ? "Newborn" : "\(m) months old" }
}

struct Stat: View { let value:String; let label:String; var body:some View { VStack(alignment:.leading){ Text(value).font(.headline); Text(label).font(.caption).foregroundStyle(.secondary) }.frame(maxWidth:.infinity,alignment:.leading) } }
struct EntryRow: View { let entry:CareEntry; var body:some View { HStack { Image(systemName:entry.type.icon).frame(width:38,height:38).background(.orange.opacity(.12)).clipShape(RoundedRectangle(cornerRadius:11)); VStack(alignment:.leading){ Text(entry.type.title).bold(); Text(entry.note.isEmpty ? entry.detail : entry.note).font(.caption).foregroundStyle(.secondary).lineLimit(1) }; Spacer(); Text(entry.startedAt,style:.time).font(.caption).foregroundStyle(.secondary) }.padding(12).background(.background).clipShape(RoundedRectangle(cornerRadius:16)) } }
struct ActiveTimer: View { @Bindable var entry:CareEntry; var body:some View { HStack { VStack(alignment:.leading){ Text("\(entry.type.title) in progress").bold().foregroundStyle(.green); Text("Started \(entry.startedAt.formatted(date:.omitted,time:.shortened))").font(.caption) }; Spacer(); Button("Stop") { let end=Date(); entry.endedAt=end; entry.durationMinutes=max(1,Int(end.timeIntervalSince(entry.startedAt)/60)); entry.isActive=false }.buttonStyle(.borderedProminent).tint(.green) }.padding().background(.green.opacity(.08)).clipShape(RoundedRectangle(cornerRadius:16)) } }
extension View { func card()->some View { self.padding().background(.background).clipShape(RoundedRectangle(cornerRadius:20)).shadow(color:.black.opacity(.04),radius:10) } }
