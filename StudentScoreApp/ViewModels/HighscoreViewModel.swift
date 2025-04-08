//
//  ScoreViewModel.swift
//  StudentScoreApp
//
//  Created by 한지웅 on 4/3/25.
//

import Foundation
import FirebaseFirestore

struct UserScore: Identifiable {
    var id: String
    var name: String
    var score: Int
}

class HighscoreViewModel: ObservableObject {
    @Published var topScores: [UserScore] = []
    @Published var isLoading = true

    func fetchHighscores(limit: Int = 20) {
        Firestore.firestore().collection("users")
            .order(by: "score", descending: true)
            .limit(to: limit)
            .getDocuments { snapshot, error in
                DispatchQueue.main.async {
                    if let documents = snapshot?.documents {
                        self.topScores = documents.compactMap { doc in
                            let data = doc.data()
                            let name = data["name"] as? String ?? "Unknown"
                            let score = data["score"] as? Int ?? 0
                            return UserScore(id: doc.documentID, name: name, score: score)
                        }
                    }
                    self.isLoading = false
                }
            }
    }
}
