//
//  BackgroundView.swift
//  Bona Puzzle Land
//
//  Created by Artur on 19.09.2024.
//

import SwiftUI

struct BackgroundView: View {
    let number: Int
    
    var body: some View {
        ZStack {
            Group {
                if number == 1 {
                    Image("background1")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                } else if number == 2 {
                    Image("background2")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                } else if number == 3 {
                    Image("background3")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                } else if number == 4 {
                    Image("background4")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    
                }
                else if number == 5 {
                    Image("background5")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    
                }
                else {
                    Color.black
                        .ignoresSafeArea()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    BackgroundView(number: 1)
}
