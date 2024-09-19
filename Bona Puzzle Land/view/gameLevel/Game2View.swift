import SwiftUI

struct Game2View: View {
    
    @State private var savedValue: Int = {
        let initialValue = 500
        let key = "points"
        if UserDefaults.standard.object(forKey: key) == nil {
            UserDefaults.standard.set(initialValue, forKey: key)
        }
        return UserDefaults.standard.integer(forKey: key)
    }()
    @State private var image1Position: CGPoint = .zero
    @State private var image2Position: CGPoint = .zero
    @State private var image3Position: CGPoint = .zero // Добавлена позиция для третьего изображения

    @State private var isFullScreenPresented = false
    @State private var restartViewID = UUID()

    @State private var img1 = false
    @State private var img2 = false
    @State private var img3 = false // Добавлено состояние для третьего изображения

    @State private var currentPartIndex = 0
    
    @State private var timeRemaining = 20 // Начальное время
    @State private var timerRunning = false // Флаг для отслеживания состояния таймера
    @State private var timer: Timer?
    @State private var placedPartsCount = 0
    @State private var count = 0
    
    @State private var frames: [CGRect] = Array(repeating: .zero, count: 3) // Рамки всех изображений
    @State private var positions: [CGSize] = Array(repeating: .zero, count: 3) // Позиции частей
    @State private var placedParts: [Bool] = Array(repeating: false, count: 3) // Отслеживание размещённых частей
    @Environment(\.dismiss) var dismiss
    @State private var currentOffset: CGSize = .zero // Смещение текущей части
    @State private var currentFrame: CGRect = .zero // Рамка текущей части
    @State private var movingFrame: CGRect = .zero
    
    @StateObject private var saveBac = SaveBac()
    @StateObject private var savePoints = SavePoints()

    let puzzleParts = ["x1", "x2", "x3"] // Имена изображений трех частей

    var body: some View {
        ZStack {
            BackgroundView(number: saveBac.value)
            VStack {
                HStack {
                    Button(action: {
                        self.dismiss()
                    }) {
                        Image("back")
                    }
                    .padding(.leading, 20)
                    
                    Image("Level 2")
                        .padding(.leading, 20)
                    
                    Image("Group 11").padding(.leading, 20)
                    Text("\(timeRemaining)")
                        .foregroundColor(.white)
                        .font(.title.bold())
                }
                .padding(.top, 50)
               
                VStack {
                    puzzlePieceView(imageName: !img1 ? "Rectangle 64" : puzzleParts[0], index: 0, width: 240, height: 120)
                    HStack{
                        puzzlePieceView(imageName: !img2 ? "Rectangle 64" : puzzleParts[1], index: 1, width: 120, height: 120)
                        puzzlePieceView(imageName: !img3 ? "Rectangle 64" : puzzleParts[2], index: 2, width: 120, height: 120)
                    }
                }.padding(.top, 150)
                 .padding(.bottom, 100)
                
                if currentPartIndex < puzzleParts.count {
                    draggablePuzzlePiece(index: currentPartIndex)
                }
                Spacer()
            }

            if count == 3 { // Изменено условие для трех пазлов
                VStack {
                    ZStack {
                        Image("win")
                        Button {
                            increaseAndSaveValue(by: 50)
                            self.dismiss()
                        } label: {
                            Image("home")
                        }
                        .padding(.top, 190)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.ignoresSafeArea())
            }
            
            if timeRemaining == 0 {
                VStack {
                    ZStack {
                        Image("ower")
                        Button {
                            self.dismiss()
                        } label: {
                            Image("home")
                        }
                        .padding(.top, 160)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.ignoresSafeArea())
            }
        }
        .onAppear {
            startTimer()
        }
    }

    func puzzlePieceView(imageName: String, index: Int, width: CGFloat, height: CGFloat) -> some View {
        Image(imageName)
            .resizable()
            .frame(width: width, height: height)
            .background(GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        frames[index] = geometry.frame(in: .global)
                        updatePosition(for: index, with: geometry.frame(in: .global).origin)
                    }
                    .onChange(of: geometry.frame(in: .global)) { newValue in
                        frames[index] = newValue
                        updatePosition(for: index, with: newValue.origin)
                    }
            })
    }
    
    
    func draggablePuzzlePiece(index: Int) -> some View {
        GeometryReader { geometry in
            Image(puzzleParts[index])
                .resizable()
                .frame(width: 180, height: 180)
                .offset(currentOffset)
                .border(Color.orange, width: 2)
                .background(
                    GeometryReader { innerGeometry in
                        Color.clear
                            .onAppear {
                                currentFrame = innerGeometry.frame(in: .global)
                            }
                            .onChange(of: currentOffset) {
                                movingFrame = CGRect(
                                    origin: CGPoint(
                                        x: innerGeometry.frame(in: .global).minX + currentOffset.width,
                                        y: innerGeometry.frame(in: .global).minY + currentOffset.height
                                    ),
                                    size: CGSize(width: 80, height: 80)
                                )
                            }
                    }
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            currentOffset = CGSize(width: value.translation.width + positions[currentPartIndex].width,
                                                   height: value.translation.height + positions[currentPartIndex].height)
                        }
                        .onEnded { value in
                            positions[currentPartIndex].width += value.translation.width
                            positions[currentPartIndex].height += value.translation.height
                            currentOffset = positions[currentPartIndex]
                            
                            // Используем последние координаты во время движения для проверки при отпускании
                            self.currentFrame = self.movingFrame
                            print("Координаты текущего объекта (при отпускании): \(self.currentFrame)")
                            
                            let tolerance: CGFloat = 6 // Пониженный допуск для точного пересечения
                            let imagePositions = [image1Position, image2Position, image3Position]
                            
                            // Проходим по всем объектам и проверяем пересечение
                            for (index, position) in imagePositions.enumerated() {
                                // Создаем рамку для проверки пересечения
                                let targetFrame = CGRect(origin: position, size: CGSize(width: 80, height: 80))
                                
                                if self.checkIntersectionWithTolerance(self.currentFrame, targetFrame, tolerance: tolerance) {
                                    if currentPartIndex == index {
                                        switch index {
                                        case 0:
                                            img1.toggle()
                                        case 1:
                                            img2.toggle()
                                        case 2:
                                            img3.toggle()
                                        default:
                                            break
                                        }
                                        count += 1
                                        currentPartIndex = (currentPartIndex + 1) % puzzleParts.count
                                        if count == 3 {
                                            stopTimer()
                                        }
                                        
                                        // Сбрасываем позицию текущего изображения
                                        positions[currentPartIndex] = .zero
                                        currentOffset = .zero
                                        
                                        // Обозначаем текущее изображение как размещённое
                                        placedParts[currentPartIndex] = true
                                        // Переключаем на следующее изображение
                                        break
                                    }
                                }
                            }
                            
                            // Если нет пересечения, оставляем изображение на текущей позиции
                            if !placedParts[currentPartIndex] {
                                positions[currentPartIndex] = currentOffset
                            }
                        }
                )
                .onAppear {
                    // Проверка пересечения при первом рендере
                    updateAllFrames() // Убедитесь, что обновляются все позиции перед проверкой
                }
        }
        .frame(width: 180, height: 180)
    }
    
    func updateAllFrames() {
        // Обновление всех позиций, чтобы быть уверенным, что все рамки обновлены правильно
        frames[0] = CGRect(origin: image1Position, size: CGSize(width: 80, height: 80))
        frames[1] = CGRect(origin: image2Position, size: CGSize(width: 80, height: 80))
        frames[2] = CGRect(origin: image3Position, size: CGSize(width: 80, height: 80))
    }
    
    func updatePosition(for index: Int, with origin: CGPoint) {
        switch index {
        case 0:
            image1Position = origin
        case 1:
            image2Position = origin
        case 2:
            image3Position = origin
        default:
            break
        }
    }
    
    func checkIntersectionWithTolerance(_ rect1: CGRect, _ rect2: CGRect, tolerance: CGFloat) -> Bool {
        let expandedRect1 = rect1.insetBy(dx: -tolerance, dy: -tolerance)
        return expandedRect1.intersects(rect2)
    }
    
    func startTimer() {
        guard !timerRunning else { return }
        timerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                timerRunning = false
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerRunning = false
    }
    func increaseAndSaveValue(by amount: Int) {
           savedValue += amount
           UserDefaults.standard.set(savedValue, forKey: "points")
           print("Loaded value: \(savedValue)")
       }
}

struct Game2View_Previews: PreviewProvider {
    static var previews: some View {
        Game2View()
    }
}
