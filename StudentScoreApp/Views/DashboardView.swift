//
//  DashboardView.swift
//  StudentScoreApp
//
//  Created by 한지웅 on 4/3/25.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @State private var showExercise = false
    @State private var showHighscore = false
    @State private var showProfile = false

    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else {
                    Text("Welcome, \(viewModel.userName)")
                        .font(.title)
                        .padding(.top, 40)

                    Button(action: {
                        showExercise = true
                    }) {
                        Text("Start Exercise")
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }

                    Button(action: {
                        showHighscore = true
                    }) {
                        Text("View Highscores")
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }

                    Button(action: {
                        showProfile = true
                    }) {
                        Text("Profile")
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }

                Spacer()
            }
            .onAppear {
                viewModel.fetchUserName()
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showExercise) {
                ExerciseView()
            }
            .sheet(isPresented: $showHighscore) {
                HighscoreView()
            }
            .sheet(isPresented: $showProfile) {
                ProfileView()            
            }
        }
    }
}

#Preview {
    DashboardView()
}
