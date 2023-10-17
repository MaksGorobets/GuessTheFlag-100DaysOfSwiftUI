//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Maks Winters on 14.10.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var countiesFlags = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Spain", "Ukraine", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var alertIsPresented = false
    @State private var finalAlertIsPresented = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var gamesCount = 0
    @Environment (\.colorScheme) var colorScheme
    
    var body: some View {
            ZStack {
                RadialGradient(colors: backgroundColors(), center: .center, startRadius: 10, endRadius: 800)
                    .ignoresSafeArea()
                VStack {
                    Text("Guess The Flag")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                    Text("Score \(score)")
                        .foregroundStyle(.white)
                    Spacer()
                VStack(spacing: 30) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.white)
                        Text(countiesFlags[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                            .foregroundStyle(.white)
                    }
                    ForEach(0..<3) {number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countiesFlags[number])
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(radius: 5)
                        }
                    }
                }
                .padding(50)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                    Spacer()
            }
        }
        .alert(scoreTitle, isPresented: $alertIsPresented) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert(scoreTitle, isPresented: $finalAlertIsPresented) {
            Button("New Game", action: reset)
        } message: {
            Text("Final score: \(score)")
        }
    }
    
    func backgroundColors() -> [Color] {
        if colorScheme == .dark {
            return [.red, .black]
        } else {
            return [.blue, .black]
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 25
        } else {
            scoreTitle = "Wrong! That's the flag of \(countiesFlags[number])"
            if score > 25 {
                score -= 25
            } else {
                score = 0
            }
        }
        gamesCount += 1
        if gamesCount >= 8 {
            scoreTitle = "The game is over"
            finalAlertIsPresented = true
        }
        alertIsPresented = true
    }
    func askQuestion() {
        countiesFlags.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    func reset() {
        score = 0
        gamesCount = 0
        askQuestion()
    }
}

#Preview {
    ContentView()
}
