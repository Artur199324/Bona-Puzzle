//
//  SaveLevel.swift
//  Bona Puzzle Land
//
//  Created by Artur on 20.09.2024.
//

import Foundation

class SaveLevel:ObservableObject{
    private let keys = [
        "q1", "q2", "q3", "q4", "q5", "q6", "q7","q8","q9","q10","q11","q12","q13","q14","q15","q16"
    ]
    
    // Опубликованные переменные для обновления UI при изменении значений
    @Published var booleans: [Bool]

    init() {
        // Инициализация значений из UserDefaults
        booleans = keys.map { UserDefaults.standard.bool(forKey: $0) }
    }

    // Сохранение значения булевой переменной
    func save(_ value: Bool, for index: Int) {
        guard index >= 0 && index < booleans.count else { return }
        booleans[index] = value
        UserDefaults.standard.set(value, forKey: keys[index])
    }

    // Извлечение значения булевой переменной
    func retrieve(for index: Int) -> Bool {
        guard index >= 0 && index < booleans.count else { return false }
        return booleans[index]
    }

    // Переключение значения булевой переменной (toggle)
    func toggle(for index: Int) {
        guard index >= 0 && index < booleans.count else { return }
        booleans[index].toggle()
        save(booleans[index], for: index)
    }
}
