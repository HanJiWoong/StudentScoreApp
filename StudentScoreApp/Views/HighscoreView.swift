//
//  HighscoreView.swift
//  StudentScoreApp
//
//  Created by 한지웅 on 4/3/25.
//

import SwiftUI

struct HighscoreView: View {
    @StateObject private var viewModel = HighscoreViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading highscores...")
                        .padding()
                } else if viewModel.topScores.isEmpty {
                    Text("No highscores available.")
                        .foregroundColor(.gray)
                } else {
                    List(viewModel.topScores) { user in
                        HStack {
                            Text(user.name)
                            Spacer()
                            Text("\(user.score)")
                                .bold()
                        }
                        .padding(.vertical, 4)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Highscores")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchHighscores()
            }
        }
    }
}

#Preview {
    HighscoreView()
}
