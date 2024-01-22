//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Maks Winters on 14.10.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State public var countiesFlags = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Spain", "Ukraine", "UK", "US"].shuffled()
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes. Top stripe blue, middle stripe black, bottom stripe white.",
        "France": "Flag with three vertical stripes. Left stripe blue, middle stripe white, right stripe red.",
        "Germany": "Flag with three horizontal stripes. Top stripe black, middle stripe red, bottom stripe gold.",
        "Ireland": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe orange.",
        "Italy": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe red.",
        "Nigeria": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe green.",
        "Poland": "Flag with two horizontal stripes. Top stripe white, bottom stripe red.",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red.",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background.",
        "Ukraine": "Flag with two horizontal stripes. Top stripe blue, bottom stripe yellow.",
        "US": "Flag with many red and white stripes, with white stars on a blue background in the top-left corner."
    ]
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var alertIsPresented = false
    @State private var finalAlertIsPresented = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var gamesCount = 0
    
    @State private var selectedFlag = [false, false, false]
    @State private var opacityApplied = [true, true, true]
    
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
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            selectedFlag[number] = true
                        } label: {
                            FlagView(country: countiesFlags[number])
                        }
                        .accessibilityLabel(labels[countiesFlags[number], default: "Unknown"])
                        .rotation3DEffect(
                            .degrees(selectedFlag[number] ? 360 : 0), axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                        .opacity(opacityApplied[number] ? 1 : 0.5)
                        .scaleEffect(opacityApplied[number] ? 1 : 0.5)
                        .animation(.bouncy, value: opacityApplied)
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
        
        opacityApplied = invertArray(array: opacityApplied)
        opacityApplied[correctAnswer] = true
        
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
        opacityApplied = [true, true, true]
        selectedFlag = [false, false, false]
        countiesFlags.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    func reset() {
        score = 0
        gamesCount = 0
        askQuestion()
    }
    
    func invertArray(array: Array<Bool>) -> Array<Bool> {
        
        var returnArray: Array<Bool> = []
        
        for index in array {
            if index == false {
                returnArray.append(true)
            } else {
                returnArray.append(false)
            }
        }
        return returnArray
    }
}

struct FlagView: View {
    
    var country: String
    
    var body: some View {
        Image(country)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 5)
    }
}

#Preview {
    ContentView()
}
