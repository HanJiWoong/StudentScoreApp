//
//  ExerciseView.swift
//  StudentScoreApp
//
//  Created by 한지웅 on 4/3/25.
//

import SwiftUI

struct ExerciseView: View {
    @StateObject private var viewModel = ExerciseViewModel()

    var body: some View {
        VStack(spacing: 24) {
            Text("Question \(viewModel.currentIndex + 1) of \(viewModel.questions.count)")
                .font(.headline)

            Text(viewModel.currentQuestion.text)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding()

            VStack(spacing: 12) {
                ForEach(viewModel.currentQuestion.choices, id: \.self) { choice in
                    Button(action: {
                        viewModel.selectAnswer(choice)
                    }) {
                        HStack {
                            Text(choice)
                                .foregroundColor(.black)
                            Spacer()
                            if viewModel.selectedAnswer == choice {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
            }
            .padding(.horizontal)

            Spacer()

            Button(action: {
                viewModel.goToNextQuestion()
            }) {
                Text(viewModel.currentIndex + 1 == viewModel.questions.count ? "Finish" : "Next")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .disabled(viewModel.selectedAnswer == nil)
        }
        .padding()
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .fullScreenCover(isPresented: $viewModel.showResult) {
            ExerciseResultView(score: viewModel.score, total: viewModel.questions.count)
        }
    }
}

// Placeholder for result view
struct ExerciseResultView: View {
    let score: Int
    let total: Int

    var body: some View {
        VStack(spacing: 24) {
            Text("Your Score")
                .font(.largeTitle.bold())

            Text("\(score) / \(total)")
                .font(.title)

            Button("Done") {
                // dismiss handled by parent
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
    }
}

#Preview {
    ExerciseView()
}

