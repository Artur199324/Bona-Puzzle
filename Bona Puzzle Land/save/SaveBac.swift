//
//  SaveBac.swift
//  Bona Puzzle Land
//
//  Created by Artur on 19.09.2024.
//

import Foundation

class SaveBac : ObservableObject {
    
    @Published var value: Int
    private let key = "bac"
    private let defaultValue = 1

    init() {
    
        if UserDefaults.standard.object(forKey: key) == nil {
            UserDefaults.standard.set(defaultValue, forKey: key)
        }
        self.value = UserDefaults.standard.integer(forKey: key)
    }

    // Метод для сохранения значения
    func saveValue(_ newValue: Int) {
        value = newValue
        UserDefaults.standard.set(newValue, forKey: key)
    }
}
