
import SwiftUI
import SwiftData

struct ThingsView: View {
    
    @Environment(\.modelContext) private var context
    
    @Query(filter: Day.currentDayPredicate(),
           sort: \.date) private var today: [Day]
    
    @Query(filter: #Predicate<Thing> { $0.isHidden == false } ) private var things: [Thing]
    
    @State private var showAddView: Bool = false
    
    var body: some View {
        
        VStack (spacing: 20) {
            
            Text("Things")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("These are the things that make you feel positive and uplifted.")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if things.count == 0 {
                // Image
                Image("Things")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 300)
             
                // Tooltip
                ToolTipView(text: "Start by adding things that brighten your day. Tap the button below to get started!")
            }
            else {
                
                List (things) { thing in
                    
                    let today = getToday()
                    
                    HStack {
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
                            
                            // If this thing is already in Today's things list, show a solid checkmark instead
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
                
            }
                
            Spacer()
            
            Button("Add New Thing") {
                // Show sheet to add thing
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
    ThingsView()
}

