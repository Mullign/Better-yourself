//
//  TodayView.swift
//  Better yourself
//
//  Created by No Name Society  on 3/10/25.
//

import SwiftUI
import SwiftData

struct TodayView: View {
    
    @Environment(\.modelContext) private var context
    
    @Query(filter: Day.currentDayPredicate(),
           sort: \.date) private var today: [Day]
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            Text("Today")
                .font(.largeTitle)
                .bold()
            
            Text("Try Today to do things that make you happy!")
            
            // Diplsay list if things are done today
            if getToday().things.count > 0 {
                List(getToday().things) { thing in
                    
                    Text(thing.title) 
                }
                .listStyle(.plain)
            }
            else{
                // TODO: Display the image and some tool tips
            }
            
            
        }
    }
    
    func getToday() -> Day  {
        
        //Retrieve today from data base
        if today.count > 0 {
            return today.first!
        }
        else {
            // If it doesnt exist, create and insert it
            let today = Day()
            context.insert(today)
            try? context.save()
            
            return today
        }
    }
}

#Preview {
    TodayView()
}
