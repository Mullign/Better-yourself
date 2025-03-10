//
//  ThingView.swift
//  Better yourself
//
//  Created by No Name Society  on 3/10/25.
//

import SwiftUI
import SwiftData

struct ThingsView: View {
    
    @Environment(\.modelContext) private var context
    
    @Query(filter: Day.currentDayPredicate(), sort: \.date) private var today: [Day]
    
    @Query(filter: #Predicate<Thing> { $0.isHidden == false } ) private var things: [Thing]
    
    @State private var showAddView: Bool = false
    
    var body: some View {
        
        VStack (alignment: .leading, spacing: 20) {
            
            Text("Things")
                .font(.largeTitle)
                .bold()
            
            Text("These are things that make you feel happy")
            
            List (things) { thing in
                
                let today = getToday()
                
                HStack{
                    Text(thing.title)
                    Spacer()
                    
                    Button {
                        
                        if today.things.contains(thing) {
                            // Remove the thing from today
                            today.things.removeAll { t in
                                t == thing
                            }
                            try? context.save()
                        }
                        else {
                            // Add the thing to today
                            today.things.append(thing)
                        }
                        
                        
                    } label: {
                        
                        //If this thing is already in Today's things list show a solic checkmarck instead
                        if today.things.contains(thing) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.blue)
                        }
                        else {
                            Image(systemName: "checkmark.circle")
                        }
                    }
                    
                }
                
            }
            .listStyle(.plain)
            
            Spacer()
            
            Button("Add New Action") {
                // TODO: Show sheet to add thing
                showAddView.toggle()
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
        }
        .sheet(isPresented: $showAddView) {
            AddThingView()
                .presentationDetents([.fraction(0.2)])
        }
        .padding()
        
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
    ThingsView()
}
