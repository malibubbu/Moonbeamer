//
//  SleepDataView.swift
//  Moonbeamer
//
//  Created by Gianluca de Bache on 01.12.23.
//

import SwiftUI

// Model für Schlafdaten
struct SleepData: Identifiable {
    var id = UUID()
    var date: Date
    var hoursSlept: Double
}

// ViewModel zum Verwalten von Schlafdaten
class SleepViewModel: ObservableObject {
    @Published var sleepEntries: [SleepData] = []

    func addSleepEntry(date: Date, hoursSlept: Double) {
        let newEntry = SleepData(date: date, hoursSlept: hoursSlept)
        sleepEntries.append(newEntry)
    }
}

// SwiftUI-Ansicht zur Eingabe von Schlafdaten
struct SleepEntryView: View {
    @State private var date = Date()
    @State private var hoursSlept = 7.0

    @ObservedObject var sleepViewModel: SleepViewModel

    var body: some View {
        Form {
            Section(header: Text("Sleep Entry")) {
                DatePicker("Date", selection: $date, displayedComponents: [.date])
                Stepper(value: $hoursSlept, in: 1...24, step: 0.5) {
                    Text("Hours Slept: \(hoursSlept, specifier: "%.1f")")
                }
            }

            Section {
                Button("Add Sleep Entry") {
                    sleepViewModel.addSleepEntry(date: date, hoursSlept: hoursSlept)
                    // Hier könnten Sie die Daten in einer Datenbank speichern oder anderweitig verarbeiten.
                }
            }
        }
    }
}

// SwiftUI-Ansicht zur Anzeige von Schlafdaten
struct SleepDataView: View {
    @ObservedObject var sleepViewModel: SleepViewModel

    var body: some View {
        NavigationView {
            List(sleepViewModel.sleepEntries) { entry in
                VStack(alignment: .leading) {
                    Text("Date: \(entry.date, formatter: dateFormatter)")
                    Text("Hours Slept: \(entry.hoursSlept, specifier: "%.1f")")
                }
            }
            .navigationTitle("Sleep Data")
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}

//struct ContentView: View {
//    @StateObject var sleepViewModel = SleepViewModel()
//
//    var body: some View {
//        TabView {
//            SleepEntryView(sleepViewModel: sleepViewModel)
//                .tabItem {
//                    Image(systemName: "bed.double.fill")
//                    Text("Track Sleep")
//                }
//
//            SleepDataView(sleepViewModel: sleepViewModel)
//                .tabItem {
//                    Image(systemName: "list.bullet")
//                    Text("Sleep Data")
//                }
//        }
//    }
//}
