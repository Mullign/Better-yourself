//
//  TodayView.swift
//  A Better Day Workshop
//
//  Created by Chris Ching on 2024-10-06.
//

import SwiftUI
import SwiftData

struct TodayView: View {
    
    @Environment(\.modelContext) private var context
    
    @Binding var selectedTab: Tab
    
    @Query(filter: Day.currentDayPredicate(),
           sort: \.date) private var today: [Day]
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Text("Today")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth:.infinity, alignment: .leading)
            
            Text("Try to do things that make you feel positive today.")
                .frame(maxWidth:.infinity, alignment: .leading)
            
            // Only display the list if there are things done today
            if getToday().things.count > 0 {
                List(getToday().things) { thing in
                    
                    Text(thing.title)
                }
                .listStyle(.plain)
            }
            else {
                // TODO: Display the image and some tool tips
                Spacer()
                Image("today")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 300)
                
                ToolTipView(text: "Take a little time out of your busy day and do something that recharges you. Hit the log button below to start!")
                    
                Button {
                    // Switch to Things tab
                    selectedTab = Tab.things
                } label: {
                    Text("Log")
                }
                .buttonStyle(.borderedProminent)

                
                
                Spacer()
            }
            
            
        }
    }
    
    func getToday() -> Day {
        
        // Try to retrieve today from the database
        if today.count > 0 {
            return today.first!
        }
        else {
            // If it doesn't exist, create a day and insert it
            let today = Day()
            context.insert(today)
            try? context.save()
            
            return today
        }
        
    }
}

#Preview {
    TodayView(selectedTab: Binding.constant(Tab.today))
}

