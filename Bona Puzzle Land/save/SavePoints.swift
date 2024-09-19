//
//  SavePoints.swift
//  Bona Puzzle Land
//
//  Created by Artur on 20.09.2024.
//

import Foundation

class SavePoints: ObservableObject {
    @Published var value: Int
    private let key = "points"
    private let defaultValue = 500

    init() {
        // Устанавливаем значение по умолчанию, если его нет в UserDefaults
        if UserDefaults.standard.object(forKey: key) == nil {
            UserDefaults.standard.set(defaultValue, forKey: key)
        }
        // Инициализируем значение из UserDefaults
        self.value = UserDefaults.standard.integer(forKey: key)
    }

    // Метод для сохранения значения
    func saveValue(_ newValue: Int) {
        // Добавляем новое значение к текущему
        value += newValue
        // Сохраняем обновленное значение в UserDefaults
        UserDefaults.standard.set(value, forKey: key)
    }
}
