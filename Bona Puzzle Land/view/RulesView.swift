//
//  RulesView.swift
//  Bona Puzzle Land
//
//  Created by Artur on 20.09.2024.
//

import SwiftUI

struct RulesView: View {
    @StateObject private var saveBac = SaveBac()
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
                    Image("Rules").padding(.leading,20)
                    Spacer()
                }.padding(.top,50)
                
                Image("rul").padding(.top,40)
                Spacer()
            }
        }
    }
}

#Preview {
    RulesView()
}
