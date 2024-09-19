//
//  QuizView.swift
//  Bona Puzzle Land
//
//  Created by Artur on 22.09.2024.
//

import SwiftUI

struct QuizView: View {
    
    let questions = [
        "What is the main ingredient in chocolate?",
        
        "Which dessert is traditionally served at the end of a French meal?",
        
        "What type of dessert is a “macaron”?",
        
        "What country is famous for its baklava?",
        
        "Which dessert is made from layers of filo dough, honey, and nuts?",
        
        "What is the primary flavor of a traditional Tiramisu?",
        
        "Which dessert originated in Italy?",
        
        "Which of these is a traditional British dessert?",
        
        "Which fruit is typically used in a Pavlova dessert?",
        
        "What dessert is often associated with New York?"
        
    ]
    
    var wordAnswer: [[String]] = [
        ["Milk", "Sugar", "Cocoa beans", "Butter"],
        
        ["Tiramisu", "Pavlova", "Éclair", "Crème Brûlée"],
        
        ["A pastry", "A cookie", "A cake", "A pie"],
        
        ["Greece", "Italy", "Turkey", "France"],
        
        ["Baklava", "Cheesecake", "Brownie", "Ice cream cake"],
        
        ["Vanilla", "Coffee", "Lemon", "Chocolate"],
        
        ["1Cheesecake", "Gelato", "Brownie", "Éclair"],
        
        ["Panna Cotta", "Sticky Toffee Pudding", "CCrème Brûlée", "Churros"],
        
        ["Pineapple", "Strawberry", "Banana", "Kiwi"],
        
        ["Brownie", "New York-style Cheesecake", "PApple Pie", "Macaron"]
        
    ]
    
    
    var wrong = [3 ,4, 2, 3, 1, 2, 2, 2, 4,2]
    @State private var numberQuestions = 0
    @State private var timeRemaining = 45 // Начальное время
    @State private var timerRunning = false // Флаг, чтобы отслеживать состояние таймера
    @State private var timer: Timer?
    @State private var count = 0
    @State private var wrongg = 0
    @State private var one = false
    @State private var two = false
    @State private var thre = false
    
    @State private var one2 = false
    @State private var two2 = false
    @State private var thre2 = false
    
    @State private var one3 = false
    @State private var two3 = false
    @State private var thre3 = false
    
    @State private var one4 = false
    @State private var two4 = false
    @State private var thre4 = false
    
    @Environment(\.dismiss) var dismiss
    @State private var savedBak: Int = {
        let initialValue = 1
        let key = "bac"
        if UserDefaults.standard.object(forKey: key) == nil {
            UserDefaults.standard.set(initialValue, forKey: key)
        }
        return UserDefaults.standard.integer(forKey: key)
    }()
    @State private var savedValue: Int = {
        let initialValue = 500
        let key = "points"
        if UserDefaults.standard.object(forKey: key) == nil {
            UserDefaults.standard.set(initialValue, forKey: key)
        }
        return UserDefaults.standard.integer(forKey: key)
    }()
    @StateObject private var saveBac = SaveBac()
    var body: some View {
        ZStack{
            BackgroundView(number: saveBac.value)
           
            
        
            
            VStack{
                HStack {
                    Button(action: {
                        self.dismiss()
                    }) {
                        Image("back")
                    }
                    .padding(.leading, 20)
                    
                    Image("Quiz")
                        .padding(.leading, 20)
                    Spacer()
                    Image("Group 11").padding(.leading, 20)
                    Text("\(timeRemaining)")
                        .foregroundColor(.white)
                        .font(.title.bold()).padding(.trailing, 50)
                }
                .padding(.top, 50)
                Text("\(questions[numberQuestions])")
                    .foregroundColor(.white)
                    .font(.custom("Lalezar", size: 30))
                    .multilineTextAlignment(.center)
                    .padding(30)
                    .background(Color("color1"))
                    .cornerRadius(20)
                    .padding(.top, 40)
                    .padding(.horizontal)
                
                HStack {
                    buttonWithDelay(index: 0, one: $one, two: $two, three: $thre)
                    buttonWithDelay(index: 1, one: $one2, two: $two2, three: $thre2)
                }
                
                HStack {
                    buttonWithDelay(index: 2, one: $one3, two: $two3, three: $thre3)
                    buttonWithDelay(index: 3, one: $one4, two: $two4, three: $thre4)
                }
                Spacer()
            }
            
            // Full-screen overlays
            if numberQuestions == wrong.count - 1 {
                if wrongg >= 7 {
                    resultOverlay(imageName: "win", action: {
                        increaseAndSaveValue(by: 150)
                        stopTimer()
                        self.dismiss()
                    })
                } else {
                    resultOverlay(imageName: "ower", action: {
                        stopTimer()
                        self.dismiss()
                    })
                }
            }
            
            if timeRemaining == 0 {
                resultOverlay(imageName: "ower", action: {
                    stopTimer()
                    self.dismiss()
                })
            }
        }.frame(maxWidth: .infinity,maxHeight: .infinity)
            .onAppear {
                startTimer()
            }
        
        
}
    
func buttonWithDelay(index: Int, one: Binding<Bool>, two: Binding<Bool>, three: Binding<Bool>) -> some View {
    Button(action: {
        one.wrappedValue.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if wrong[numberQuestions] == index + 1 {
                two.wrappedValue.toggle()
                one.wrappedValue.toggle()
                wrongg += 1
            } else {
                three.wrappedValue.toggle()
                one.wrappedValue.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if wrong[numberQuestions] == index + 1 {
                    two.wrappedValue.toggle()
                } else {
                    three.wrappedValue.toggle()
                }
                if numberQuestions < wrong.count - 1 {
                    numberQuestions += 1
                }
            }
        }
    }, label: {
        Text("\(wordAnswer[numberQuestions][index])")
            .foregroundColor(.white)
            .font(.custom("Lalezar", size: 20))
            .multilineTextAlignment(.center)
            .padding(30)
    })
    .frame(width: 180, height: 100)
    .background(getBackgroundColor(index: index, one: one, two: two, three: three))
    .cornerRadius(20)
}

// Overlay для результата на весь экран
func resultOverlay(imageName: String, action: @escaping () -> Void) -> some View {
    VStack {
        ZStack {
            Image(imageName)
            Button {
                action()
            } label: {
                Image("home")
            }
            .padding(.top, 130)
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.black).ignoresSafeArea())
}

// Получение цвета фона кнопки в зависимости от состояния
func getBackgroundColor(index: Int, one: Binding<Bool>, two: Binding<Bool>, three: Binding<Bool>) -> Color {
    if one.wrappedValue {
        return Color("baci1")
    } else if two.wrappedValue {
        return Color("baci2")
    } else if three.wrappedValue {
        return Color("baci3")
    } else {
        return Color("color1")
    }
}
    // Получение цвета фона кнопки в зависимости от состояния
 
//
    func startTimer() {
        guard !timerRunning else { return }
        timerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
                print("Таймер завершён")
                timerRunning = false
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerRunning = false
    }
    
    func increaseAndSaveValue(by amount: Int) {
        savedValue += amount
        UserDefaults.standard.set(savedValue, forKey: "points")
        print("Loaded value: \(savedValue)")
    }
    
   

}
#Preview {
    QuizView()
}
