//
//  SignupView.swift
//  StudentScoreApp
//
//  Created by 한지웅 on 4/3/25.
//

import SwiftUI

struct SignupView: View {
    @ObservedObject var authVM: AuthViewModel
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 시스템 백버튼 자동 사용
            Text("Sign Up")
                .font(.largeTitle.bold())
                .padding(.top, 32)
                .padding(.horizontal, 24)

            // 입력 필드
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    TextField("Name", text: $name)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                    Divider().padding(.horizontal, 8)
                }

                VStack(spacing: 8) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                    Divider().padding(.horizontal, 8)
                }

                VStack(spacing: 8) {
                    SecureField("Password", text: $password)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                }
            }
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal, 24)
            .padding(.top, 32)

            Button {
                authVM.signUp(name: name, email: email, password: password) { success in
                    if success {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            } label: {
                Text("Create Account")
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 24)
            }
            .padding(.top, 48)

            Spacer()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    let mockVM: AuthViewModel = {
        let vm = AuthViewModel()
        vm.isSignedIn = false
        return vm
    }()
    
    return SignupView(authVM: mockVM)
}

