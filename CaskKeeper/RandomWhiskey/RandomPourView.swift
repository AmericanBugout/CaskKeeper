//
//  RandomPourView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 8/29/24.
//
import SwiftUI

import SwiftUI

struct DotProgressView: View {
    let progress: Double
    let numberOfDots: Int
    let dotSize: CGFloat
    let dotSpacing: CGFloat
    let dotColor: Color
    let trackColor: Color
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let dotWidth = dotSize + dotSpacing
            let progressWidth = min(width * CGFloat(progress), width)
            
            HStack(spacing: dotSpacing) {
                ForEach(1..<10) { index in
                    Circle()
                        .fill(CGFloat(index) * dotWidth <= progressWidth ? dotColor : trackColor)
                        .frame(width: dotSize, height: dotSize)
                        .scaleEffect(CGFloat(index) * dotWidth <= progressWidth ? 1 : 0.7)
                        .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: progress)
                }
            }
            .frame(width: width, height: height)
        }
    }
}

struct RandomPourView: View {
    @State private var isCounting = false
    @State private var showMessage = false
    @State private var progress: Double = 0
    @State private var totalTime: Double = 0
    @State private var elapsedTime: Double = 0
    @State private var canRestart = false
    @State private var randomWhiskeyLabel = ""
    @State private var randomWhiskeyBottle = ""

    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @Environment(\.whiskeyLibrary) private var whiskeyLibrary

    var body: some View {
        ZStack {
            VStack {
                Text("What are you drinking?")
                    .font(.customBold(size: 26))
                    .padding()
                    .padding(.top, 30)
                

                Text("Tapping below will randomly select a whiskey from your open bottles.")
                    .multilineTextAlignment(.center)
                    .font(.customRegular(size: 18))
                    .padding(.top, 30)
                    .padding(.horizontal, 30)
                
                if isCounting {
                    DotProgressView(
                        progress: progress,
                        numberOfDots: 5,
                        dotSize: 10,
                        dotSpacing: 10,
                        dotColor: .yellow,
                        trackColor: .gray.opacity(0.2)
                    )
                    .frame(height: 20)
                    .transition(.opacity)
                    .padding(.top, 100)
                } else if showMessage {
                    Text(randomWhiskeyLabel)
                        .font(.customBold(size: 18))
                        .scaleEffect(showMessage == true ? 1 : 0.8)
                        .opacity(showMessage == true ? 1 : 0)
                        .animation(.smooth(duration: 4), value: showMessage == true)
                        .padding(.top, 50)
                        .foregroundStyle(.regularGreen)
                    
                    Text(randomWhiskeyBottle)
                        .font(.customLight(size: 16))
                        .scaleEffect(showMessage == true ? 1 : 0.8)
                        .opacity(showMessage == true ? 1 : 0)
                        .animation(.smooth(duration: 4), value: showMessage == true)
                        .foregroundStyle(.aluminum)
                } else {
                    Button(action: startTimer) {
                        Text("Get Whiskey")
                            .font(.customRegular(size: 18))
                            .foregroundStyle(Color.accentColor)
                            .padding(10)
                            .background(.regularMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.top, 50)
                }

                Spacer()
            }
        }
        .onReceive(timer) { _ in
            if isCounting {
                elapsedTime += 0.1
                progress = elapsedTime / totalTime
                
                if progress >= 1 {
                    withAnimation(.interpolatingSpring) {
                        if let (bottleLabel, bottle)  = self.whiskeyLibrary.getRandomWhiskey(state: .opened) {
                            self.randomWhiskeyLabel = bottleLabel
                            self.randomWhiskeyBottle = bottle
                        }
                        isCounting = false
                        showMessage = true
                        canRestart = true
                    }
                    
                }
            }
        }
        .onDisappear {
            resetTimer()
        }
    }

    func startTimer() {
        if !isCounting && !showMessage {
            isCounting = true
            progress = 0
            elapsedTime = 0
            totalTime = Double.random(in: 1...10)
            canRestart = false
        }
    }

    func restartTimer() {
        if showMessage {
            showMessage = false
            startTimer()
        }
    }

    func resetTimer() {
        isCounting = false
        showMessage = false
        progress = 0
        elapsedTime = 0
        totalTime = 0
        canRestart = false
    }
}

#Preview {
    RandomPourView()
}
