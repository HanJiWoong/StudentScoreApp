//
//  AuthViewModel.swift
//  StudentScoreApp
//
//  Created by 한지웅 on 4/3/25.
//

import Foundation
import AuthenticationServices
import CryptoKit
import FirebaseAuth
import SwiftUI
import FirebaseFirestore

class AuthViewModel: NSObject, ObservableObject {
    @Published var isSignedIn = false
    @Published var isLoading = false
    @Published var errorMessage: String?

    @Published var profileName: String = ""
    @Published var profileEmail: String = ""
    @Published var isProfileLoading: Bool = true

    
    private var currentNonce: String?
    private let db = Firestore.firestore()
    
    override init() {
        super.init()
        checkIfUserIsSignedIn()
    }

    func checkIfUserIsSignedIn() {
        isSignedIn = Auth.auth().currentUser != nil
    }
    
    func signUp(name: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = ""

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                    completion(false)
                } else if let user = result?.user {
                    self.isSignedIn = true
                    self.createUserDocument(uid: user.uid, email: email, name: name)
                    self.isLoading = false
                    completion(true)
                }
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
            } else {
                self.isSignedIn = true
                completion(true)
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            isSignedIn = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func loadUserProfile() {
        guard let user = Auth.auth().currentUser else {
            self.isProfileLoading = false
            return
        }

        self.profileEmail = user.email ?? ""

        let docRef = Firestore.firestore().collection("users").document(user.uid)
        docRef.getDocument { snapshot, error in
            DispatchQueue.main.async {
                if let data = snapshot?.data(), let name = data["name"] as? String {
                    self.profileName = name
                }
                self.isProfileLoading = false
            }
        }
    }
    
    func handleAppleSignIn(result: Result<ASAuthorization, Error>, completion: @escaping (Bool) -> Void) {
        switch result {
        case .success(let auth):
            guard let appleIDCredential = auth.credential as? ASAuthorizationAppleIDCredential else {
                completion(false)
                return
            }

            guard let nonce = currentNonce else {
                completion(false)
                return
            }

            guard let appleIDToken = appleIDCredential.identityToken else {
                completion(false)
                return
            }

            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                completion(false)
                return
            }

            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)

            Auth.auth().signIn(with: credential) { result, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        completion(false)
                    } else if let user = result?.user {
                        self.isSignedIn = true

                        // Save to Firestore only if new user
                        self.db.collection("users").document(user.uid).getDocument { document, error in
                            if let document = document, !document.exists {
                                let rawName = appleIDCredential.fullName?.givenName ?? ""
                                let finalName = rawName.isEmpty ? "User" : rawName

                                self.createUserDocument(uid: user.uid, email: user.email ?? "", name: finalName)
                            }
                        }
                        completion(true)
                    }
                }
            }

        case .failure(let error):
            errorMessage = error.localizedDescription
            completion(false)
        }
    }

    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce

        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    private func createUserDocument(uid: String, email: String, name: String) {
        let userData: [String: Any] = [
            "email": email,
            "name": name,
            "score": 0
        ]

        db.collection("users").document(uid).setData(userData) { error in
            if let error = error {
                print("Failed to save user: \(error.localizedDescription)")
            } else {
                print("User document created")
            }
        }
    }
}

extension AuthViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        UIApplication.shared.windows.first { $0.isKeyWindow } ?? UIWindow()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        handleAppleSignIn(result: .success(authorization)) { _ in }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        handleAppleSignIn(result: .failure(error)) { _ in }
    }
}

// MARK: - Apple SignIn Helpers

private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashed = SHA256.hash(data: inputData)
    return hashed.compactMap { String(format: "%02x", $0) }.joined()
}

private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length

    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
            }
            return random
        }

        randoms.forEach { random in
            if remainingLength == 0 { return }

            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }

    return result
}
