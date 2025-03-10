//
//  Better_yourselfApp.swift
//  Better yourself
//
//  Created by No Name Society  on 3/10/25.
//

import SwiftUI
import SwiftData

@main
struct Better_yourselfApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .modelContainer(for: [Day.self, Thing.self])
        }
    }
}
