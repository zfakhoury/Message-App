//
//  UserProfileView.swift
//  Message App
//
//  Created by Zouhair Fakhoury on 13/10/2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct UserProfileView: View {
    @Environment(\.dismiss) var dismiss
    let currentUser = Auth.auth().currentUser
    let reference = Database.database(url: "https://message-app-227d8-default-rtdb.europe-west1.firebasedatabase.app/").reference()
    
    @State var user = User(
        bio: "",
        firstName: "",
        lastName: "",
        picURL: ""
    )
    
    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    Ellipse()
                        .fill(LinearGradient(colors: [.yellow, .green], startPoint: .bottomLeading, endPoint: .bottomTrailing))
                        .offset(y: -100)
                        .frame(width: 500, height: 200)
                    
                    
                    
                    AsyncImage(url: URL(string: user.picURL)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 125, height: 125)
                                .clipShape(Circle())
                        case .failure:
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 125, height: 125)
                                .foregroundStyle(.primary.opacity(0.8))
                                .background(Circle().fill(.background))
                        case .empty:
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 125, height: 125)
                                .foregroundStyle(.primary.opacity(0.8))
                                .clipShape(Circle())
                                .background(Circle().fill(.background))
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                
                Text("\(user.firstName) \(user.lastName)")
                    .font(.title).bold()
                Text(currentUser?.email ?? "No email")
                    .font(.title3)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("About Me")
                        .font(.title2).bold()
                    Text(user.bio == "" ? "No bio" : user.bio)
                }
                .padding()
                .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
                
                Button {
                    do {
                        try Auth.auth().signOut()
                        print("Déconnexion réussie")
                        dismiss()
                    } catch {
                        print("Erreur s'est produtie")
                    }
                } label: {
                    HStack {
                        Image(systemName: "person.crop.circle.fill.badge.xmark")
                            .font(.title)
                            .foregroundStyle(.white)
                        
                        Text("Se déconnecter")
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
                    .padding(.vertical, 7)
                    .padding(.horizontal)
                    .background(Color.red.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                    .shadow(radius: 5)
                }
                .padding()
            }
            .onAppear {
                Task {
                    do {
                        if let currentUser {
                            let uid = currentUser.uid
                            let snapshot = try await reference.child("users/\(uid)").getData()
                            
                            print(snapshot.value ?? "No Data")
                            
                            if let data = snapshot.value {
                                // Any -> Data
                                let jsonData = try JSONSerialization.data(withJSONObject: data)
                                // Data -> User
                                let currentUserData = try JSONDecoder().decode(User.self, from: jsonData)
                                user = currentUserData
                            } else {
                                print("User not found.")
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

#Preview {
    UserProfileView()
}
