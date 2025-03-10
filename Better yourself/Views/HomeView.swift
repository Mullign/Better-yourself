//
//  ContentView.swift
//  Better yourself
//
//  Created by No Name Society  on 3/10/25.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        
        TabView {
            
            TodayView()
                .tabItem {
                    Text("Today")
                    Image(systemName: "calendar")
                }
            
            
            ThingsView()
                .tabItem {
                    Text("Things")
                    Image(systemName: "heart")
                }
            
            RemindersView()
                .tabItem {
                    Text("Reminders")
                    Image(systemName: "bell")
                }
            
            SettingsView()
                .tabItem {
                    Text("Settings")
                    Image(systemName: "gearshape")
                }
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
