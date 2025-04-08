//
//  LoginView.swift
//  StudentScoreApp
//
//  Created by 한지웅 on 4/3/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var authVM = AuthViewModel()
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var goToSignUp = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 12) {
                // 타이틀
                Text("Sign In")
                    .font(.largeTitle.bold())
                    .padding(.top, 32)
                    .padding(.horizontal, 24)

                // 입력 박스
                VStack(spacing: 0) {
                    VStack(spacing: 8) {
                        TextField("Email", text: $email)
                            .autocapitalization(.none)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .padding(.top, 8)
                        Divider()
                            .padding(.horizontal, 16)
                    }

                    VStack(spacing: 8) {
                        SecureField("Password", text: $password)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .padding(.top, 8)
                            .padding(.bottom, 12)
                    }
                }
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal, 24)
                .padding(.top, 32)

                // Sign up 텍스트
                Button {
                    goToSignUp = true
                } label: {
                    Text("Don't have an account? Sign up")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 24)
                }
                .padding(.top, 48)

                // 로그인 버튼
                Button {
                    authVM.signIn(email: email, password: password) { _ in }
                } label: {
                    Text("Sign In")
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 24)
                }
                
                AppleSignInButton()
                    .frame(height: 48)
                    .padding(.horizontal, 24)
                    .onTapGesture {
                        authVM.startSignInWithAppleFlow()
                    }

                Spacer()

                // SignupView로 이동
                NavigationLink(destination: SignupView(authVM: authVM), isActive: $goToSignUp) {
                    EmptyView()
                }
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationBarHidden(true)
        }
        // DashboardView로 이동
        .fullScreenCover(isPresented: $authVM.isSignedIn) {
            DashboardView()
        }
    }
}


#Preview {
    LoginView()
}
