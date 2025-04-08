//
//  ProfileView.swift
//  StudentScoreApp
//
//  Created by 한지웅 on 4/3/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var isLoading = true

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                if isLoading {
                    ProgressView("Loading profile...")
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)

                    Text(name)
                        .font(.title2)
                        .bold()

                    Text(email)
                        .foregroundColor(.gray)

                    Spacer()
                }
            }
            .padding()
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: loadUserProfile)
        }
    }

    func loadUserProfile() {
        guard let user = Auth.auth().currentUser else { return }
        self.email = user.email ?? ""

        let docRef = Firestore.firestore().collection("users").document(user.uid)
        docRef.getDocument { snapshot, error in
            if let data = snapshot?.data(), let name = data["name"] as? String {
                self.name = name
            }
            self.isLoading = false
        }
    }
}

#Preview {
    ProfileView()
}
