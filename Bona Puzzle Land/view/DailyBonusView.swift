import SwiftUI

struct DailyBonusView: View {
    @StateObject private var saveBac = SaveBac() // Управляет фоном в зависимости от накопленных баллов
    @StateObject private var savePoints = SavePoints() // Управляет баллами пользователя
    @Environment(\.dismiss) var dismiss
    @State private var showBonus = false // Исправлена опечатка в названии переменной

    var body: some View {
        ZStack {
            BackgroundView(number: saveBac.value) // Отображение фона на основе баллов
            VStack {
                HStack {
                    Button(action: {
                        self.dismiss()
                    }, label: {
                        Image("back") // Кнопка для возвращения
                    })
                    .padding(.leading, 20)
                    
                    Button(action: {
                        showBonus.toggle()
                    }, label: {
                        Image("Daily Bonus").padding(.leading, 20)
                    })
                    
                    
                    Spacer()
                }
                .padding(.top, 50)
                
                Image("Group 3") // Здесь должно быть описание изображения, что оно представляет
               Image("Choose one of the cards and find out what valuable prize awaits you_")
                
                Button(action: {
                    self.showBonus.toggle() // Показать или скрыть бонус
                }, label: {
                    Image("Group 10") // Картинка для кнопки
                })
                .padding(.top, 30)
                
                Spacer()
            }
            .overlay(
                VStack {
                    if showBonus {
                        ZStack {
                            Color.black.opacity(0.9).ignoresSafeArea()
                            Image("Group 123").padding(.bottom, 300).overlay {
                                Button(action: {
                                    savePoints.saveValue(100) // Добавляет 100 баллов
                                    self.dismiss()
                                }, label: {
                                    Image("home").padding(.top, 10)
                                })
                            }
                           
                        }
                        .transition(.opacity) // Плавное появление и исчезновение
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .zIndex(1) // Убедиться, что оверлей находится поверх всего остального содержимого
            )
        }
    }
}

// Превью для Xcode
struct DailyBonusView_Previews: PreviewProvider {
    static var previews: some View {
        DailyBonusView()
    }
}
