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
    @State private var scoreTitle = ""
    @Environment (\.colorScheme) var colorScheme
    
    var body: some View {
            ZStack {
                RadialGradient(colors: backgroundColors(), center: .center, startRadius: 10, endRadius: 800)
                    .ignoresSafeArea()
                VStack {
                    Text("Guess The Flag")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                    Text("Score ???")
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
            Text("Your score is ???")
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
        } else {
            scoreTitle = "Wrong"
        }
        alertIsPresented = true
    }
    func askQuestion() {
        countiesFlags.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

#Preview {
    ContentView()
}
