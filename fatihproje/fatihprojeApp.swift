//
//  fatihprojeApp.swift
//  fatihproje
//
//  Created by Trakya14 on 11.05.2025.
//

import SwiftUI

@main
struct fatihprojeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
