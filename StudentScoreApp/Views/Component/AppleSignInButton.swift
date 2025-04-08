//
//  AppleSignInButton.swift
//  StudentScoreApp
//
//  Created by 한지웅 on 4/8/25.
//

import SwiftUI
import AuthenticationServices

struct AppleSignInButton: UIViewRepresentable {
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    }

    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) { }
}
