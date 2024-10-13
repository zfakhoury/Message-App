//
//  SaveUserInfo.swift
//  Message App
//
//  Created by Zouhair Fakhoury on 13/10/2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct SetupUserProfileView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var selectedTab: Int
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var bio: String = ""
    @State private var picURL: String = ""
    
    @State private var message: String = ""
    @State private var messageColor: Color = .red
    
    let reference = Database.database(url: "https://message-app-227d8-default-rtdb.europe-west1.firebasedatabase.app/").reference()
    
    var body: some View {
        VStack {
            Text("Tell us about yourself")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                AsyncImage(url: URL(string: picURL)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 75, height: 75)
                            .clipShape(Circle())
                    case .failure:
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 75, height: 75)
                            .foregroundStyle(.primary.opacity(0.8))
                            .background(Circle().fill(.background))
                    case .empty:
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .foregroundStyle(.primary.opacity(0.8))
                            .clipShape(Circle())
                            .background(Circle().fill(.background))
                    @unknown default:
                        EmptyView()
                    }
                }
                
                
                TextField("Profile Picture URL", text: $picURL)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .padding(.horizontal)
                    .padding(.vertical, 7)
                
            }
            .padding(.bottom)
            
            TextField("Your first name...", text: $firstName)
                .autocorrectionDisabled()
                .padding(.horizontal)
                .padding(.vertical, 7)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                )
            
            TextField("Your first name...", text: $lastName)
                .autocorrectionDisabled()
                .padding(.horizontal)
                .padding(.vertical, 7)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                )
            
            TextEditor(text: $bio)
                .frame(maxHeight: 150)
                .padding(.horizontal)
                .padding(.vertical, 7)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                )
                .overlay {
                    if bio == "" {
                        Text("Profile bio...")
                            .foregroundStyle(Color.gray.opacity(0.5))
                            .padding()
                            .offset(x: 3)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    }
                }
                .padding(.bottom)
            
            Text(message)
                .foregroundStyle(messageColor)
                .padding(.bottom)
            
            
            Button {
                if firstName != "" && lastName != "" {
                    var newUser = User(bio: bio, firstName: firstName, lastName: lastName, picURL: picURL)
                    
                    if let currentUser = Auth.auth().currentUser {
                        let uid = currentUser.uid
                        reference.child("users/\(uid)").setValue([
                            "bio": newUser.bio,
                            "firstName": newUser.firstName,
                            "lastName": newUser.lastName,
                            "picURL": newUser.picURL,
                        ])
                    }
                    
                    resetUser(user: &newUser)
                    dismiss()
                    selectedTab = 0
                } else {
                    message = "Please fill out at least your first and last name."
                }
                
            } label: {
                Text("Envoyer")
                    .foregroundStyle(Color.white)
                    .bold()
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 25).fill(Color.blue))
        }
        .padding()
    }
    
    private func resetUser(user: inout User) {
        user = User(
            bio: "",
            firstName: "",
            lastName: "",
            picURL: ""
        )
    }
}


#Preview {
    SetupUserProfileView(selectedTab: .constant(1))
}
