//
//  ProfileView.swift
//  StudentScoreApp
//
//  Created by 한지웅 on 4/3/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                if authVM.isProfileLoading {
                    ProgressView("Loading profile...")
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)

                    Text(authVM.profileName)
                        .font(.title2)
                        .bold()

                    Text(authVM.profileEmail)
                        .foregroundColor(.gray)

                    Button("Log Out") {
                        authVM.signOut()
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.top, 40)
                    .padding(.horizontal)

                    Spacer()
                }
            }
            .padding()
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                authVM.loadUserProfile()
            }
        }
    }
}

#Preview {
    ProfileView().environmentObject(AuthViewModel())
}

