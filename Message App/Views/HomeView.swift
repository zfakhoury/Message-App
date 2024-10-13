//
//  HomeView.swift
//  Message App
//
//  Created by Zouhair Fakhoury on 13/10/2024.
//

import SwiftUI
import FirebaseAuth

enum AuthMode {
    case logingIn
    case signingUp
}

struct HomeView: View {
    @State private var isPresented: Bool = false
    @State private var authMode: AuthMode = .logingIn
    
    var body: some View {
        TabView {
            NavigationStack {
                List {
                    Text("Message 1")
                    Text("Message 2")
                    Text("Message 3")
                }
                .toolbar {
                    ToolbarItem {
                        Button {
                            isPresented.toggle()
                        } label: {
                            Image(systemName: "person.crop.circle")
                                .foregroundStyle(Color.primary)
                                .font(.system(size: 26))
                        }
                    }
                }
                .sheet(isPresented: $isPresented) {
                    if Auth.auth().currentUser == nil {
                        SetupAccountView(authMode: $authMode)
                    } else {
                        UserProfileView()
                    }
                }
                .navigationTitle("Chats")
            }
            .tabItem {
                Image(systemName: "message.fill")
                Text("Messages")
            }
            
            Rectangle().fill(.background)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        
    }
}

#Preview {
    HomeView()
}

