//
//  SetingsView.swift
//  Bona Puzzle Land
//
//  Created by Artur on 23.09.2024.
//

import SwiftUI
import StoreKit
struct SetingsView: View {
    @StateObject private var saveBac = SaveBac()
    @Environment(\.dismiss) var dismiss
    @State private var terms = false
    @State private var policy = false
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
                    Image("Settings").padding(.leading,20)
                    Spacer()
                }.padding(.top,50)
                
                Button(action: {
                    requestAppReview()
                }, label: {
                    Image("Group 13")
                }).padding(.top,30)
                Button(action: {
                    terms.toggle()
                }, label: {
                    Image("Group 14")
                })
                Button(action: {
                    policy.toggle()
                }, label: {
                    Image("Group 15")
                })
                
                Spacer()
            }
        }.fullScreenCover(isPresented: $terms, content: {
            TermsofUseView()
        })
        .fullScreenCover(isPresented: $policy, content: {
            PrivacyPolicyView()
        })
    }
    
    func requestAppReview() {
           if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
               SKStoreReviewController.requestReview(in: scene)
           }
       }
}

#Preview {
    SetingsView()
}
