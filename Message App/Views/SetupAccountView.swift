//
//  Test.swift
//  Message App
//
//  Created by Zouhair Fakhoury on 13/10/2024.
//

import SwiftUI

struct SetupAccountView: View {
    @Binding var authMode: AuthMode
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SigningUp(authMode: $authMode, selectedTab: $selectedTab)
                .tabItem {
                    Text("Sign Up")
                }
                .tag(0)
            
            if authMode == .signingUp {
                SetupUserProfileView(selectedTab: $selectedTab)
                    .tabItem {
                        Text("Set Up Profile")
                    }
                    .tag(1)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

#Preview {
    SetupAccountView(authMode: .constant(AuthMode.logingIn))
}
