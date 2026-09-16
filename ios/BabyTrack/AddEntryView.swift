import SwiftUI
import SwiftData

struct AddEntryView: View {
    let type: CareType
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var time=Date(),detail="",note="",amount="",unit="oz",duration=""
    var body: some View { NavigationStack { Form {
        DatePicker("When",selection:$time)
        if type == .feed { Picker("Type",selection:$detail){ ForEach(["Breast","Bottle","Formula","Solids"],id:\.self){Text($0)} }; TextField("Amount (optional)",text:$amount).keyboardType(.decimalPad); Picker("Unit",selection:$unit){Text("oz").tag("oz");Text("mL").tag("mL")} }
        if type == .diaper { Picker("Type",selection:$detail){ ForEach(["Wet","Dirty","Wet + dirty","Dry"],id:\.self){Text($0)} } }
        if [.sleep,.pump,.tummy].contains(type) { TextField("Duration in minutes — blank starts timer",text:$duration).keyboardType(.numberPad) }
        if type == .medicine { TextField("Medicine / administered dose",text:$detail); Text("Logging only. Follow instructions from your healthcare professional or medication label.").font(.caption).foregroundStyle(.secondary) }
        TextField("Note (optional)",text:$note,axis:.vertical)
    }.navigationTitle("Log \(type.title)").toolbar { ToolbarItem(placement:.cancellationAction){Button("Cancel"){dismiss()}}; ToolbarItem(placement:.confirmationAction){Button("Save"){save()}} } } }
    private func save(){ let mins=Int(duration),timer=[CareType.sleep,.pump,.tummy].contains(type)&&mins==nil; let e=CareEntry(type:type,startedAt:time,detail:detail,amount:Double(amount),unit:unit,durationMinutes:mins,note:note,isActive:timer); context.insert(e); dismiss() }
}

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Query private var profiles:[BabyProfile]
    @State private var name="",birth=Date(),due=Date(),hasBirth=false,hasDue=false
    var body:some View { NavigationStack { Form { Section("Baby"){TextField("Name",text:$name);Toggle("Birth date",isOn:$hasBirth);if hasBirth{DatePicker("Born",selection:$birth,displayedComponents:.date)};Toggle("Due date",isOn:$hasDue);if hasDue{DatePicker("Due",selection:$due,displayedComponents:.date)}} Section("Privacy"){Text("Baby Track stores these records on this device using SwiftData. No account or server is required by the native app.").font(.footnote).foregroundStyle(.secondary)} }.navigationTitle("Profile").toolbar { ToolbarItem(placement:.cancellationAction){Button("Cancel"){dismiss()}};ToolbarItem(placement:.confirmationAction){Button("Save"){save()}} }.onAppear { if let p=profiles.first{name=p.name;if let x=p.birthDate{birth=x;hasBirth=true};if let x=p.dueDate{due=x;hasDue=true}} } } }
    private func save(){let p=profiles.first ?? BabyProfile();if profiles.isEmpty{context.insert(p)};p.name=name;p.birthDate=hasBirth ? birth:nil;p.dueDate=hasDue ? due:nil;dismiss()}
}
