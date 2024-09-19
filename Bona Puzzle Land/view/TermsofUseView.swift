//
//  TermsofUseView.swift
//  Bona Puzzle Land
//
//  Created by Artur on 23.09.2024.
//

import SwiftUI

struct TermsofUseView: View {
    @Environment(\.dismiss) var dismiss

       var body: some View {
           NavigationView {
               WebView(url: URL(string: "https://sites.google.com/view/termsandconditionsforbonapuzzl/")!)
                   .navigationTitle("Terms of Use")
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
    TermsofUseView()
}
