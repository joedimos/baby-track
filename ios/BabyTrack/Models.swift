import Foundation
import SwiftData

enum CareType: String, Codable, CaseIterable { case feed, sleep, diaper, pump, tummy, medicine, note }

@Model final class BabyProfile {
    var name: String
    var birthDate: Date?
    var dueDate: Date?
    init(name: String = "", birthDate: Date? = nil, dueDate: Date? = nil) { self.name = name; self.birthDate = birthDate; self.dueDate = dueDate }
}

@Model final class CareEntry {
    var id: UUID
    var typeRaw: String
    var startedAt: Date
    var endedAt: Date?
    var detail: String
    var amount: Double?
    var unit: String
    var durationMinutes: Int?
    var note: String
    var isActive: Bool
    var type: CareType { CareType(rawValue: typeRaw) ?? .note }
    init(type: CareType, startedAt: Date = .now, detail: String = "", amount: Double? = nil, unit: String = "oz", durationMinutes: Int? = nil, note: String = "", isActive: Bool = false) {
        self.id = UUID(); self.typeRaw = type.rawValue; self.startedAt = startedAt; self.detail = detail; self.amount = amount; self.unit = unit; self.durationMinutes = durationMinutes; self.note = note; self.isActive = isActive
    }
}

@Model final class GrowthRecord {
    var id: UUID
    var date: Date
    var weightPounds: Double?
    var lengthInches: Double?
    var headInches: Double?
    var note: String
    init(date: Date = .now, weightPounds: Double? = nil, lengthInches: Double? = nil, headInches: Double? = nil, note: String = "") { self.id = UUID(); self.date = date; self.weightPounds = weightPounds; self.lengthInches = lengthInches; self.headInches = headInches; self.note = note }
}

@Model final class MilestoneRecord {
    var key: String
    var completedAt: Date?
    init(key: String, completedAt: Date? = nil) { self.key = key; self.completedAt = completedAt }
}

extension CareType {
    var title: String { switch self { case .feed:"Feeding"; case .sleep:"Sleep"; case .diaper:"Diaper"; case .pump:"Pumping"; case .tummy:"Tummy time"; case .medicine:"Medicine"; case .note:"Note" } }
    var icon: String { switch self { case .feed:"waterbottle.fill"; case .sleep:"moon.fill"; case .diaper:"cloud.fill"; case .pump:"drop.fill"; case .tummy:"figure.child"; case .medicine:"cross.case.fill"; case .note:"square.and.pencil" } }
}
