//
//  ContentView.swift
//  Message App
//
//  Created by Zouhair Fakhoury on 07/10/2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct SigningUp: View {
    @Binding var authMode: AuthMode
    @Binding var selectedTab: Int

    @State private var email = ""
    @State private var password = ""
    @State private var passwordConfirmation = ""
    @State private var message = ""
    @State private var messageColor = Color.red
    
    let reference = Database.database(url: "https://message-app-227d8-default-rtdb.europe-west1.firebasedatabase.app/")
        .reference()
    
    var body: some View {
        VStack(spacing: 8) {
            authFields
            feedbackMessage
            confirmationButton
            switchButton
        }
        .padding()
    }
    
    private var authFields: some View {
        VStack {
            Text(authMode == .signingUp ? "Créer un compte" : "Se connecter")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Image(systemName: "at")
                    .foregroundStyle(Color.gray)
                TextField(text: $email) {
                    Text(verbatim: "your@email.com")
                }
                .autocorrectionDisabled()
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            }
            .padding(.horizontal)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)
            )
            
            HStack {
                Image(systemName: "lock")
                    .foregroundStyle(Color.gray)
                SecureField(text: $password) {
                    Text(verbatim: "Password")
                }
                
            }
            .padding(.horizontal)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)
            )
            
            if authMode == .signingUp {
                HStack {
                    Image(systemName: "lock")
                        .foregroundStyle(Color.gray)
                    SecureField(text: $passwordConfirmation) {
                        Text(verbatim: "Confirm Password")
                    }
                    
                }
                .padding(.horizontal)
                .padding(.vertical, 7)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(password != passwordConfirmation ? Color.red : Color.gray.opacity(0.3), lineWidth: 2)
                )
            }
        }
    }
    
    private var confirmationButton: some View {
        Button {
            Task {
                switch self.authMode {
                case .logingIn:
                    await login()
                case .signingUp:
                    await signup()
                }
            }
            
        } label: {
            Text(authMode == .logingIn ? "Se connecter" : "S'inscrire")
                .bold()
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color.white)
                .background(RoundedRectangle(cornerRadius: 25))
        }
        
    }
    
    private var feedbackMessage: some View {
        Text(message)
            .foregroundStyle(messageColor)
    }
    
    private var switchButton: some View {
        Button {
            switch authMode {
            case .logingIn:
                self.authMode = .signingUp
            case .signingUp:
                self.authMode = .logingIn
            }
        } label: {
            switch authMode {
            case .logingIn:
                Text("Pas encore de compte ? S'inscrire !")
            case .signingUp:
                Text("Déjà un compte ? Se connecter !")
            }
        }
        .padding(.vertical)
    }
    
    // MARK: Private Methods
    private func signup() async {
        guard password == passwordConfirmation else {
            messageColor = .red
            message = "Password must match"
            return
        }
        
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            message = "User created: \(authResult.user.email ?? "No email")"
            messageColor = .green
            selectedTab = 1
        } catch {
            message = error.localizedDescription
            messageColor = .red
        }
    }
    
    private func login() async {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            message = "User logged in: \(authResult.user.email ?? "No email")"
            messageColor = .green
        } catch {
            message = error.localizedDescription
            messageColor = .red
        }
    }
}

#Preview {
    SigningUp(authMode: .constant(AuthMode.logingIn), selectedTab: .constant(0))
}
