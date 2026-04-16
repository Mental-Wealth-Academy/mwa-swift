import SwiftUI

struct StreakCalendarView: View {
    let completedDates: Set<String>
    @State private var displayMonth: Date = {
        let cal = Calendar.current
        return cal.date(from: cal.dateComponents([.year, .month], from: Date()))!
    }()

    private let calendar = Calendar.current
    private let weekdayLabels = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]

    var body: some View {
        VStack(spacing: 16) {
            // Month header
            HStack {
                Text(displayMonth, format: .dateTime.month(.wide).year())
                    .font(.headline(16))
                    .foregroundStyle(Color.textPrimary)

                Spacer()

                HStack(spacing: 0) {
                    monthNavButton(direction: -1)
                    monthNavButton(direction: 1)
                }
            }

            // Stats row
            HStack(spacing: 20) {
                calendarStat(value: "\(monthlyCount)", label: "days practiced")
                calendarStat(value: "\(completedDates.count)", label: "total entries")
                Spacer()
            }

            // Weekday labels
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 6) {
                ForEach(weekdayLabels, id: \.self) { label in
                    Text(label)
                        .font(.body(11, weight: .medium))
                        .foregroundStyle(Color.textMuted)
                        .frame(maxWidth: .infinity)
                }

                // Day cells
                ForEach(calendarDays, id: \.dateKey) { day in
                    DayCellView(day: day)
                }
            }

            // Legend
            HStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.academyBlue)
                    .frame(width: 14, height: 14)
                Text("Morning pages completed")
                    .font(.body(12))
                    .foregroundStyle(Color.textMuted)
                Spacer()
            }
        }
        .padding(16)
        .background(Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Helpers

    private var monthlyCount: Int {
        calendarDays.filter { $0.inMonth && $0.completed }.count
    }

    private var calendarDays: [CalendarDay] {
        guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: displayMonth)) else { return [] }
        let firstWeekday = calendar.component(.weekday, from: monthStart) - 1
        guard let gridStart = calendar.date(byAdding: .day, value: -firstWeekday, to: monthStart) else { return [] }

        return (0..<35).map { offset -> CalendarDay in
            let date = calendar.date(byAdding: .day, value: offset, to: gridStart)!
            let key = dateKey(date)
            return CalendarDay(
                date: date,
                dateKey: key,
                inMonth: calendar.isDate(date, equalTo: displayMonth, toGranularity: .month),
                completed: completedDates.contains(key),
                isToday: calendar.isDateInToday(date)
            )
        }
    }

    private func dateKey(_ date: Date) -> String {
        let comps = calendar.dateComponents([.year, .month, .day], from: date)
        return String(format: "%04d-%02d-%02d", comps.year!, comps.month!, comps.day!)
    }

    private func monthNavButton(direction: Int) -> some View {
        Button {
            if let next = calendar.date(byAdding: .month, value: direction, to: displayMonth) {
                displayMonth = next
            }
        } label: {
            Image(systemName: direction < 0 ? "chevron.left" : "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.textSecondary)
                .frame(width: 32, height: 32)
        }
    }

    private func calendarStat(value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(.headline(20))
                .foregroundStyle(Color.textPrimary)
            Text(label)
                .font(.body(11))
                .foregroundStyle(Color.textMuted)
        }
    }
}

struct CalendarDay {
    let date: Date
    let dateKey: String
    let inMonth: Bool
    let completed: Bool
    let isToday: Bool
}

struct DayCellView: View {
    let day: CalendarDay

    var body: some View {
        ZStack {
            if day.completed {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.academyBlue)
            } else if day.isToday {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.academyBlue, lineWidth: 1.5)
            }

            Text("\(Calendar.current.component(.day, from: day.date))")
                .font(.body(12, weight: day.isToday ? .semibold : .regular))
                .foregroundStyle(
                    day.completed ? .white :
                    day.inMonth ? Color.textPrimary :
                    Color.textMuted.opacity(0.4)
                )
        }
        .frame(height: 34)
    }
}
