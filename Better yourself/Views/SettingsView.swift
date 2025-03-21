//
//  SettingsView.swift
//  Better yourself
//
//  Created by No Name Society  on 3/10/25.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        
        VStack (alignment: .leading, spacing: 20) {
            
            Text("Settings")
                .font(.largeTitle)
                .bold()
            
            List {
                
                // Rate the app
                let reviewUrl = URL(string: "https://apps.apple.com/app/id6670766958?action=write-review")!
                
                
                Link(destination: reviewUrl, label: {
                    
                    HStack {
                        Image(systemName: "star.bubble")
                        Text("Rate the app")
                    }
                    
                })
                
                // Recommend the app
                let shareUrl = URL(string: "https://apps.apple.com/app/id6670766958")!
                
                ShareLink(item: shareUrl) {
                    HStack {
                        Image(systemName: "arrowshape.turn.up.right")
                        Text("Recommend the app")
                    }
                    
                }
                
                // Contact
                Button  {
                    // Compose email
                    let mailUrl = createMailUrl()
                    
                    if let mailUrl = mailUrl, UIApplication.shared.canOpenURL(mailUrl) {
                        UIApplication.shared.open(mailUrl)
                    }
                    else {
                        print("Couldn't open mail client")
                    }
                    
                } label: {
                    HStack {
                        Image(systemName: "quote.bubble")
                        Text("Submit feedback")
                    }
                    
                }
                
                
                // Privacy Policy
                let privacyUrl = URL(string: "https://sandy-falcon-7b5.notion.site/Privacy-Policy-1bc21a541cd9801fa97df5b9a3db0916?pvs=4")!
                
                Link(destination: privacyUrl, label: {
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Privacy Policy")
                    }
                })
                
                
            }
            .listRowSeparator(.hidden)
            .listStyle(.plain)
            .tint(.black)
        }
    }
    
    func createMailUrl() -> URL? {
        
        var mailUrlComponents = URLComponents()
        mailUrlComponents.scheme = "mailto"
        mailUrlComponents.path = "johnrussell@mull1gan.com"
        mailUrlComponents.queryItems = [
            URLQueryItem(name: "subject", value: "Feedback for A Better Day")
        ]
        
        return mailUrlComponents.url
    }
    
}

#Preview {
    SettingsView()
}
