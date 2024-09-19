//
//  SelectLevelView.swift
//  Bona Puzzle Land
//
//  Created by Artur on 20.09.2024.
//

import SwiftUI

struct SelectLevelView: View {
    @StateObject private var saveBac = SaveBac()
    @StateObject private var savePoints = SavePoints()
    @StateObject private var saveLevel = SaveLevel()
    @State private var showAlert = false
    @State private var savedValue: Int = {
        let initialValue = 500
        let key = "points"
        if UserDefaults.standard.object(forKey: key) == nil {
            UserDefaults.standard.set(initialValue, forKey: key)
        }
        return UserDefaults.standard.integer(forKey: key)
    }()
    @State private var level1 = false
    @State private var level2 = false
    @State private var level3 = false
    @State private var level4 = false
    @State private var level5 = false
    @State private var level6 = false
    @State private var level7 = false
    @State private var level8 = false
    @State private var level9 = false
    @State private var level10 = false
    @State private var level11 = false
    @State private var level12 = false
    @State private var level13 = false
    @State private var level14 = false
    @State private var level15 = false
    @State private var level16 = false
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack{
            BackgroundView(number: saveBac.value)
            VStack{
                HStack{
                    Button(action: {
                        self.dismiss()
                    }, label: {
                        Image("back")
                    })
                    .padding(.leading,20)
                    Image("Select Level").padding(.leading,2)
                    Spacer()
                    Image("Group 9")
                        .overlay {
                            Text("\(savedValue)")
                                .foregroundColor(.white)
                                .padding(.leading,20)
                                .font(.title3.bold())
                        }.padding(.trailing,20)
                }.padding(.top,50)
                
                HStack{
                    Button(action: {
                        level1.toggle()
                    }, label: {
                        Image("s1")
                    })
                    
                    Button(action: {
                        if !saveLevel.retrieve(for: 1) {
                            if savedValue >= 100 {
                                saveLevel.save(true, for: 1)
                                savePoints.saveValue(-100)
                            }else{  showAlert.toggle()}
                        }else{
                            level2.toggle()
                        }
                    }, label: {
                        Image(saveLevel.retrieve(for: 1) ? "s2" : "d2")
                    })
                    
                    Button(action: {
                       
                        if !saveLevel.retrieve(for: 2) {
                            if savedValue >= 150 {
                                saveLevel.save(true, for: 2)
                                savePoints.saveValue(-150)
                            }else{  showAlert.toggle()}
                        }else{
                            level3.toggle()
                        }
                    }, label: {
                        Image(saveLevel.retrieve(for: 2) ? "s3" : "d3")
                    })
                    
                    Button(action: {
                      
                        if !saveLevel.retrieve(for: 3) {
                            if savedValue >= 200 {
                                saveLevel.save(true, for: 3)
                                savePoints.saveValue(-200)
                            }else{  showAlert.toggle()}
                        }else{
                            level4.toggle()
                        }
                    }, label: {
                        Image(saveLevel.retrieve(for: 3) ? "s4" : "d4")
                    })
                    
                }.padding(.top,20)
                
                HStack{
                    Button(action: {
                       
                        if !saveLevel.retrieve(for: 4) {
                            if savedValue >= 250 {
                                saveLevel.save(true, for: 4)
                                savePoints.saveValue(-250)
                            }else{  showAlert.toggle()}
                        }
                        else{
                            level5.toggle()
                        }
                    }, label: {
                        Image(saveLevel.retrieve(for: 4) ? "s5" : "d5")
                    })
                    
                    Button(action: {
                    
                        if !saveLevel.retrieve(for: 5) {
                            if savePoints.value >= 300 {
                                saveLevel.save(true, for: 5)
                                savePoints.saveValue(-300)
                            }else{  showAlert.toggle()}
                        } else{
                            level6.toggle()
                        }
                    }, label: {
                        Image(saveLevel.retrieve(for: 5) ? "s6" : "d6")
                    })
                    
                    Button(action: {
                    
                        if !saveLevel.retrieve(for: 6) {
                            if savedValue >= 350 {
                                saveLevel.save(true, for: 6)
                                savePoints.saveValue(-350)
                            }else{  showAlert.toggle()}
                        }else{
                            level7.toggle()
                        }
                    }, label: {
                        Image(saveLevel.retrieve(for: 6) ? "s7" : "d7")
                    })
                    
                    Button(action: {
                        if !saveLevel.retrieve(for: 7) {
                            if savedValue >= 400 {
                                saveLevel.save(true, for: 7)
                                savePoints.saveValue(-400)
                            }else{  showAlert.toggle()}
                        }
                    }, label: {
                        Image(saveLevel.retrieve(for: 7) ? "s8" : "d8")
                    })
                    
                }
                
                
                HStack{
                    Button(action: {
                        if !saveLevel.retrieve(for: 8) {
                            if savedValue >= 450 {
                                saveLevel.save(true, for: 8)
                                savePoints.saveValue(-450)
                            }else{  showAlert.toggle()}
                        }
                    }, label: {
                        Image(saveLevel.retrieve(for: 8) ? "s9" : "d9")
                    })
                    
                    
                    Button(action: {
                        if !saveLevel.retrieve(for: 9) {
                            if savedValue >= 500 {
                                saveLevel.save(true, for: 9)
                                savePoints.saveValue(-500)
                            }else{  showAlert.toggle()}
                        }
                    }, label: {
                        Image(saveLevel.retrieve(for: 9) ? "s10" : "d10")
                    })
                    
                    Button(action: {
                        if !saveLevel.retrieve(for: 10) {
                            if savedValue >= 550 {
                                saveLevel.save(true, for: 10)
                                savePoints.saveValue(-550)
                            }else{  showAlert.toggle()}
                        }
                    }, label: {
                        Image(saveLevel.retrieve(for: 10) ? "s11" : "d11")
                    })
                    
                    Button(action: {
                        if !saveLevel.retrieve(for: 11) {
                            if savedValue >= 600 {
                                saveLevel.save(true, for: 11)
                                savePoints.saveValue(-600)
                            }else{  showAlert.toggle()}
                        }
                    }, label: {
                        Image(saveLevel.retrieve(for: 11) ? "s12" : "d12")
                    })
                    
                }
                
                
                HStack{
                    
                    Button(action: {
                        if !saveLevel.retrieve(for: 12) {
                            if savedValue >= 650 {
                                saveLevel.save(true, for: 12)
                                savePoints.saveValue(-650)
                            }else{  showAlert.toggle()}
                        }
                    }, label: {
                        Image(saveLevel.retrieve(for: 12) ? "s13" : "d13")
                    })
                    
                    
                    Button(action: {
                        if !saveLevel.retrieve(for: 13) {
                            if savedValue >= 700 {
                                saveLevel.save(true, for: 13)
                                savePoints.saveValue(-700)
                            }else{  showAlert.toggle()}
                        }
                    }, label: {
                        Image(saveLevel.retrieve(for: 13) ? "s14" : "d14")
                    })
                    
                    Button(action: {
                        if !saveLevel.retrieve(for: 14) {
                            if savedValue >= 750 {
                                saveLevel.save(true, for: 14)
                                savePoints.saveValue(-750)
                            }else{  showAlert.toggle()}
                        }
                    }, label: {
                        Image(saveLevel.retrieve(for: 14) ? "s15" : "d15")
                    })
                    
                    Button(action: {
                        if !saveLevel.retrieve(for: 15) {
                            if savedValue >= 800 {
                                saveLevel.save(true, for: 15)
                                savePoints.saveValue(-800)
                            }else{  showAlert.toggle()}
                        }
                    }, label: {
                        Image(saveLevel.retrieve(for: 15) ? "s16" : "d16")
                    })
                    
                }
                Spacer()
                
            }.fullScreenCover(isPresented: $level1, content: {
                Game1View()
            })
            .fullScreenCover(isPresented: $level2, content: {
                Game2View()
            })
            .fullScreenCover(isPresented: $level3, content: {
                Game3View()
            })
            .fullScreenCover(isPresented: $level4, content: {
                Game4View()
            })
            .fullScreenCover(isPresented: $level5, content: {
                Game5View()
            })
            
            .fullScreenCover(isPresented: $level6, content: {
                Game6View()
            })
            
            .fullScreenCover(isPresented: $level7, content: {
                Game7View()
            })
            .fullScreenCover(isPresented: $level8, content: {
                Game7View()
            })
            .fullScreenCover(isPresented: $level9, content: {
                Game7View()
            })
            .fullScreenCover(isPresented: $level10, content: {
                Game7View()
            })
            .fullScreenCover(isPresented: $level11, content: {
                Game7View()
            })
            .fullScreenCover(isPresented: $level12, content: {
                Game7View()
            })
            .fullScreenCover(isPresented: $level13, content: {
                Game7View()
            })
            .fullScreenCover(isPresented: $level14, content: {
                Game7View()
            })
            .fullScreenCover(isPresented: $level15, content: {
                Game7View()
            })
            .fullScreenCover(isPresented: $level16, content: {
                Game7View()
            })
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Not enough coins"), message: Text("You don't have enough coins to open the level"), dismissButton: .default(Text("Ок")))
            }
        }
    }
}

#Preview {
    SelectLevelView()
}
