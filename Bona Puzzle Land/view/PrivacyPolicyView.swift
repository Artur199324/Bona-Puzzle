//
//  PrivacyPolicyView.swift
//  Bona Puzzle Land
//
//  Created by Artur on 23.09.2024.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) var dismiss

       var body: some View {
           NavigationView {
               WebView(url: URL(string: "https://www.termsfeed.com/live/56741a49-45ec-40fe-83e5-428f25976e7e")!)
                   .navigationTitle("Privacy Policy")
                   .navigationBarTitleDisplayMode(.inline)
                   .navigationBarItems(trailing: Button(action: {
                       dismiss() // Закрытие представления при нажатии кнопки "Close"
                   }) {
                       Text("Close")
                           .foregroundColor(.blue)
                   })
           }
       }
}

#Preview {
    PrivacyPolicyView()
}
