//
//  ExerciseViewModel.swift
//  StudentScoreApp
//
//  Created by 한지웅 on 4/3/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct QuizQuestion {
    let text: String
    let choices: [String]
    let answer: String
}

class ExerciseViewModel: ObservableObject {
    @Published var questions: [QuizQuestion] = []
    @Published var currentIndex = 0
    @Published var selectedAnswer: String? = nil
    @Published var score = 0
    @Published var showResult = false
    @Published var isLoading = true

    var currentQuestion: QuizQuestion {
        questions[currentIndex]
    }

    func loadQuestions() {
        let db = Firestore.firestore()
        db.collection("questions").getDocuments { snapshot, error in
            DispatchQueue.main.async {
                if let documents = snapshot?.documents {
                    self.questions = documents.compactMap { doc in
                        let data = doc.data()
                        guard let text = data["text"] as? String,
                              let choices = data["choices"] as? [String],
                              let answer = data["answer"] as? String else {
                            return nil
                        }
                        return QuizQuestion(text: text, choices: choices, answer: answer)
                    }
                    self.isLoading = false
                } else {
                    print("❌ Failed to load questions: \(error?.localizedDescription ?? "Unknown error")")
                    self.isLoading = false
                }
            }
        }
    }

    func selectAnswer(_ answer: String) {
        selectedAnswer = answer
    }

    func goToNextQuestion() {
        if selectedAnswer == currentQuestion.answer {
            score += 1
        }

        if currentIndex + 1 < questions.count {
            currentIndex += 1
            selectedAnswer = nil
        } else {
            saveScoreToFirestore()
            showResult = true
        }
    }

    func saveScoreToFirestore() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userRef = Firestore.firestore().collection("users").document(uid)
        userRef.updateData(["score": score]) { error in
            if let error = error {
                print("❌ Error saving score: \(error.localizedDescription)")
            } else {
                print("✅ Score saved")
            }
        }
    }
    
    func reset() {
        currentIndex = 0
        selectedAnswer = nil
        score = 0
        showResult = false
        isLoading = true
        questions = []
    }
}
