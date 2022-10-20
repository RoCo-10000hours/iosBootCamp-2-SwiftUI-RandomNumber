//
//  ContentView.swift
//  UpDown
//
//  Created by Team3 on 2022/10/20.
//

import SwiftUI
import AVFoundation
import AVKit

struct ContentView: View {
    @State private var random = Double.random(in: 1.0...10.0)
    @State private var min = 1.0
    @State private var max = 10.0
    @State private var value: Double = 1.0
    @State private var tryCount: Int = 0
    @State private var showing: Bool = false
    @State private var message: String = "메세지"
    @State private var life: String = "❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️"
    @State private var rotate: Double = 0.0
    @State private var audioPlayer: AVAudioPlayer!
    
    func clear() {
        self.min = 1.0
        self.max = 10.0
        self.random = Double.random(in: 1.0...10.0)
        self.life = "❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️"
    }
    
    func checkUpAndDown() {
        if tryCount > 10 {
            self.message = "횟수를 초과했습니다!"
            showing = true
            clear()
        }
        
        if Int(value) < Int(random) {
            self.min = value
            self.message = "정답은 \(String(format: "%.f", value))보다 큽니다."
            
        } else if Int(value) > Int(random) {
            self.max = value
            self.message = "정답은 \(String(format: "%.f", value))보다 작습니다."
        } else {
            clear()
            self.message = "정답입니다. 자물쇠가 열렸습니다.!"
        }
        
        showing = true
        tryCount += 1
        life.removeLast(1)
        rotate += 10.0
    }
    
    
    var body: some View {
        VStack(spacing: 20.0) {
            Spacer()
            
            AsyncImage(url: URL(string: "https://cdn.pixabay.com/photo/2017/09/16/01/24/heart-2754301_1280.png")) { image in
                image.resizable()
                    .scaledToFit()
                    .rotationEffect(.degrees(rotate))
                    .frame(width: 200, height: 200)
                    .onAppear {
                        withAnimation(.linear(duration: 10.0).repeatForever(autoreverses: false)) {
                            self.rotate += 360.0
                        }
                    }
                
            } placeholder: {
                Image(systemName: "heart")
            }
            
            Spacer()
            
            Text(life)
            
            Spacer()
            
            HStack {
                Text(String(format: "%.f", min))
                Spacer()
                Text(String(format: "%.f", value))
                Spacer()
                Text(String(format: "%.f", max))
            }
            
            Slider(value: $value, in: min...max, step: 1.0)
            
            Button {
                checkUpAndDown()
            } label: {
                AsyncImage(url: URL(string: "https://cdn.pixabay.com/photo/2017/01/31/18/20/heart-2026190_1280.png")) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 50)
                        .padding(8)
                        .border(Color.black)
                } placeholder: {
                    Image(systemName: "heart")
                }
            }

            
            Text("정답을 맞춰 자물쇠를 열어주세요.!🤪")
                .font(.headline)
            
            Spacer()
        }
        .onAppear {
            let sound = Bundle.main.path(forResource: "sound", ofType: "wav")
            self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        }
        .padding()
        .alert(isPresented: $showing) {
            self.audioPlayer.play()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                // 2초 후 실행될 부분
                Siri.speakText(voiceText: message)
            }
            
            return Alert(
                title: Text(message),
                message: Text(""),
                primaryButton: .default(
                    Text("계속하기"),
                    action: {
                        Siri.stopText()
                        audioPlayer.stop()
                    }
                ),
                secondaryButton: .destructive(
                    Text("다시하기"),
                    action: {
                        clear()
                        Siri.stopText()
                    }
                )
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
