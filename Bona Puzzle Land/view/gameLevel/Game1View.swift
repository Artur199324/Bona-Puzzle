import SwiftUI

struct Game1View: View {
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

    @State private var isFullScreenPresented = false
    @State private var restartViewID = UUID()

    @State private var img1 = false
    @State private var img2 = false

    @State private var currentPartIndex = 0
    
    @State private var timeRemaining = 20 // Начальное время
    @State private var timerRunning = false // Флаг для отслеживания состояния таймера
    @State private var timer: Timer?
    @State private var placedPartsCount = 0
    @State private var count = 0
    
    @State private var frames: [CGRect] = Array(repeating: .zero, count: 2) // Рамки всех изображений
    @State private var positions: [CGSize] = Array(repeating: .zero, count: 2) // Позиции частей
    @State private var placedParts: [Bool] = Array(repeating: false, count: 2) // Отслеживание размещённых частей
    @Environment(\.dismiss) var dismiss
    @State private var currentOffset: CGSize = .zero // Смещение текущей части
    @State private var currentFrame: CGRect = .zero // Рамка текущей части
    @State private var movingFrame: CGRect = .zero
    
    @StateObject private var saveBac = SaveBac()
    @StateObject private var savePoints = SavePoints()

    let puzzleParts = ["Mask group", "Mask group2"] // Имена изображений частей

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
                    
                    Image("Level 1")
                        .padding(.leading, 20)
                    
                    Image("Group 11").padding(.leading, 20)
                    Text("\(timeRemaining)")
                        .foregroundColor(.white)
                        .font(.title.bold())
                }
                .padding(.top, 50)
               
                VStack {
                    puzzlePieceView(imageName: !img1 ? "Rectangle 64" : puzzleParts[0], index: 0)
                    puzzlePieceView(imageName: !img2 ? "Rectangle 64" : puzzleParts[1], index: 1)
                }.padding(.top, 150)
                 .padding(.bottom, 100)
                
                if currentPartIndex < puzzleParts.count {
                    draggablePuzzlePiece(index: currentPartIndex)
                }
                Spacer()
            }

            if count == 2 {
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

    func puzzlePieceView(imageName: String, index: Int) -> some View {
        Image(imageName)
            .resizable()
            .frame(width: 320, height: 120)
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
                            let imagePositions = [image1Position, image2Position]
                            
                            // Проходим по всем объектам и проверяем пересечение
                            for (index, position) in imagePositions.enumerated() {
                                // Создаем рамку для проверки пересечения
                                let targetFrame = CGRect(origin: position, size: CGSize(width: 80, height: 80))
                                
                                // Проверка, чтобы не сравнивать с самим собой
                                if checkIntersectionWithTolerance(self.currentFrame, targetFrame, tolerance: tolerance) {
                         
                                    
                                    if currentPartIndex == index{
                                        if index == 0{
                                            img1.toggle()
                                            count += 1
                                        } else if index == 1{
                                            img2.toggle()
                                            count += 1
                                        }
                                        currentPartIndex = (currentPartIndex + 1) % puzzleParts.count
                                        
                                        if count == 2 {
                                            stopTimer()
                                        }
                                        
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
                            
                            // Если нет пересечения, оставляем изображение на текущей позиции
                            if !placedParts[currentPartIndex] {
                                positions[currentPartIndex] = currentOffset
                            }
                        }
                )
                .onAppear {
                    // Проверка пересечения при первом рендере
                    updateAllFrames() // Убедитесь, что обновляются все позиции перед проверкой
                    let tolerance: CGFloat = 10
                    for (index, frame) in frames.enumerated() {
                        if checkIntersectionWithTolerance(currentFrame, frame, tolerance: tolerance) {
                            print("Пересечение при инициализации с объектом \(index)")
                        }
                    }
                }
        }
        .frame(width: 180, height: 180)
    }
    func updateAllFrames() {
        // Обновление всех позиций, чтобы быть уверенным, что все рамки обновлены правильно
        self.frames[0] = CGRect(origin: self.image1Position, size: CGSize(width: 80, height: 80))
        self.frames[1] = CGRect(origin: self.image2Position, size: CGSize(width: 80, height: 80))
    
    }
    func updatePosition(for index: Int, with origin: CGPoint) {
        if index == 0 {
            image1Position = origin
        } else if index == 1 {
            image2Position = origin
        }
    }
    
    func checkPlacement(for index: Int) {
        let tolerance: CGFloat = 6
        let imagePositions = [image1Position, image2Position]
        
        for (imageIndex, position) in imagePositions.enumerated() {
            let targetFrame = CGRect(origin: position, size: CGSize(width: 80, height: 80))
            
            if checkIntersectionWithTolerance(currentFrame, targetFrame, tolerance: tolerance), currentPartIndex == imageIndex {
                handleCorrectPlacement(for: imageIndex)
            }
        }
    }
    
    func handleCorrectPlacement(for index: Int) {
        if index == 0 {
            img1.toggle()
        } else if index == 1 {
            img2.toggle()
        }
        
        placedPartsCount += 1
        if placedPartsCount == puzzleParts.count {
            stopTimer()
        }
        
        positions[currentPartIndex] = .zero
        currentOffset = .zero
        placedParts[currentPartIndex] = true
        currentPartIndex = (currentPartIndex + 1) % puzzleParts.count
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

#Preview {
    Game1View()
}
