//
//  ContentView.swift
//  Bona Puzzle Land
//
//  Created by Artur on 19.09.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var rules = false
    @State private var bonus = false
    @State private var play = false
    @State private var quiz = false
    @State private var shope = false
    @State private var settinfs = false
    @State private var showAlert = false
    @State private var lastButtonTapDate: Date? = UserDefaults.standard.object(forKey: "lastButtonTapDate") as? Date
    @StateObject private var savePoints = SavePoints()
    var body: some View {
        VStack {
            bu
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,maxHeight: .infinity)
            .background(Image("launch")
                .ignoresSafeArea()
            )
            .fullScreenCover(isPresented: $rules, content: {
                RulesView()
            })
            .fullScreenCover(isPresented: $play, content: {
                SelectLevelView()
            })
            .fullScreenCover(isPresented: $quiz, content: {
                QuizView()
            })
            .fullScreenCover(isPresented: $shope, content: {
                ShopView()
            })
            .fullScreenCover(isPresented: $settinfs, content: {
                SetingsView()
            })
            .fullScreenCover(isPresented: $bonus, content: {
                DailyBonusView()
            })
    }
    
    private var bu: some View{
        VStack{
            HStack{
                Image("Group 9")
                    .overlay {
                        Text("\(savePoints.value)")
                            .foregroundColor(.white)
                            .padding(.leading,20)
                            .font(.title3.bold())
                    }.padding(.leading,20)
                Spacer()
                Button {
                    rules.toggle()
                } label: {
                   Image("Group 1")
                }.padding(.trailing,20)

            }
            
            Button {
                checkButtonTap()
            } label: {
              Image("Group 2")
            }.padding(.top,250).alert(isPresented: $showAlert) {
                Alert(title: Text("Notification"), message: Text("This feature is available once a day."), dismissButton: .default(Text("OK")))
            }

            Button {
                play.toggle()
            } label: {
              Image("button")
            }.padding(.top,0)
            
            Button {
                quiz.toggle()
            } label: {
              Image("button1")
            }.padding(.top,0)
            
            HStack{
                Button {
                    shope.toggle()
                } label: {
                  Image("button3")
                }
//                Button {
//                  
//                } label: {
//                  Image("button4")
//                }
                
                Button {
                    settinfs.toggle()
                } label: {
                  Image("button5")
                }
            }.padding(.top,20)
            Spacer()
        }
    }
    private func checkButtonTap() {
        let currentDate = Date()
        let calendar = Calendar.current
        
        if let lastTapDate = lastButtonTapDate {
            if let difference = calendar.dateComponents([.day], from: lastTapDate, to: currentDate).day, difference >= 1 {
                proceedToFullScreen()
            } else {
                showAlert.toggle()
            }
        } else {
            proceedToFullScreen()
        }
    }
        private func proceedToFullScreen() {
            lastButtonTapDate = Date()
            UserDefaults.standard.set(lastButtonTapDate, forKey: "lastButtonTapDate")
            bonus.toggle()
        }
    }



#Preview {
    ContentView()
}
