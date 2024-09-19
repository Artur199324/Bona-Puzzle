//
//  ShopView.swift
//  Bona Puzzle Land
//
//  Created by Artur on 23.09.2024.
//

import SwiftUI

struct ShopView: View {
    @StateObject private var saveBac = SaveBac()
    @StateObject private var savePoints = SavePoints()
    @StateObject private var bacAplua = BacAplua()
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
                    Image("Shop").padding(.leading,20)
                    Spacer()
                    Image("Group 9")
                        .overlay {
                            Text("\(savePoints.value)")
                                .foregroundColor(.white)
                                .padding(.leading,20)
                                .font(.title3.bold())
                        }.padding(.trailing,20)
                }.padding(.top,50)
                
                ScrollView{
                    Button(action: {
                        if !bacAplua.retrieve(for: 0) {
                            if savePoints.value > 200 {
                                bacAplua.save(true, for: 0)
                                savePoints.saveValue(-200)
                            }
                        } else {
                            saveBac.saveValue(2)
                            self.dismiss()
                        }
                    }, label: {
                        Image(bacAplua.retrieve(for: 0) ? "ss1" : "so1")
                    })
                    
                    Button(action: {
                        if !bacAplua.retrieve(for: 1) {
                            if savePoints.value >= 400 {
                                bacAplua.save(true, for: 1)
                                savePoints.saveValue(-400)
                            }
                        } else {
                            saveBac.saveValue(3)
                            self.dismiss()
                        }
                    }, label: {
                        Image(bacAplua.retrieve(for: 1) ? "ss2" : "so2")
                    })
                    
                    Button(action: {
                        if !bacAplua.retrieve(for: 2) {
                            if savePoints.value >= 450 {
                                bacAplua.save(true, for: 2)
                                savePoints.saveValue(-500)
                            }
                        } else {
                            saveBac.saveValue(4)
                            self.dismiss()
                        }
                    }, label: {
                        Image(bacAplua.retrieve(for: 2) ? "ss3" : "so3")
                    })
                    Button(action: {
                        if !bacAplua.retrieve(for: 3) {
                            if savePoints.value >= 450 {
                                bacAplua.save(true, for: 3)
                                savePoints.saveValue(-500)
                            }
                        } else {
                            saveBac.saveValue(4)
                            self.dismiss()
                        }
                    }, label: {
                        Image(bacAplua.retrieve(for: 2) ? "ss4" : "so4")
                    })
                }.padding(.top,50)
            
                Spacer()
            }
        }
    }
}

#Preview {
    ShopView()
}
