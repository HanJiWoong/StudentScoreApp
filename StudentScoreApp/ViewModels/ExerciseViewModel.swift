//
//  ExerciseViewModel.swift
//  StudentScoreApp
//
//  Created by 한지웅 on 4/3/25.
//

import Foundation

class ExerciseViewModel: ObservableObject {
    @Published var currentIndex = 0
    @Published var selectedAnswer: String? = nil
    @Published var score = 0
    @Published var showResult = false

    let questions: [QuizQuestion] = SampleQuizData.questions

    var currentQuestion: QuizQuestion {
        questions[currentIndex]
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
            showResult = true
        }
    }
}

// Question Model
struct QuizQuestion {
    let text: String
    let choices: [String]
    let answer: String
}

// Sample Data
struct SampleQuizData {
    static let questions: [QuizQuestion] = [
        QuizQuestion(text: "I saw ___ owl in the tree.", choices: ["a", "an", "the", "no article"], answer: "an"),
        QuizQuestion(text: "He bought ___ book yesterday.", choices: ["a", "an", "the", "no article"], answer: "a"),
        QuizQuestion(text: "___ sun rises in the east.", choices: ["a", "an", "the", "no article"], answer: "the"),
        QuizQuestion(text: "She is ___ honest person.", choices: ["a", "an", "the", "no article"], answer: "an"),
        QuizQuestion(text: "They went to ___ beach.", choices: ["a", "an", "the", "no article"], answer: "the"),
        QuizQuestion(text: "___ water is essential for life.", choices: ["a", "an", "the", "no article"], answer: "no article"),
        QuizQuestion(text: "He is ___ university student.", choices: ["a", "an", "the", "no article"], answer: "a"),
        QuizQuestion(text: "Do you want ___ apple?", choices: ["a", "an", "the", "no article"], answer: "an"),
        QuizQuestion(text: "I found ___ wallet on the ground.", choices: ["a", "an", "the", "no article"], answer: "a"),
        QuizQuestion(text: "___ Earth orbits the Sun.", choices: ["a", "an", "the", "no article"], answer: "the")
    ]
}
