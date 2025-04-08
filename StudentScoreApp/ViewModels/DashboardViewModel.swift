//
//  DashboardViewModel.swift
//  StudentScoreApp
//
//  Created by 한지웅 on 4/8/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class DashboardViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var isLoading = true

    func fetchUserName() {
        guard let uid = Auth.auth().currentUser?.uid else {
            self.userName = "Guest"
            self.isLoading = false
            return
        }

        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            DispatchQueue.main.async {
                if let data = snapshot?.data(), let name = data["name"] as? String {
                    self.userName = name.isEmpty ? "User" : name
                } else {
                    self.userName = "User"
                }
                self.isLoading = false
            }
        }
    }
}
