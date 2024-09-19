import SwiftUI

struct Game7View: View {
    @State private var savedValue: Int = {
        let initialValue = 500
        let key = "points"
        if UserDefaults.standard.object(forKey: key) == nil {
            UserDefaults.standard.set(initialValue, forKey: key)
        }
        return UserDefaults.standard.integer(forKey: key)
    }()
    @State private var imagePositions: [CGPoint] = Array(repeating: .zero, count: 8) // Positions for eight images

    @State private var isFullScreenPresented = false
    @State private var restartViewID = UUID()

    @State private var imgs: [Bool] = Array(repeating: false, count: 8) // States for eight images

    @State private var currentPartIndex = 0
    
    @State private var timeRemaining = 20 // Start time
    @State private var timerRunning = false // Flag for timer status
    @State private var timer: Timer?
    @State private var placedPartsCount = 0
    @State private var count = 0
    
    @State private var frames: [CGRect] = Array(repeating: .zero, count: 8) // Frames of all images
    @State private var positions: [CGSize] = Array(repeating: .zero, count: 8) // Positions of parts
    @State private var placedParts: [Bool] = Array(repeating: false, count: 8) // Tracking placed parts
    @Environment(\.dismiss) var dismiss
    @State private var currentOffset: CGSize = .zero // Offset of the current part
    @State private var currentFrame: CGRect = .zero // Frame of the current part
    @State private var movingFrame: CGRect = .zero
    
    @StateObject private var saveBac = SaveBac()
    @StateObject private var savePoints = SavePoints()

    let puzzleParts = ["f1", "f2", "f3", "f4", "f5", "f6", "f7", "f8"] // Names of eight parts

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
                    
                    Image("Level 7")
                        .padding(.leading, 20)
                    
                    Image("Group 11").padding(.leading, 20)
                    Text("\(timeRemaining)")
                        .foregroundColor(.white)
                        .font(.title.bold())
                }
                .padding(.top, 50)
               
                VStack {
                    HStack {
                        VStack {
                            puzzlePieceView(imageName: !imgs[0] ? "Rectangle 64" : puzzleParts[0], index: 0, width: 120, height: 60)
                            puzzlePieceView(imageName: !imgs[1] ? "Rectangle 64" : puzzleParts[1], index: 1, width: 120, height: 60)
                            
                        }
                        HStack {
                            puzzlePieceView(imageName: !imgs[2] ? "Rectangle 64" : puzzleParts[2], index: 2, width: 60, height: 120)
                            puzzlePieceView(imageName: !imgs[3] ? "Rectangle 64" : puzzleParts[3], index: 3, width: 60, height: 120)
                        }
                      
                    }
                     
                      
                    HStack {
                        HStack{
                            puzzlePieceView(imageName: !imgs[4] ? "Rectangle 64" : puzzleParts[4], index: 4, width: 60, height: 120)
                            puzzlePieceView(imageName: !imgs[5] ? "Rectangle 64" : puzzleParts[5], index: 5, width: 60, height: 120)
                        }
                        VStack{
                        puzzlePieceView(imageName: !imgs[6] ? "Rectangle 64" : puzzleParts[6], index: 6, width: 120, height: 60)
                        puzzlePieceView(imageName: !imgs[7] ? "Rectangle 64" : puzzleParts[7], index: 7, width: 120, height: 60)
                    }
                    }
                }.padding(.top, 150)
                 .padding(.bottom, 100)
                
                if currentPartIndex < puzzleParts.count {
                    draggablePuzzlePiece(index: currentPartIndex)
                }
                Spacer()
            }

            if count == 8 { // Updated condition for eight puzzles
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
                            
                            // Use the latest coordinates during movement for checking on release
                            self.currentFrame = self.movingFrame
                            
                            let tolerance: CGFloat = 6 // Reduced tolerance for precise intersection
                            let imagePositions = imagePositions
                            
                            // Loop through all objects and check for intersection
                            for (index, position) in imagePositions.enumerated() {
                                let targetFrame = CGRect(origin: position, size: CGSize(width: 80, height: 80))
                                
                                if self.checkIntersectionWithTolerance(self.currentFrame, targetFrame, tolerance: tolerance) {
                                    if currentPartIndex == index {
                                        imgs[index].toggle()
                                        count += 1
                                        currentPartIndex = (currentPartIndex + 1) % puzzleParts.count
                                        if count == 8 {
                                            stopTimer()
                                        }
                                        
                                        // Reset the position of the current image
                                        positions[currentPartIndex] = .zero
                                        currentOffset = .zero
                                        
                                        // Mark the current image as placed
                                        placedParts[currentPartIndex] = true
                                        // Switch to the next image
                                        break
                                    }
                                }
                            }
                            
                            // If there is no intersection, leave the image at the current position
                            if !placedParts[currentPartIndex] {
                                positions[currentPartIndex] = currentOffset
                            }
                        }
                )
                .onAppear {
                    // Check for intersection on initial render
                    updateAllFrames() // Ensure all positions are updated before checking
                }
        }
        .frame(width: 180, height: 180)
    }
    
    func updateAllFrames() {
        for index in frames.indices {
            frames[index] = CGRect(origin: imagePositions[index], size: CGSize(width: 80, height: 80))
        }
    }
    
    func updatePosition(for index: Int, with origin: CGPoint) {
        if index >= 0 && index < imagePositions.count {
            imagePositions[index] = origin
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
    }
}

struct Game7View_Previews: PreviewProvider {
    static var previews: some View {
        Game7View()
    }
}
